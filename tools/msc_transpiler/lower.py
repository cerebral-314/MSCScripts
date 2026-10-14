"""Lowering one .script event handler into an AngelScript method.

Control flow follows CScript::Script_ExecuteCmds exactly:
  * `if ( ... )` with a body becomes if/else; `else if` chains stay chains
  * an old-style `if a op b` (no parentheses) stops the rest of the list it is in when false,
    so the rest of that list becomes its body (an early `return` at the top of a handler)
  * `exitevent` returns from the handler
  * `return x` adds to the result without leaving the handler
Locals live for the whole handler, so each one is declared once, at its first assignment
when that is at the top level of the method, otherwise at the top of the method.

Values that are known while converting (literals, `game.serverside`) are folded, so
`if game.serverside` disappears and `desc The ticket reads: ...` becomes one string.
"""

from __future__ import annotations

import re

from . import mapping, names
from .expr import Call, Expr, Literal, Name, Not, Number, Vector, param_index, parse_token, source_text
from .infer import (BOOL, ENTITY, FLOAT, HANDLES, INT, MATH_COMMANDS, PLAYER, STRING, VECTOR, Evidence, handle_type,
                    literal_type)
from .ir import (ADD, AND, ATOM, COMPARE, EQUALITY, MUL, OR, UNARY, Append, Assign, Comment, For, If, Line, Method,
                 Return, Stmt, TExpr)
from .syntax import Cmd, CmdList, Event, Token
from .context import FileContext, Signature
from .values import (FALSE, NUMERIC_TYPES, TRUE, c_atof, c_atoi, convert, float_arg, format_number, join, lit,
                     missing_param, negate, number_code, string_literal, truthy)
from .calls import EventCalls
from .split import SplitLocals
from .updates import UpdateCommands, _cmd_source


# ----------------------------------------------------------------------------------------

