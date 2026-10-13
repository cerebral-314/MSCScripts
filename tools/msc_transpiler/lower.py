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
from dataclasses import dataclass, field

from . import mapping, names
from .expr import Call, Expr, Literal, Name, Not, Number, Vector, param_index, parse_token, source_text
from .infer import BOOL, FLOAT, INT, MATH_COMMANDS, STRING, VECTOR, Evidence, Inference, literal_type
from .ir import ADD, AND, ATOM, COMPARE, EQUALITY, MUL, OR, UNARY, Comment, For, If, Line, Method, Return, Stmt, TExpr
from .syntax import Cmd, CmdList, Event, Token

NUMERIC_TYPES = (INT, FLOAT)
TRUE = TExpr("true", BOOL, literal="1")
FALSE = TExpr("false", BOOL, literal="0")


# ----------------------------------------------------------------------------------------
# Context shared by every handler of one file
# ----------------------------------------------------------------------------------------

@dataclass
class Signature:
    event: str
    method: str
    params: list[tuple[str, str]]       # (type, name), PARAM1 first
    returns: str = "void"               # "string" when handlers use `return`


@dataclass
class Quirk:
    file: str
    line: int
    message: str


@dataclass
class FileContext:
    file: str                            # "items/base_miscitem"
    class_name: str
    inference: Inference
    fields: dict[str, str]               # names readable as fields here -> type
    dynamic_vars: set[str]               # variables that may exist at run time but are not fields here
    signatures: "SignatureTable"
    quirks: list[Quirk] = field(default_factory=list)
    uses_loop_iteration: bool = False

    def quirk(self, line: int, message: str) -> None:
        self.quirks.append(Quirk(self.file, line, message))


class SignatureTable:
    """One signature per event name across the corpus (mixins of different scripts must agree)."""

    def __init__(self, inference: Inference):
        self.inference = inference
        self._cache: dict[str, Signature] = {}

    def get(self, event: str) -> Signature:
        if event in self._cache:
            return self._cache[event]
        spec = mapping.ENGINE_EVENTS.get(event)
        count = max(self.inference.max_param.get(event, 0), len(spec.params) if spec else 0)
        params: list[tuple[str, str]] = []
        used: set[str] = set()
        for index in range(1, count + 1):
            type_ = STRING
            pname = f"param{index}"
            named_by_engine = False
            if spec and index <= len(spec.params):
                p = spec.params[index - 1]
                type_ = STRING if p.type == "entity" else p.type
                pname = p.name
                named_by_engine = True
            else:
                type_ = self.inference.params.get((event, index), Evidence()).resolve({})
                if type_ == BOOL:
                    type_ = INT
            counts = self.inference.param_names.get((event, index))
            if counts and not named_by_engine:
                best = max(counts.items(), key=lambda kv: kv[1])[0]
                pname = names.local(best)
            while pname in used or pname in names.AS_KEYWORDS:
                pname += "_"
            used.add(pname)
            params.append((type_, pname))
        returns = "string" if event in self.inference.returns else "void"
        sig = Signature(event, names.event_method(event), params, returns)
        self._cache[event] = sig
        return sig


# ----------------------------------------------------------------------------------------
# Values
# ----------------------------------------------------------------------------------------

def string_literal(text: str) -> str:
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def lit(text: str) -> TExpr:
    return TExpr(string_literal(text), STRING, ATOM, literal=text)


def c_atof(text: str) -> float:
    m = re.match(r"\s*[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?", text)
    return float(m.group(0)) if m else 0.0


def c_atoi(text: str) -> int:
    m = re.match(r"\s*[+-]?\d+", text)
    return int(m.group(0)) if m else 0


def number_code(text: str, type_: str) -> str:
    value = text.rstrip("%")
    if value.startswith("."):
        value = "0" + value
    if value.startswith("-."):
        value = "-0" + value[1:]
    if value.startswith("+"):
        value = value[1:]
    if type_ == FLOAT:
        if "." not in value:
            return value + ".0f"
        return (value + "0" if value.endswith(".") else value) + "f"
    if type_ == INT and "." in value:
        return str(int(float(value)))
    return value


def _format_number(value: float, type_: str) -> TExpr:
    if type_ == INT:
        code = str(int(value))
    else:
        code = repr(float(value))
        code = (code if "e" not in code else f"{value:.6f}") + "f"
    return TExpr(code, type_, UNARY if code.startswith("-") else ATOM, literal=code.rstrip("f"))


def convert(e: TExpr, want: str | None) -> TExpr:
    """Convert between AngelScript types the way .script would read the value."""
    if want == "entity":
        want = STRING
    if want is None or want == e.type:
        return e
    t = e.type
    if e.literal is not None:
        folded = _fold_literal(e, want)
        if folded is not None:
            return folded
    if want == STRING:
        return TExpr(f"Text({e.code})", STRING)
    if want == INT:
        if t == FLOAT:
            return TExpr(f"int({e.code})", INT)
        if t == BOOL:
            return TExpr(f"({e.code} ? 1 : 0)", INT)
        return TExpr(f"Int({e.code})", INT)
    if want == FLOAT:
        if t == INT:
            return TExpr(e.code, FLOAT, e.prec, e.literal)
        if t == BOOL:
            return TExpr(f"({e.code} ? 1.0f : 0.0f)", FLOAT)
        return TExpr(f"Float({e.code})", FLOAT)
    if want == BOOL:
        return truthy(e)
    if want == VECTOR:
        return TExpr(f"Vec({e.code if t == STRING else 'Text(' + e.code + ')'})", VECTOR)
    return e


def _fold_literal(e: TExpr, want: str) -> TExpr | None:
    text = e.literal
    if e.type == BOOL:
        text = "1" if text == "1" else "0"
    if want == STRING:
        return lit(text)
    if want == INT:
        return _format_number(c_atoi(text), INT)
    if want == FLOAT:
        return _format_number(c_atof(text), FLOAT)
    if want == BOOL:
        return TRUE if c_atoi(text) != 0 else FALSE
    return None


def truthy(e: TExpr) -> TExpr:
    """`if X` is atoi(X) != 0."""
    if e.literal is not None:
        return TRUE if c_atoi(e.literal) != 0 else FALSE
    if e.type == BOOL:
        return e
    if e.type == INT:
        return TExpr(f"{e.wrapped(COMPARE)} != 0", BOOL, EQUALITY)
    if e.type == FLOAT:
        return TExpr(f"int({e.code}) != 0", BOOL, EQUALITY)
    if e.type == VECTOR:
        return FALSE
    return TExpr(f"Truthy({e.code})", BOOL)


def negate(e: TExpr) -> TExpr:
    if e.code == "true":
        return FALSE
    if e.code == "false":
        return TRUE
    m = re.fullmatch(r"(.+) (==|!=) (.+)", e.code)
    if e.prec == EQUALITY and m and "&&" not in e.code and "||" not in e.code and " == " not in m.group(1):
        op = "!=" if m.group(2) == "==" else "=="
        return TExpr(f"{m.group(1)} {op} {m.group(3)}", BOOL, EQUALITY)
    if e.code.startswith("!") and e.prec == UNARY:
        inner = e.code[1:]
        return TExpr(inner, BOOL, ATOM if inner.endswith(")") or re.fullmatch(r"\w+", inner) else UNARY)
    return TExpr(f"!{e.wrapped(UNARY)}", BOOL, UNARY)


def join(parts: list[TExpr], separator: str = "") -> TExpr:
    """String concatenation; literals known now are merged, separators included."""
    merged: list[TExpr] = []
    for i, part in enumerate(parts):
        if i and separator:
            if merged and merged[-1].literal is not None and merged[-1].type == STRING:
                merged[-1] = lit(merged[-1].literal + separator)
            else:
                merged.append(lit(separator))
        if part.literal is not None and part.type != BOOL:
            part = lit(part.literal)
        if part.literal is not None and part.type == STRING and merged and merged[-1].literal is not None \
                and merged[-1].type == STRING:
            merged[-1] = lit(merged[-1].literal + part.literal)
        else:
            merged.append(part)
    if not merged:
        return lit("")
    if len(merged) == 1:
        return convert(merged[0], STRING)
    # AngelScript adds left to right: numbers may stay numbers once the chain starts with text
    out: list[str] = []
    for i, part in enumerate(merged):
        if part.type == STRING:
            out.append(part.wrapped(ADD))
        elif part.type in NUMERIC_TYPES and i > 0 and merged[0].type == STRING:
            out.append(part.wrapped(MUL))
        else:
            out.append(convert(part, STRING).wrapped(ADD))
    return TExpr(" + ".join(out), STRING, ADD)