class HandlerLowerer(UpdateCommands, SplitLocals, EventCalls):
    def __init__(self, ctx: FileContext, event: Event, signature: Signature | None, method_name: str):
        self.ctx = ctx
        self.event = event
        self.event_name = event.name or ""
        self.signature = signature
        self.method_name = method_name
        self.returns = signature.returns if signature else "void"
        self.params: dict[int, tuple[str, str]] = {}
        if signature:
            for i, (t, n) in enumerate(signature.params, start=1):
                self.params[i] = (n, t)
        self.locals: dict[str, tuple[str, str]] = {}      # legacy name -> (ident, type)
        self.declared: set[str] = set()
        self.top_declarations: list[Stmt] = []
        self.depth = 0
        self.menu_item = False          # reg.mitem.* written through a MenuItem
        self.inline_decls: set[int] = set()     # id(Cmd) of `local X v` lines that declare X in place
        self.aliases: dict[str, str] = {}       # local name -> parameter it only copies
        self.loop_counts: set[str] = set()      # locals declared by calleventloop conversions
        self._prepare_locals()
        self._analyze_locals()
        self._find_splits(self._local_evidence_by_name)

    # -- locals --------------------------------------------------------------------

    def _prepare_locals(self) -> None:
        evidence: dict[str, Evidence] = {}
        order: list[str] = []

        def visit(cmds: CmdList) -> None:
            for cmd in cmds.cmds:
                lname = cmd.name.lower()
                if lname == "local" and cmd.args and not cmd.args[0].text.lower().startswith("reg.") \
                        and not param_index(cmd.args[0].text):       # `local PARAM2 x` sets the parameter
                    target = cmd.args[0].text
                    if target not in evidence:
                        evidence[target] = Evidence()
                        order.append(target)
                    values = [parse_token(t.text, t.quoted) for t in cmd.args[1:]]
                    self._local_evidence(evidence[target], values)
                elif lname in MATH_COMMANDS and cmd.args and cmd.args[0].text in evidence:
                    evidence[cmd.args[0].text].math += 1
                    if len(cmd.args) > 1:
                        amount = parse_token(cmd.args[1].text, cmd.args[1].quoted)
                        if isinstance(amount, Number) and not amount.is_int or lname in ("divide",):
                            evidence[cmd.args[0].text].floats += 1
                elif lname in ("stradd", "strconc") and cmd.args and cmd.args[0].text in evidence:
                    evidence[cmd.args[0].text].strings += 1
                elif lname.startswith("vector") and cmd.args and cmd.args[0].text in evidence:
                    evidence[cmd.args[0].text].vectors += 1
                    evidence[cmd.args[0].text].vector_ops += 1
                if cmd.if_list:
                    visit(cmd.if_list)
                for e in cmd.else_lists:
                    visit(e)

        visit(self.event.commands)
        self._local_evidence_by_name = evidence
        taken = {n for n, _ in self.params.values()} | set(self.ctx.fields) | {"result", "self", "host", "menuItem"}
        for name in order:
            ident = names.local(name)
            if ident in taken or ident in names.AS_KEYWORDS:
                base, n = ident + "Value", 2      # minBags (the parameter) and minBagsValue (the local)
                ident = base
                while ident in taken:
                    ident, n = f"{base}{n}", n + 1
            taken.add(ident)
            ev = evidence[name]
            t = ev.resolve({})
            if ev.math and t == STRING and not ev.literal_strings:
                # arithmetic on a copy of a text variable: keep the local numeric
                t = FLOAT if ev.floats else (FLOAT if ev.math else INT)
            # whether it holds entities is decided with every handler of the event (entity_flow.py)
            handle = self.ctx.inference.entity_type(("local", self.event_name, name))
            if handle is not None:
                t = handle
            elif t in HANDLES:
                t = STRING
            self.locals[name] = (ident, t)

    WRITE_COMMANDS = {"local", "setvar", "setvard", "stradd", "strconc", "vectoradd", "vectormultiply", "vectorscale",
                      "vectorset", "token.add", "token.del", "token.set", "token.scramble"} | set(MATH_COMMANDS)

    def _analyze_locals(self) -> None:
        """Where each local can be declared: in place when its first use is a plain assignment in the
        innermost block that holds every use; and locals that only copy a parameter are the parameter."""
        occurrences: dict[str, list[tuple[Cmd, tuple[int, ...], bool]]] = {}
        writes: dict[str, list[Cmd]] = {}

        def visit(cmds: CmdList, path: tuple[int, ...]) -> None:
            here = path + (id(cmds),)
            for cmd in cmds.cmds:
                lname = cmd.name.lower()
                target = cmd.args[0].text if cmd.args and lname in self.WRITE_COMMANDS else None
                for i, token in enumerate(cmd.args):
                    expr = parse_token(token.text, token.quoted)
                    for sub_expr in _walk(expr):
                        if isinstance(sub_expr, Name) and sub_expr.text in self.locals:
                            is_write = i == 0 and sub_expr.text == target
                            occurrences.setdefault(sub_expr.text, []).append((cmd, here, is_write))
                if target in self.locals:
                    writes.setdefault(target, []).append(cmd)
                if cmd.if_list:
                    visit(cmd.if_list, here)
                for e in cmd.else_lists:
                    visit(e, here)

        visit(self.event.commands, ())
        root = (id(self.event.commands),)
        changed_params = {param_index(cmd.args[0].text) for cmd in _all_cmds(self.event.commands)
                          if cmd.args and cmd.name.lower() in self.WRITE_COMMANDS and param_index(cmd.args[0].text)}
        for name, occ in occurrences.items():
            first_cmd, first_path, first_is_write = occ[0]
            value_tokens = first_cmd.args[1:]
            reads_itself = any(isinstance(e, Name) and e.text == name
                               for tok in value_tokens for e in _walk(parse_token(tok.text, tok.quoted)))
            plain_assign = first_is_write and first_cmd.name.lower() == "local" and not reads_itself
            # alias: `local L_X PARAMn` once, at the top, never written again
            if plain_assign and first_path == root and len(writes.get(name, [])) == 1 and len(value_tokens) == 1:
                index = param_index(value_tokens[0].text)
                if index and index in self.params and self.params[index][1] == self.locals[name][1] \
                        and index not in changed_params:
                    self.aliases[name] = self.params[index][0]
                    continue
            common = _common_prefix([p for _, p, _ in occ])
            if plain_assign and first_path == common:
                self.inline_decls.add(id(first_cmd))

    def _local_evidence(self, ev: Evidence, values: list[Expr]) -> None:
        if len(values) != 1:
            ev.strings += 1
            ev.literal_strings += 1
            return
        v = values[0]
        if isinstance(v, Number):
            if v.text.endswith("%"):
                ev.strings += 1
                ev.literal_strings += 1
            elif v.text in ("0", "1"):
                ev.bools += 1
            elif v.is_int:
                ev.ints += 1
            else:
                ev.floats += 1
        elif isinstance(v, Name):
            index = param_index(v.text)
            if index and index in self.params:
                self._type_evidence(ev, self.params[index][1])
            elif v.text in self.ctx.fields:
                self._type_evidence(ev, self.ctx.fields[v.text])
            elif v.text in self.locals:
                self._type_evidence(ev, self.locals[v.text][1])
            elif v.text in mapping.BUILTINS:
                self._type_evidence(ev, mapping.BUILTINS[v.text][1])
            elif v.text.lower() == "game.script.iteration":
                ev.ints += 1
            else:
                ev.strings += 1
                if v.text not in self.ctx.dynamic_vars and not v.text.lower().startswith(("game.", "const.")):
                    ev.literal_strings += 1
        else:
            t = literal_type(v) or STRING
            self._type_evidence(ev, t)
            if isinstance(v, Literal):
                ev.literal_strings += 1

    @staticmethod
    def _type_evidence(ev: Evidence, t: str) -> None:
        if t == STRING:
            ev.strings += 1
        elif t == VECTOR:
            ev.vectors += 1
        elif t == FLOAT:
            ev.floats += 1
        elif t == INT:
            ev.ints += 1
        elif t == BOOL:
            ev.bools += 1
        elif t in HANDLES:
            ev.entities += 1
            ev.players += t == PLAYER

    def _declare_early(self, legacy: str) -> None:
        """A local read or assigned before a top-level assignment: declare it at the top of the
        method with the value the .script would see first (the script variable of that name, or
        the name itself)."""
        if legacy in self.declared:
            return
        if legacy in self.splits:
            self.declared.add(legacy)
            self._split_declare_early(legacy)
            return
        ident, t = self.locals[legacy]
        self.declared.add(legacy)
        if legacy in self.ctx.fields:
            init = convert(TExpr(names.variable(legacy), self.ctx.fields[legacy]), t)
        elif t in HANDLES:
            init = TExpr("null", t)       # its name is no entity
        else:
            init = convert(lit(legacy), t)
        self.top_declarations.append(Line(f"{t} {ident} = {init.code}", declares=True,
                                          assign=Assign(ident, t, init, f"{t} ")))

    # -- entry -----------------------------------------------------------------------

    def lower(self) -> Method:
        body = self.lower_list(self.event.commands, top=True)
        if self.returns == "string":
            body = [Line('string result = ""')] + body + [Return("result")]
            body = _collapse_result(body)
        body = [_without_dead_value(d, body) for d in self.top_declarations] + body
        if self.splits:
            body = self._split_cleanup(body)
        params = [(t, n) for _, (n, t) in sorted(self.params.items())]
        comments = [self.event.header_comment] if self.event.header_comment else []
        method = Method(self.method_name, params, self.returns, body, comments=comments)
        if self.params:
            method.defaults = {n: missing_param(t, i + 1) for i, (t, n) in enumerate(params)}
        return method

    def _exit(self) -> Return:
        return Return("result" if self.returns == "string" else None)

    # -- statement lists --------------------------------------------------------------

    def lower_list(self, cmds: CmdList, top: bool = False) -> list[Stmt]:
        out: list[Stmt] = []
        items = cmds.cmds
        blank = False       # an empty source line before the next statement written
        for i, cmd in enumerate(items):
            blank = blank or cmd.blank_before
            if cmd.conditional and not cmd.new_style:
                # Old-style if: when false the rest of this list is skipped
                cond = self.condition(cmd.args, cmd)
                if cmd.else_lists:
                    self.ctx.quirk(cmd.line, "`else` after an `if` without parentheses never runs")
                comments = list(cmd.leading_comments)
                if cond.code == "true":
                    if comments or cmd.comment:
                        out.append(Comment(f"(always true here) {_cmd_source(cmd)}"))
                    continue
                if cond.code == "false":
                    out.append(Comment(f"(never true here, the rest is skipped) {_cmd_source(cmd)}"))
                    if top:
                        out.append(self._exit())
                    return out
                if top:
                    out.append(If(negate(cond), [self._exit()], comments=comments, trailing=cmd.comment, blank=blank))
                    out.extend(self.lower_list(CmdList(items[i + 1:]), top=True))
                else:
                    self.depth += 1
                    rest = self.lower_list(CmdList(items[i + 1:]))
                    self.depth -= 1
                    out.append(If(cond, rest, comments=comments, trailing=cmd.comment, blank=blank))
                return out
            stmts = self.lower_command(cmd)
            if stmts:
                stmts[0].blank = blank
                blank = False
            out.extend(stmts)
        return out

    def _nested(self, cmds: CmdList | None) -> list[Stmt]:
        self.depth += 1
        try:
            return self.lower_list(cmds or CmdList())
        finally:
            self.depth -= 1

    def lower_if(self, cmd: Cmd) -> list[Stmt]:
        cond = self.condition(cmd.args, cmd)
        if cond.code == "true":
            return self._nested(cmd.if_list)
        then = self._nested(cmd.if_list)
        else_ = self._lower_else_lists(cmd.else_lists, cmd)
        if cond.code == "false":
            return else_ or []
        return [If(cond, then, else_)]

    def _lower_else_lists(self, lists: list[CmdList], owner: Cmd) -> list[Stmt] | None:
        if not lists:
            return None
        first, rest = lists[0], lists[1:]
        cmds = first.cmds
        # A list holding one failing new-style if returns false, so the next else list runs:
        # that is exactly an else-if chain.
        if len(cmds) == 1 and cmds[0].conditional and cmds[0].new_style:
            inner = cmds[0]
            cond = self.condition(inner.args, inner)
            then = self._nested(inner.if_list)
            nested = self._lower_else_lists(inner.else_lists + rest, inner) if (inner.else_lists or rest) else None
            if inner.else_lists and rest:
                self.ctx.quirk(inner.line, "nested else inside an else-if chain: the chain's next branch also runs")
            if cond.code == "true":
                return then
            if cond.code == "false":
                return nested
            return [If(cond, then, nested, comments=list(inner.leading_comments), trailing=inner.comment)]
        if rest:
            self.ctx.quirk(owner.line, "an `else` branch after a plain else never runs")
        body = self._nested(first)
        return body or None

    # -- conditions --------------------------------------------------------------------

    def condition(self, tokens: list[Token], cmd: Cmd) -> TExpr:
        args = [parse_token(t.text, t.quoted) for t in tokens]
        if len(args) == 1:
            a = args[0]
            operand = a.operand if isinstance(a, Not) else a
            value = self.value(operand)
            if isinstance(operand, Name) and value.literal == operand.text and re.fullmatch(r"[A-Z][A-Z0-9_]+", operand.text):
                self.ctx.quirk(cmd.line, f"{operand.text} is never set by any script that runs this code, "
                                         f"so `if {'!' if a is not operand else ''}{operand.text}` is always "
                                         f"{'true' if a is not operand else 'false'}")
            return negate(truthy(value)) if a is not operand else truthy(value)
        if len(args) == 2:
            self.ctx.quirk(cmd.line, f"condition with two operands ({' '.join(t.text for t in tokens)}) is always true")
            return TRUE
        if len(args) < 3:
            return TRUE
        left, op_expr, right = args[0], args[1], args[2]
        op = op_expr.text if isinstance(op_expr, (Name, Literal)) else source_text(op_expr)
        return self.comparison(left, op, right, cmd)

    def comparison(self, left: Expr, op: str, right: Expr, cmd: Cmd) -> TExpr:
        missing = self._missing_test(left, op, right)
        if missing is not None:
            return missing
        if op in ("==", "!=", "<", ">", "<=", ">="):
            lv, rv = self.value(left), self.value(right)
            lt = lv.numeric.type if lv.numeric is not None else lv.type
            rt = rv.numeric.type if rv.numeric is not None else rv.type
            t = INT if lt in (INT, BOOL) and rt in (INT, BOOL) else FLOAT
            lv, rv = convert(lv, t), convert(rv, t)
            if lv.literal is not None and rv.literal is not None:
                a, b = c_atof(lv.literal), c_atof(rv.literal)
                result = {"==": a == b, "!=": a != b, "<": a < b, ">": a > b, "<=": a <= b, ">=": a >= b}[op]
                return TRUE if result else FALSE
            prec = EQUALITY if op in ("==", "!=") else COMPARE
            return TExpr(f"{lv.wrapped(ADD)} {op} {rv.wrapped(ADD)}", BOOL, prec)
        if op in ("startswith", "!startswith", "contains", "!contains"):
            helper = "StartsWith" if "startswith" in op else "Contains"
            lv, rv = self.value(left, STRING), self.value(right, STRING)
            if lv.literal is not None and rv.literal is not None:
                hit = lv.literal.startswith(rv.literal) if helper == "StartsWith" else rv.literal in lv.literal
                e = TRUE if hit else FALSE
            else:
                e = TExpr(f"{helper}({lv.code}, {rv.code})", BOOL)
            return negate(e) if op.startswith("!") else e
        string_ops = {"equals": "==", "isnot": "!=", "!equals": "!="}
        if op not in string_ops:
            self.ctx.quirk(cmd.line, f"unknown comparison '{op}' is treated as `equals`")
        cop = string_ops.get(op, "==")
        lv, rv = self.value(left), self.value(right)
        if lv.type in HANDLES or rv.type in HANDLES:
            return _entity_compare(lv, rv, cop)
        # equals compares text; a typed number against a number literal compares as numbers
        if lv.type in NUMERIC_TYPES + (BOOL,) and isinstance(right, Number):
            t = INT if lv.type == BOOL else lv.type
            lv, rv = convert(lv, t), self.value(right, t)
        elif rv.type in NUMERIC_TYPES + (BOOL,) and isinstance(left, Number):
            t = INT if rv.type == BOOL else rv.type
            lv, rv = self.value(left, t), convert(rv, t)
        elif not (lv.type == rv.type and lv.type in NUMERIC_TYPES):
            lv, rv = self.value(left, STRING), self.value(right, STRING)
        if lv.literal is not None and rv.literal is not None and lv.type == rv.type == STRING:
            same = lv.literal == rv.literal
            return TRUE if (same if cop == "==" else not same) else FALSE
        return TExpr(f"{lv.wrapped(ADD)} {cop} {rv.wrapped(ADD)}", BOOL, EQUALITY)

    def _missing_test(self, left: Expr, op: str, right: Expr) -> TExpr | None:
        """`if ( X equals 'PARAM4' )` / `if ( X startswith PARAM )`: .script's test for a parameter the
        caller did not pass (it reads as its own name). Converted parameters default to "", so the
        test is whether the value is empty."""
        if op not in ("equals", "isnot", "!equals", "startswith", "!startswith", "contains", "!contains"):
            return None
        for value, marker in ((left, right), (right, left)):
            text = marker.text if isinstance(marker, (Literal, Name)) else None
            if text is None or not re.fullmatch(r"PARAM\d*", text):
                continue
            if isinstance(marker, Name) and param_index(text) in self.params:
                continue        # an unquoted PARAMn is the parameter itself
            if op in ("startswith", "!startswith", "contains", "!contains") and value is right:
                continue        # `PARAM startswith X` tests something else
            v = self.value(value)
            if v.type in HANDLES:
                # the engine always passes its entities: an omitted one is none
                test = "!is" if op in ("isnot", "!equals", "!startswith", "!contains") else "is"
                return TExpr(f"{v.code} {test} null", BOOL, EQUALITY)
            if v.type != STRING:
                return None
            empty = TExpr(f"{v.wrapped(ATOM)}.isEmpty()", BOOL)
            if v.literal is not None:
                empty = TRUE if v.literal == "" else FALSE
            return negate(empty) if op in ("isnot", "!equals", "!startswith", "!contains") else empty
        return None

    # -- values ----------------------------------------------------------------------------

    def value(self, expr: Expr, want: str | None = None) -> TExpr:
        e = self._value(expr, want)
        return convert(e, want) if want else e

    def text(self, expr: Expr) -> TExpr:
        return self.value(expr, STRING)

    def arg(self, expr: Expr) -> TExpr:
        """A value for a parameter that takes any type (`const ?&in`): the engine writes it as .script
        text, so it keeps its own type. A number literal the engine would write differently (50%,
        +5, 007) stays text; an entity is passed as a handle (`@target`, which may be null)."""
        if isinstance(expr, Number) and not _plain_number(expr):
            return lit(expr.text)
        e = self.value(expr)
        if e.type in HANDLES and e.code != "self":
            return TExpr(f"@{e.wrapped(UNARY)}", e.type, UNARY)
        return e

    def entity(self, expr: Expr) -> TExpr:
        """A value for an entity parameter (a handle, or text: an id or a name such as ent_lastseen)."""
        e = self.value(expr)
        return e if e.type in HANDLES else convert(e, STRING)

    def args(self, exprs: list[Expr]) -> str:
        """`, a, b, c` for the variadic part of a call (empty when there is none)."""
        return "".join(f", {self.arg(a).code}" for a in exprs)

    def _value(self, expr: Expr, want: str | None) -> TExpr:
        if isinstance(expr, Literal):
            # 'PARAM' / 'PARAM4' as a value: the "not supplied" marker, which is empty here
            return lit("") if _MISSING_MARKER.fullmatch(expr.text) else lit(expr.text)
        if isinstance(expr, Number):
            if want in (STRING, "entity"):
                return lit(expr.text)
            if want == BOOL:
                return TRUE if c_atoi(expr.text) != 0 else FALSE
            if expr.text.endswith("%"):
                if want in NUMERIC_TYPES:
                    return format_number(c_atof(expr.text), want)
                return lit(expr.text)
            t = want if want in NUMERIC_TYPES else (INT if expr.is_int else FLOAT)
            code = number_code(expr.text, t)
            return TExpr(code, t, UNARY if code.startswith("-") else ATOM, literal=expr.text)
        if isinstance(expr, Not):
            return negate(truthy(self.value(expr.operand)))
        if isinstance(expr, Vector):
            parts = [float_arg(self.value(p, FLOAT)) for p in expr.parts] + ["0"] * (3 - len(expr.parts))
            return TExpr(f"Vector3({', '.join(parts[:3])})", VECTOR)
        if isinstance(expr, Call):
            return self.call(expr)
        if isinstance(expr, Name):
            return self.name(expr.text)
        return lit(source_text(expr))

    def name(self, text: str) -> TExpr:
        if text in self.aliases:
            ident = self.aliases[text]
            return TExpr(ident, self.locals[text][1])
        if text in self.locals:
            ident, t = self.locals[text]
            if text not in self.declared:
                self._declare_early(text)
            if text in self.splits:
                return self._split_read(text)
            return TExpr(ident, t)
        index = param_index(text)
        if index:
            if index in self.params:
                n, t = self.params[index]
                return TExpr(n, t)
            return lit("")
        lower = text.lower()
        if lower == "game.script.iteration":
            self.ctx.uses_loop_iteration = True
            return TExpr("loopIteration", INT)
        if text in mapping.BUILTINS:
            code, t = mapping.BUILTINS[text]
            return TExpr(code, t, literal=("1" if code == "true" else "0") if code in ("true", "false") else None)
        if lower.startswith(("game.", "const.")):
            return TExpr(f"Eval({string_literal(text)})", STRING)
        if lower in mapping.ENTITY_NAMES:
            return TExpr(lower.upper(), STRING)
        if text in self.ctx.fields:
            return TExpr(names.variable(text), self.ctx.fields[text])
        if text in self.ctx.dynamic_vars or text in self.ctx.inference.globals:
            return TExpr(f"GetVar({string_literal(text)})", STRING)
        return lit("") if text == "PARAM" else lit(text)

    def call(self, call: Call) -> TExpr:
        name = call.name.lower()
        args = call.args
        if name == "$currentscript":
            return lit(self.ctx.file)
        if name == "$int" and len(args) == 1:
            whole = self.value(args[0])
            if whole.type == INT or (whole.numeric is not None and whole.numeric.type == INT):
                return convert(whole, INT)          # already a whole number
        if name in ("$get", "$get_by_idx") and len(args) >= 2 and isinstance(args[1], (Name, Literal)):
            return self._get_property(args)
        if name == "$func" and args:
            return self._func_call(args)
        if name in ("$and", "$or"):
            op = " && " if name == "$and" else " || "
            parts = [truthy(self.value(a)).wrapped(AND if name == "$and" else OR) for a in args]
            return TExpr(op.join(parts), BOOL, AND if name == "$and" else OR)
        if name == "$math" and len(args) >= 3 and isinstance(args[0], Name):
            op = args[0].text.lower()
            a, b = self.value(args[1], FLOAT), self.value(args[2], FLOAT)
            if op.startswith("add"):
                return TExpr(f"{a.wrapped(ADD)} + {b.wrapped(MUL)}", FLOAT, ADD)
            if op.startswith("sub"):
                return TExpr(f"{a.wrapped(ADD)} - {b.wrapped(MUL)}", FLOAT, ADD)
            if op.startswith("mul"):
                return TExpr(f"{a.wrapped(MUL)} * {b.wrapped(UNARY)}", FLOAT, MUL)
            if op.startswith("div"):
                return TExpr(f"Divide({a.code}, {b.code})", FLOAT)
        spec = mapping.FUNCTIONS.get(f"{name}/{len(args)}") or mapping.FUNCTIONS.get(name)
        if spec and spec.params == ["Vector3"] and len(args) == 3:
            # $relpos(0,10,0): three numbers written as one vector
            x, y, z = (float_arg(self.value(a, FLOAT)) for a in args)
            converted = [TExpr(f"Vector3({x}, {y}, {z})", VECTOR)]
        elif spec and len(args) == len(spec.params):      # never drop an argument
            converted = [self.entity(a) if p == "entity" else self.value(a, p) for a, p in zip(args, spec.params)]
        else:
            converted = None
        if converted is not None and (spec.template or spec.method):
            returns = handle_type(spec.returns) or spec.returns
            if spec.template:
                code = spec.template
                call = re.match(r"\w+\(", code) is not None      # Vector3(...), Random(...)
                for i, c in enumerate(converted):
                    if call and spec.params[i] == FLOAT:
                        arg = float_arg(c)
                    else:
                        arg = c.wrapped(MUL if "." in spec.template else ADD)
                    code = code.replace("{" + str(i) + "}", arg)
                prec = ADD if " + " in code else (UNARY if code.startswith("-") else ATOM)
                return TExpr(code, returns, prec)
            codes = [float_arg(c) if p == FLOAT else c.code for c, p in zip(converted, spec.params)]
            return TExpr(f"{spec.method}({', '.join(codes)})", returns)
        # any other $function: the engine's own handler, with evaluated arguments
        return TExpr(f"LegacyFunction({string_literal(name[1:])}{self.args(args)})", STRING)

    def _get_property(self, args: list[Expr]) -> TExpr:
        entity = self.entity(args[0])
        prop = args[1].text
        if isinstance(args[1], Name) and (param_index(prop) or prop in self.locals or prop in self.ctx.fields
                                          or prop in self.ctx.dynamic_vars):
            return TExpr(f"GetProp({entity.code}, {self.text(args[1]).code}{self.args(args[2:])})", STRING)
        lower = prop.lower()
        if lower == "id" and len(args) == 2:
            if isinstance(args[0], Name) and args[0].text.lower() == "ent_me":
                return TExpr("self", ENTITY)
            if entity.type in HANDLES:
                return entity
        base, _, component = lower.partition(".")
        if len(args) == 2 and component in mapping.COMPONENTS and base in mapping.GET_VECTOR_COMPONENTS:
            return TExpr(f"{mapping.GET_VECTOR_COMPONENTS[base]}({entity.code}).{mapping.COMPONENTS[component]}", FLOAT)
        if len(args) == 2:
            for prefix, (method, t) in mapping.GET_PREFIXED.items():
                if lower.startswith(prefix) and len(lower) > len(prefix):
                    return TExpr(f"{method}({entity.code}, {string_literal(prop[len(prefix):])})", t)
        if len(args) == 2 and lower in mapping.GET_PROPERTIES:
            method, t = mapping.GET_PROPERTIES[lower]
            return TExpr(f"{method}({entity.code})", handle_type(t) or t)
        if len(args) == 3 and lower in mapping.GET_PROPERTIES_ARG:
            method, t = mapping.GET_PROPERTIES_ARG[lower]
            return TExpr(f"{method}({entity.code}, {self.arg(args[2]).code})", handle_type(t) or t)
        tail = self.args(args[2:])
        if lower.endswith((".x", ".y", ".z")) or lower.startswith(("origin.", "angles.", "velocity.")):
            return TExpr(f"Float(GetProp({entity.code}, {string_literal(prop)}{tail}))", FLOAT)
        return TExpr(f"GetProp({entity.code}, {string_literal(prop)}{tail})", STRING)

    # -- commands ------------------------------------------------------------------------

    def lower_command(self, cmd: Cmd) -> list[Stmt]:
        stmts = self._command(cmd)
        extra = list(cmd.leading_comments)
        if stmts:
            stmts[0].comments = extra + stmts[0].comments
            if cmd.comment and not stmts[0].trailing and not isinstance(stmts[0], If):
                stmts[0].trailing = cmd.comment
            elif cmd.comment and isinstance(stmts[0], If) and not stmts[0].trailing:
                stmts[0].trailing = cmd.comment
        elif extra or cmd.comment:
            stmts = [Comment(c) for c in extra + ([cmd.comment] if cmd.comment else [])]
        return stmts

    def _command(self, cmd: Cmd) -> list[Stmt]:
        name = cmd.name.lower()
        if cmd.args and cmd.args[0].text in self.splits and name in self.WRITE_COMMANDS \
                and name not in ("local", "setvar", "setvard"):
            return self._split_command(cmd, name, lambda: self._command_body(cmd))
        return self._command_body(cmd)

    def _command_body(self, cmd: Cmd) -> list[Stmt]:
        name = cmd.name.lower()
        tokens = cmd.args
        args = [parse_token(t.text, t.quoted) for t in tokens]

        if cmd.conditional and cmd.new_style:
            return self.lower_if(cmd)
        if name in ("setvar", "setvard"):
            return self._assign_field(cmd, tokens, args)
        if name == "setvarg":
            if not tokens:
                return []
            return [Line(f"SetGlobal({string_literal(tokens[0].text)}, {self._any(args[1:], self._concat(args[1:])).code})")]
        if name == "local":
            return self._assign_local(cmd, tokens, args)
        if name in MATH_COMMANDS:
            return self._math(cmd, name, tokens, args)
        if name == "stradd":
            return self._stradd(cmd, tokens, args)
        if name == "strconc":
            return self._strconc(tokens, args)
        if name in ("vectoradd", "vectormultiply", "vectorscale", "vectorset"):
            return self._vector(cmd, name, tokens, args)
        if name in ("callevent", "calleventtimed"):
            return self._callevent(cmd, name, tokens, args)
        if name == "calleventloop":
            return self._calleventloop(cmd, tokens, args)
        if name == "callexternal":
            return self._callexternal(cmd, tokens, args)
        if name == "exitevent":
            return [self._exit()]
        if name == "return":
            return self._return(cmd, tokens, args)
        if name == "repeatdelay":
            if not args:
                return []
            return [Line(f"CallEventDelayed({self.value(args[0], FLOAT).code}, {string_literal(self.event_name)})")]
        if name == "breakloop":
            return [Line("breakLoop = true")]       # the calleventloop running this stops after it
        if name == "resetloop":
            return [Line(f'LegacyCommand("{name}"{self.args(args)})')]
        if name.startswith("token.") and tokens:
            return self._token(cmd, name, tokens, args)
        return self._mapped_command(cmd, name, tokens, args)

    # mapped commands -----------------------------------------------------------------------

    def _mapped_command(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if name == "menuitem.register" and self.menu_item and not args:
            return [Line("RegisterMenuItem(menuItem)")]
        if name in mapping.OUTPUT_COMMANDS and len(tokens) == 1:
            method, t = mapping.OUTPUT_COMMANDS[name]
            target = self._lvalue(tokens[0].text)
            if target is not None:
                return [Line(f"{target.code} = {convert(TExpr(f'{method}()', t), target.type).code}")]
            return [Line(f"SetVar({string_literal(tokens[0].text)}, {method}())")]
        spec = (mapping.ITEM_COMMANDS.get(name) if self.ctx.kind == "item" else None) or mapping.COMMANDS.get(name)
        if spec is not None:
            call = self._wrapper_call(spec, args)
            if call is not None:
                return [Line(call)]
        return [Line(f"LegacyCommand({string_literal(cmd.name)}{self.args(args)})")]

    def _wrapper_call(self, spec: mapping.CommandSpec, args: list[Expr]) -> str | None:
        """The command's function: fixed parameters converted to their types (entities take any
        value), then either the remaining tokens joined into one text (commands that join them
        themselves) or each remaining token as its own argument."""
        params = spec.params
        rest_type = params[-1].type if params and params[-1].type in ("text", "...") else None
        fixed = params[:-1] if rest_type else params
        required = len([p for p in fixed if not p.optional])
        if len(args) < required or (not rest_type and len(args) > len(fixed)):
            return None
        out = [self.entity(a).code if p.type == "entity" else
               float_arg(self.value(a, p.type)) if p.type == FLOAT else self.value(a, p.type).code
               for p, a in zip(fixed, args)]
        rest = args[len(fixed):]
        if rest_type == "text" and rest:
            out.append(join([self.value(a) for a in rest], " ").code)
        elif rest_type == "...":
            out.extend(self.arg(a).code for a in rest)
        return f"{spec.method}({', '.join(out)})"


def _without_dead_value(decl: Line, body: list[Stmt]) -> Line:
    """`string mode = "MODE";` declared at the top when every path assigns `mode` before reading it:
    the starting value is never seen, so the declaration does not give one."""
    if decl.assign is None:
        return decl
    ident = decl.assign.target
    word = re.compile(rf"\b{re.escape(ident)}\b")
    for stmt in body:
        if _mentions(stmt, word):
            if _assigns_first(stmt, ident, word):
                return Line(f"{decl.assign.type} {ident}", declares=True, comments=decl.comments)
            return decl
    return decl


def _mentions(stmt: Stmt, word) -> bool:
    if isinstance(stmt, Line):
        return bool(word.search(stmt.code))
    if isinstance(stmt, Append):
        return stmt.target == word.pattern or bool(word.search(stmt.target + " " + stmt.value.code))
    if isinstance(stmt, Return):
        return bool(stmt.value and word.search(stmt.value))
    if isinstance(stmt, If):
        return bool(word.search(stmt.cond.code)) or any(_mentions(s, word) for s in stmt.then + (stmt.else_ or []))
    if isinstance(stmt, For):
        return bool(word.search(stmt.header)) or any(_mentions(s, word) for s in stmt.body)
    return False


def _assigns_first(stmt: Stmt, ident: str, word) -> bool:
    """`stmt` sets `ident` on every path before anything reads it."""
    if isinstance(stmt, Line):
        lhs, sep, rhs = stmt.code.partition(" = ")
        return bool(sep) and lhs == ident and not word.search(rhs)
    if isinstance(stmt, If):
        if word.search(stmt.cond.code) or not stmt.else_:
            return False
        return all(_branch_assigns_first(b, ident, word) for b in (stmt.then, stmt.else_))
    return False


def _branch_assigns_first(stmts: list[Stmt], ident: str, word) -> bool:
    for stmt in stmts:
        if _mentions(stmt, word):
            return _assigns_first(stmt, ident, word)
        if isinstance(stmt, Return):
            return True         # leaves before reading it
    return False


_MISSING_MARKER = re.compile(r"PARAM\d*")


def _entity_compare(lv: TExpr, rv: TExpr, cop: str) -> TExpr:
    """equals with an entity: two entities are the same one when their ids are equal (`is`); "0" and
    "" are what the engine gives for no entity; anything else compares as text, the entity as its id."""
    if lv.type in HANDLES and rv.type in HANDLES:
        return TExpr(f"{lv.code} {'is' if cop == '==' else '!is'} {rv.code}", BOOL, EQUALITY)
    entity, other = (lv, rv) if lv.type in HANDLES else (rv, lv)
    if other.literal is not None and other.literal.lower() in ("0", "", "none"):    # the engine's "no entity"
        return TExpr(f"{entity.code} {'is' if cop == '==' else '!is'} null", BOOL, EQUALITY)
    left, right = convert(lv, STRING), convert(rv, STRING)
    return TExpr(f"{left.wrapped(ADD)} {cop} {right.wrapped(ADD)}", BOOL, EQUALITY)


def _plain_number(number: Number) -> bool:
    """A literal the engine writes back the same way when it is passed as a number."""
    text = number.text
    if text.endswith("%") or text.startswith("+") or "e" in text.lower():
        return False
    digits = text.lstrip("-")
    if number.is_int:
        return digits == "0" or not digits.startswith("0")
    return True


def _all_cmds(cmds: CmdList):
    for cmd in cmds.cmds:
        yield cmd
        if cmd.if_list:
            yield from _all_cmds(cmd.if_list)
        for e in cmd.else_lists:
            yield from _all_cmds(e)


def _walk(expr: Expr):
    yield expr
    if isinstance(expr, Call):
        for a in expr.args:
            yield from _walk(a)
    elif isinstance(expr, Vector):
        for p in expr.parts:
            yield from _walk(p)
    elif isinstance(expr, Not):
        yield from _walk(expr.operand)


def _common_prefix(paths: list[tuple[int, ...]]) -> tuple[int, ...]:
    prefix = paths[0]
    for p in paths[1:]:
        n = 0
        while n < len(prefix) and n < len(p) and prefix[n] == p[n]:
            n += 1
        prefix = prefix[:n]
    return prefix


def _collapse_result(body: list[Stmt]) -> list[Stmt]:
    """`string result = ""; ... result = AppendResult(result, X); return result;` -> `return X;`
    when that is the only use of result and it is the last statement."""
    assigns = [s for s in body if isinstance(s, Line) and s.code.startswith("result = ")]
    if len(body) >= 3 and len(assigns) == 1 and body[-2] is assigns[0] and \
            not any(isinstance(s, (If, For)) for s in body[1:-2]) and \
            not any(isinstance(s, Return) for s in body[1:-1]):
        line = assigns[0]
        m = re.fullmatch(r"result = AppendResult\(result, (.*)\)", line.code)
        if m:
            body = body[1:-2] + [Return(m.group(1), comments=line.comments, trailing=line.trailing)]
    return body