# ----------------------------------------------------------------------------------------
# Handler lowering
# ----------------------------------------------------------------------------------------

class HandlerLowerer:
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
        self._prepare_locals()

    # -- locals --------------------------------------------------------------------

    def _prepare_locals(self) -> None:
        evidence: dict[str, Evidence] = {}
        order: list[str] = []

        def visit(cmds: CmdList) -> None:
            for cmd in cmds.cmds:
                lname = cmd.name.lower()
                if lname == "local" and cmd.args and not cmd.args[0].text.lower().startswith("reg."):
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
                if cmd.if_list:
                    visit(cmd.if_list)
                for e in cmd.else_lists:
                    visit(e)

        visit(self.event.commands)
        taken = {n for n, _ in self.params.values()} | set(self.ctx.fields) | {"result", "self", "host"}
        for name in order:
            ident = names.local(name)
            while ident in taken or ident in names.AS_KEYWORDS:
                ident += "_"
            taken.add(ident)
            ev = evidence[name]
            t = ev.resolve({})
            if ev.math and t == STRING and not ev.literal_strings:
                # arithmetic on a copy of a text variable: keep the local numeric
                t = FLOAT if ev.floats else (FLOAT if ev.math else INT)
            self.locals[name] = (ident, t)

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

    def _declare_early(self, legacy: str) -> None:
        """A local read or assigned before a top-level assignment: declare it at the top of the
        method with the value the .script would see first (the script variable of that name, or
        the name itself)."""
        if legacy in self.declared:
            return
        ident, t = self.locals[legacy]
        self.declared.add(legacy)
        if legacy in self.ctx.fields:
            init = convert(TExpr(names.variable(legacy), self.ctx.fields[legacy]), t)
        else:
            init = convert(lit(legacy), t)
        self.top_declarations.append(Line(f"{t} {ident} = {init.code}"))

    # -- entry -----------------------------------------------------------------------

    def lower(self) -> Method:
        body = self.lower_list(self.event.commands, top=True)
        if self.returns == "string":
            body = [Line('string result = ""')] + body + [Return("result")]
            body = _collapse_result(body)
        body = self.top_declarations + body
        params = [(t, n) for _, (n, t) in sorted(self.params.items())]
        comments = [self.event.header_comment] if self.event.header_comment else []
        method = Method(self.method_name, params, self.returns, body, comments=comments)
        if self.params:
            method.defaults = {n: _default_value(t) for (t, n) in params}
        return method

    def _exit(self) -> Return:
        return Return("result" if self.returns == "string" else None)

    # -- statement lists --------------------------------------------------------------

    def lower_list(self, cmds: CmdList, top: bool = False) -> list[Stmt]:
        out: list[Stmt] = []
        items = cmds.cmds
        for i, cmd in enumerate(items):
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
                    out.append(If(negate(cond), [self._exit()], comments=comments, trailing=cmd.comment))
                    out.extend(self.lower_list(CmdList(items[i + 1:]), top=True))
                else:
                    self.depth += 1
                    rest = self.lower_list(CmdList(items[i + 1:]))
                    self.depth -= 1
                    out.append(If(cond, rest, comments=comments, trailing=cmd.comment))
                return out
            out.extend(self.lower_command(cmd))
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
            if isinstance(a, Not):
                return negate(truthy(self.value(a.operand)))
            return truthy(self.value(a))
        if len(args) == 2:
            self.ctx.quirk(cmd.line, f"condition with two operands ({' '.join(t.text for t in tokens)}) is always true")
            return TRUE
        if len(args) < 3:
            return TRUE
        left, op_expr, right = args[0], args[1], args[2]
        op = op_expr.text if isinstance(op_expr, (Name, Literal)) else source_text(op_expr)
        return self.comparison(left, op, right, cmd)

    def comparison(self, left: Expr, op: str, right: Expr, cmd: Cmd) -> TExpr:
        if op in ("==", "!=", "<", ">", "<=", ">="):
            lv, rv = self.value(left), self.value(right)
            t = INT if lv.type in (INT, BOOL) and rv.type in (INT, BOOL) else FLOAT
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

    # -- values ----------------------------------------------------------------------------

    def value(self, expr: Expr, want: str | None = None) -> TExpr:
        e = self._value(expr, want)
        return convert(e, want) if want else e

    def text(self, expr: Expr) -> TExpr:
        return self.value(expr, STRING)

    def _value(self, expr: Expr, want: str | None) -> TExpr:
        if isinstance(expr, Literal):
            return lit(expr.text)
        if isinstance(expr, Number):
            if want in (STRING, "entity"):
                return lit(expr.text)
            if want == BOOL:
                return TRUE if c_atoi(expr.text) != 0 else FALSE
            if expr.text.endswith("%"):
                if want in NUMERIC_TYPES:
                    return _format_number(c_atof(expr.text), want)
                return lit(expr.text)
            t = want if want in NUMERIC_TYPES else (INT if expr.is_int else FLOAT)
            code = number_code(expr.text, t)
            return TExpr(code, t, UNARY if code.startswith("-") else ATOM, literal=expr.text)
        if isinstance(expr, Not):
            return negate(truthy(self.value(expr.operand)))
        if isinstance(expr, Vector):
            parts = [self.value(p, FLOAT).code for p in expr.parts] + ["0.0f"] * (3 - len(expr.parts))
            return TExpr(f"Vector3({', '.join(parts[:3])})", VECTOR)
        if isinstance(expr, Call):
            return self.call(expr)
        if isinstance(expr, Name):
            return self.name(expr.text)
        return lit(source_text(expr))

    def name(self, text: str) -> TExpr:
        if text in self.locals:
            ident, t = self.locals[text]
            if text not in self.declared:
                self._declare_early(text)
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
        return lit(text)

    def call(self, call: Call) -> TExpr:
        name = call.name.lower()
        args = call.args
        if name == "$currentscript":
            return lit(self.ctx.file)
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
        spec = mapping.FUNCTIONS.get(name)
        if spec and len(args) >= len(spec.params) and (spec.template or spec.method):
            converted = [self.value(a, p) for a, p in zip(args, spec.params)]
            returns = STRING if spec.returns == "entity" else spec.returns
            if spec.template:
                code = spec.template
                for i, c in enumerate(converted):
                    code = code.replace("{" + str(i) + "}", c.wrapped(MUL if "." in spec.template else ADD))
                prec = ADD if " + " in code else (UNARY if code.startswith("-") else ATOM)
                return TExpr(code, returns, prec)
            return TExpr(f"{spec.method}({', '.join(c.code for c in converted)})", returns)
        # any other $function: the engine's own handler, with evaluated arguments
        parts = [self.text(a).code for a in args]
        arglist = f", {{ {', '.join(parts)} }}" if parts else ""
        return TExpr(f"LegacyFunction({string_literal(name[1:])}{arglist})", STRING)

    def _get_property(self, args: list[Expr]) -> TExpr:
        entity = self.text(args[0])
        prop = args[1].text
        lower = prop.lower()
        if len(args) == 2 and lower in mapping.GET_PROPERTIES:
            method, t = mapping.GET_PROPERTIES[lower]
            return TExpr(f"{method}({entity.code})", STRING if t == "entity" else t)
        if len(args) == 3 and lower in mapping.GET_PROPERTIES_ARG:
            method, t = mapping.GET_PROPERTIES_ARG[lower]
            return TExpr(f"{method}({entity.code}, {self.text(args[2]).code})", STRING if t == "entity" else t)
        tail = "".join(f", {self.text(a).code}" for a in args[2:])
        if lower.endswith((".x", ".y", ".z")) or lower.startswith(("origin.", "angles.", "velocity.")):
            return TExpr(f"Float(GetProp({entity.code}, {string_literal(prop)}{tail}))", FLOAT)
        return TExpr(f"GetProp({entity.code}, {string_literal(prop)}{tail})", STRING)

    def _func_call(self, args: list[Expr]) -> TExpr:
        target, rest = args[0], args[1:]
        if isinstance(target, Name) and self._event_target(target) is not None:
            sig = self.ctx.signatures.get(target.text)
            if sig.returns == "string":
                return TExpr(f"{sig.method}({', '.join(self._event_args(sig, rest))})", STRING)
        parts = [self.text(a).code for a in rest]
        arglist = f", {{ {', '.join(parts)} }}" if parts else ""
        return TExpr(f"CallFunction({self.text(target).code}{arglist})", STRING)

    def _event_args(self, sig: Signature, args: list[Expr]) -> list[str]:
        return [self.value(a, t).code for (t, _), a in zip(sig.params, args)]

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
        tokens = cmd.args
        args = [parse_token(t.text, t.quoted) for t in tokens]

        if cmd.conditional and cmd.new_style:
            return self.lower_if(cmd)
        if name in ("setvar", "setvard"):
            return self._assign_field(cmd, tokens, args)
        if name == "setvarg":
            if not tokens:
                return []
            return [Line(f"SetGlobal({string_literal(tokens[0].text)}, {convert(self._concat(args[1:]), STRING).code})")]
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
        if name in ("breakloop", "resetloop"):
            return [Line(f'LegacyCommand("{name}")')]
        if name.startswith("token.") and tokens:
            return self._token(cmd, name, tokens, args)
        return self._mapped_command(cmd, name, tokens, args)

    # assignments ---------------------------------------------------------------------

    def _concat(self, values: list[Expr]) -> TExpr:
        """Several value tokens are glued together without spaces; the result is text."""
        if not values:
            return lit("")
        if len(values) == 1:
            return self.value(values[0])
        return join([self.value(v) for v in values])

    def _assign_field(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not tokens:
            return []
        target = tokens[0].text
        index = param_index(target)
        if index and index in self.params:
            self.ctx.quirk(cmd.line, f"handler assigns to PARAM{index}")
            return [Line(f'SetLocal("PARAM{index}", {convert(self._concat(args[1:]), STRING).code})')]
        if target in self.locals:          # setvard on a local's name updates the local
            return self._assign_local(cmd, tokens, args)
        value = self._concat(args[1:])
        if target in self.ctx.fields and names.is_identifier(target):
            t = self.ctx.fields[target]
            return [Line(f"{names.variable(target)} = {convert(value, t).code}")]
        target_expr = self.text(args[0]) if not names.is_identifier(target) else lit(target)
        return [Line(f"SetVar({target_expr.code}, {convert(value, STRING).code})")]

    def _assign_local(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not tokens:
            return []
        target = tokens[0].text
        value = self._concat(args[1:])
        if target.lower().startswith("reg.") or target not in self.locals:
            return [Line(f"SetLocal({string_literal(target)}, {convert(value, STRING).code})")]
        ident, t = self.locals[target]
        code = convert(value, t).code
        if target not in self.declared:
            if self.depth == 0:
                self.declared.add(target)
                return [Line(f"{t} {ident} = {code}")]
            self._declare_early(target)
        return [Line(f"{ident} = {code}")]

    def _lvalue(self, name: str) -> TExpr | None:
        if name in self.locals:
            if name not in self.declared:
                self._declare_early(name)
            ident, t = self.locals[name]
            return TExpr(ident, t)
        if name in self.ctx.fields and names.is_identifier(name):
            return TExpr(names.variable(name), self.ctx.fields[name])
        return None

    def _legacy(self, name: str, target: str, args: list[Expr]) -> list[Stmt]:
        parts = [string_literal(target)] + [self.text(a).code for a in args]
        return [Line(f'LegacyCommand("{name}", {{ {", ".join(parts)} }})')]

    def _math(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not tokens:
            return []
        if name == "subract":
            self.ctx.quirk(cmd.line, "`subract` is not a command; the engine drops this line")
            return [Comment(f"(no effect in .script: unknown command) subract {' '.join(t.text for t in tokens)}")]
        target = self._lvalue(tokens[0].text)
        if target is None:
            return self._legacy(name, tokens[0].text, args[1:])
        if name == "capvar":
            if len(args) < 3:
                return []
            t = target.type if target.type in NUMERIC_TYPES else FLOAT
            lo, hi = self.value(args[1], t), self.value(args[2], t)
            current = convert(target, t)
            return [Line(f"{target.code} = {convert(TExpr(f'Clamp({current.code}, {lo.code}, {hi.code})', t), target.type).code}")]
        if len(args) < 2:
            self.ctx.quirk(cmd.line, f"`{name}` without an amount does nothing")
            return []
        op = {"add": "+", "inc": "+", "incvar": "+", "subtract": "-", "dec": "-", "decvar": "-",
              "multiply": "*", "divide": "/", "mod": "%"}[name]
        if target.type not in NUMERIC_TYPES:
            amount = self.value(args[1], FLOAT)
            if op == "/":
                expr = f"Divide(Float({target.code}), {amount.code})"
            elif op == "%":
                expr = f"Modulo(Float({target.code}), {amount.code})"
            else:
                expr = f"Float({target.code}) {op} {amount.wrapped(MUL)}"
            return [Line(f"{target.code} = Text({expr})")]
        amount = self.value(args[1], target.type)
        if op in "+-" and amount.literal is not None and c_atof(amount.literal) == 1 and target.type == INT:
            return [Line(f"{target.code}{op}{op}")]
        if op in "+-*":
            return [Line(f"{target.code} {op}= {amount.code}")]
        helper = "Divide" if op == "/" else "Modulo"
        result = TExpr(f"{helper}({target.code}, {amount.code})", FLOAT)
        return [Line(f"{target.code} = {convert(result, target.type).code}")]

    def _stradd(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if len(tokens) < 2:
            return []
        target = self._lvalue(tokens[0].text)
        if target is None:
            return self._legacy("stradd", tokens[0].text, args[1:])
        if len(args) >= 3:
            value = join([self.value(args[1]), self.value(args[2])])
            return [Line(f"{target.code} = {convert(value, target.type).code}")]
        value = self.value(args[1])
        if target.type == STRING:
            return [Line(f"{target.code} += {join([lit(''), value]).code if value.type != STRING else value.code}")]
        return [Line(f"{target.code} = {convert(join([convert(target, STRING), value]), target.type).code}")]

    def _strconc(self, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not tokens:
            return []
        target = self._lvalue(tokens[0].text)
        if target is None or len(args) < 2:
            return self._legacy("strconc", tokens[0].text, args[1:]) if target is None else []
        words = join([self.value(a) for a in args[1:]], " ")
        value = join([convert(target, STRING), words])
        return [Line(f"{target.code} = {convert(value, target.type).code}")]

    def _vector(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if len(tokens) < 2:
            return []
        target = self._lvalue(tokens[0].text)
        if target is None or target.type != VECTOR:
            return self._legacy(name, tokens[0].text, args[1:])
        axis = tokens[1].text.lower()
        if axis in ("x", "y", "z") and len(args) >= 3:
            amount = self.value(args[2], FLOAT)
            op = {"vectoradd": "+=", "vectorset": "=", "vectormultiply": "*=", "vectorscale": "*="}[name]
            return [Line(f"{target.code}.{axis} {op} {amount.code}")]
        if name == "vectoradd":
            if len(args) >= 3:
                return [Line(f"{target.code} = {self.value(args[1], VECTOR).wrapped(ADD)} + {self.value(args[2], VECTOR).wrapped(ADD)}")]
            return [Line(f"{target.code} += {self.value(args[1], VECTOR).code}")]
        if name in ("vectormultiply", "vectorscale"):
            scalar = args[1]
            if isinstance(scalar, Number) and scalar.text.startswith("-"):
                self.ctx.quirk(cmd.line, "vectormultiply with a negative scalar sets the vector to (0,0,0)")
            return [Line(f"{target.code} *= {self.value(scalar, FLOAT).code}")]
        return self._legacy(name, tokens[0].text, args[1:])

    def _token(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        target = self._lvalue(tokens[0].text)
        helper = {"token.add": "TokenAdd", "token.del": "TokenRemove", "token.set": "TokenSet",
                  "token.scramble": "TokenShuffle"}.get(name)
        if target is None or helper is None or target.type != STRING:
            return self._legacy(name, tokens[0].text, args[1:])
        extra = [self.value(a, INT if (helper in ("TokenRemove", "TokenSet") and i == 0) else STRING).code
                 for i, a in enumerate(args[1:])]
        return [Line(f"{target.code} = {helper}({', '.join([target.code] + extra)})")]

    # events --------------------------------------------------------------------------------

    def _event_target(self, expr: Expr) -> str | None:
        if isinstance(expr, Name) and expr.text not in self.locals and not param_index(expr.text) \
                and expr.text not in self.ctx.fields and expr.text not in self.ctx.dynamic_vars \
                and not expr.text.lower().startswith(("game.", "const.", "ent_")):
            return expr.text
        return None

    def _callevent(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not args:
            return []
        if name == "calleventtimed":
            delay = self.value(args[1], FLOAT) if len(args) > 1 else _format_number(0, FLOAT)
            return [Line(f"CallEventDelayed({delay.code}, {self.text(args[0]).code})")]
        first = args[0]
        if isinstance(first, Number) and len(args) > 1:
            if len(args) > 2:
                self.ctx.quirk(cmd.line, "parameters of a delayed callevent are dropped by the engine")
            return [Line(f"CallEventDelayed({self.value(first, FLOAT).code}, {self.text(args[1]).code})")]
        event = self._event_target(first)
        if event is not None:
            if event == self.event_name:
                self.ctx.quirk(cmd.line, f"callevent {event} inside {event} is ignored by the engine")
                return [Comment(f"(no effect in .script: an event cannot call itself) callevent {event}")]
            sig = self.ctx.signatures.get(event)
            return [Line(f"{sig.method}({', '.join(self._event_args(sig, args[1:]))})")]
        # The engine decides at run time: a first argument starting with a digit is a delay
        parts = [self.text(a).code for a in args]
        tail = f", {{ {', '.join(parts[1:])} }}" if parts[1:] else ""
        return [Line(f"CallEventOrDelay({parts[0]}{tail})")]

    def _calleventloop(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if len(args) < 2:
            return []
        rest = args[1:]
        event = self._event_target(rest[0]) if not isinstance(rest[0], Number) else None
        if event is None:
            if isinstance(rest[0], Number):
                self.ctx.quirk(cmd.line, "calleventloop with a delay")
            parts = [self.text(a).code for a in args]
            return [Line(f'LegacyCommand("calleventloop", {{ {", ".join(parts)} }})')]
        count = self.value(args[0], INT)
        sig = self.ctx.signatures.get(event)
        self.ctx.uses_loop_iteration = True
        call = f"{sig.method}({', '.join(self._event_args(sig, rest[1:]))})"
        return [For(f"loopIteration = 0; loopIteration < {count.code}; loopIteration++", [Line(call)])]

    def _callexternal(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if len(args) < 2:
            return []
        if isinstance(args[1], Number):
            return [Line(f'LegacyCommand("callexternal", {{ {", ".join(self.text(a).code for a in args)} }})')]
        target = self.text(args[0])
        event = lit(args[1].text) if self._event_target(args[1]) is not None else self.text(args[1])
        params = [self.text(a).code for a in args[2:]]
        tail = f", {{ {', '.join(params)} }}" if params else ""
        return [Line(f"CallExternal({target.code}, {event.code}{tail})")]

    def _return(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if self.returns != "string":
            return [Line(f"Return({join([self.value(a) for a in args], ' ').code})")]
        if len(tokens) == 1 and tokens[0].text == "**clear":
            return [Line('result = ""')]
        if tokens and tokens[0].text == "**clear**":
            self.ctx.quirk(cmd.line, "`return **clear**` is not a clear (the engine expects `**clear`); "
                                     "it adds the text **clear** to the result")
        value = join([self.value(a) for a in args], " ")
        return [Line(f"result = AppendResult(result, {value.code})")]

    # mapped commands -----------------------------------------------------------------------

    def _mapped_command(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        spec = mapping.COMMANDS.get(name)
        if spec is not None:
            call = self._wrapper_call(spec, args)
            if call is not None:
                return [Line(call)]
        parts = [self.text(a).code for a in args]
        arglist = f", {{ {', '.join(parts)} }}" if parts else ""
        return [Line(f"LegacyCommand({string_literal(cmd.name)}{arglist})")]

    def _wrapper_call(self, spec: mapping.CommandSpec, args: list[Expr]) -> str | None:
        params = spec.params
        has_text = bool(params) and params[-1].type == "text"
        fixed = params[:-1] if has_text else params
        required = len([p for p in fixed if not p.optional])
        if len(args) < required or (not has_text and len(args) > len(fixed)):
            return None
        if has_text and not params[-1].optional and len(args) <= len(fixed) and params[-1].name not in ("args", "params"):
            # a required trailing text with nothing given: let the engine report it as before
            if len(args) < len(fixed) + 1 and spec.params[-1].name not in ("name", "message", "description"):
                pass
        out = [self.value(a, p.type).code for p, a in zip(fixed, args)]
        if has_text:
            rest = args[len(fixed):]
            if rest:
                out.append(join([self.value(a) for a in rest], " ").code)
        return f"{spec.method}({', '.join(out)})"


def _cmd_source(cmd: Cmd) -> str:
    words = " ".join(t.text if not t.quoted else f'"{t.text}"' for t in cmd.args)
    return f"{cmd.name} {words}".strip()


def _default_value(t: str) -> str:
    return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, '""')


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
