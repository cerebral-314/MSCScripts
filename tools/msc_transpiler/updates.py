"""Commands that set a variable: setvar/setvard/local, the math commands, stradd/strconc, the
vector commands and token.*. Mixed into HandlerLowerer (lower.py).

Each whole-value assignment and each update of a variable from its current value carries enough
structure (ir.Assign / ir.Update) for the printer to fold `setvard X 359` + `divide X N` into one
expression. A target that is an AngelScript local, field or parameter is changed directly, whatever
its type; only a variable that exists only at run time goes through the engine (LegacyCommand).
"""

from __future__ import annotations

from . import names
from .expr import Expr, Number, param_index
from .infer import FLOAT, INT, STRING, VECTOR
from .ir import ADD, MUL, UNARY, Append, Assign, Comment, Line, Stmt, TExpr, Update
from .syntax import Cmd, Token
from .values import NUMERIC_TYPES, c_atof, convert, join, lit, string_literal


class UpdateCommands:
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
            n, t = self.params[index]
            value = self._concat(args[1:])
            return [Line(f"{n} = {convert(value, t).code}", assign=Assign(n, t, value))]
        if target in self.locals:          # setvard on a local's name updates the local
            return self._assign_local(cmd, tokens, args)
        value = self._concat(args[1:])
        if target in self.ctx.fields and names.is_identifier(target):
            t = self.ctx.fields[target]
            ident = names.variable(target)
            return [Line(f"{ident} = {convert(value, t).code}", assign=Assign(ident, t, value, field=True))]
        target_expr = self.text(args[0]) if not names.is_identifier(target) else lit(target)
        return [Line(f"SetVar({target_expr.code}, {self._any(args[1:], value).code})")]

    def _assign_local(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not tokens:
            return []
        target = tokens[0].text
        if param_index(target):            # parameters are the event's locals: this sets the parameter
            return self._assign_field(cmd, tokens, args)
        value = self._concat(args[1:])
        field_name = target[len("reg.mitem."):] if target.lower().startswith("reg.mitem.") else None
        if field_name in {"id", "title", "type", "data", "callback", "cb_failed", "priority"}:
            if not self.menu_item:
                self.menu_item = True
                self.top_declarations.append(Line("MenuItem menuItem"))
            return [Line(f"menuItem.{field_name} = {convert(value, STRING).code}")]
        if target.lower().startswith("reg.") or target not in self.locals:
            return [Line(f"SetLocal({string_literal(target)}, {self._any(args[1:], value).code})")]
        if target in self.aliases:
            return []        # the local is just the parameter
        if target in self.splits:
            declare = id(cmd) in self.inline_decls and target not in self.declared
            if declare:
                self.declared.add(target)
            elif target not in self.declared:
                self._declare_early(target)
            return self._split_assign(target, value, declare)
        ident, t = self.locals[target]
        code = convert(value, t).code
        if id(cmd) in self.inline_decls and target not in self.declared:
            self.declared.add(target)
            return [Line(f"{t} {ident} = {code}", declares=True, assign=Assign(ident, t, value, f"{t} "))]
        if target not in self.declared:
            self._declare_early(target)
        return [Line(f"{ident} = {code}", assign=Assign(ident, t, value))]

    def _lvalue(self, name: str, numeric: bool = False) -> TExpr | None:
        """The variable a command changes. A split local (split.py) gives its number for math."""
        if name in self.splits:
            if name not in self.declared:
                self._declare_early(name)
            return self._split_target(name, numeric)
        index = param_index(name)
        if index and index in self.params:
            n, t = self.params[index]
            return TExpr(n, t)
        if name in self.locals:
            if name not in self.declared:
                self._declare_early(name)
            ident, t = self.locals[name]
            return TExpr(ident, t)
        if name in self.ctx.fields and names.is_identifier(name):
            return TExpr(names.variable(name), self.ctx.fields[name])
        return None

    def _is_field(self, target: TExpr) -> bool:
        return target.code not in {ident for ident, _ in self.locals.values()}

    def _legacy(self, name: str, target: str, args: list[Expr]) -> list[Stmt]:
        return [Line(f'LegacyCommand("{name}", {string_literal(target)}{self.args(args)})')]

    def _any(self, values: list[Expr], joined: TExpr) -> TExpr:
        """A value for a `const ?&in` parameter: one token keeps its type, several are joined text."""
        return self.arg(values[0]) if len(values) == 1 else convert(joined, STRING)

    def _set(self, target: TExpr, apply, reads: list[TExpr], short: str | None = None) -> list[Stmt]:
        """`target = apply(target)`, or `short` (`x += 2`) when that says the same. The line keeps
        `apply` so the printer can fold it into an assignment just before it."""
        code = short or f"{target.code} = {convert(apply(target), target.type).code}"
        update = Update(target.code, target.type, apply, " ".join(r.code for r in reads)) \
            if names.is_identifier(target.code) else None
        return [Line(code, update=update)]

    def _math(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if not tokens:
            return []
        if name == "subract":
            self.ctx.quirk(cmd.line, "`subract` is not a command; the engine drops this line")
            return [Comment(f"(no effect in .script: unknown command) subract {' '.join(t.text for t in tokens)}")]
        target = self._lvalue(tokens[0].text, numeric=True)
        if target is None:
            return self._legacy(name, tokens[0].text, args[1:])
        if name == "capvar":
            if len(args) < 3:
                return []
            # capvar works on floats like the other math commands
            lo, hi = (self.value(a, FLOAT) for a in args[1:3])
            return self._set(target, lambda cur: TExpr(f"Clamp({convert(cur, FLOAT).code}, {lo.code}, {hi.code})", FLOAT),
                             [lo, hi])
        if len(args) < 2:
            self.ctx.quirk(cmd.line, f"`{name}` without an amount does nothing")
            return []
        op = {"add": "+", "inc": "+", "incvar": "+", "subtract": "-", "dec": "-", "decvar": "-",
              "multiply": "*", "divide": "/", "mod": "%"}[name]
        numeric = target.type in NUMERIC_TYPES
        work = target.type if numeric else FLOAT       # a text variable is read as a number
        amount = self.value(args[1], work)
        prec = ADD if op in "+-" else MUL

        def apply(cur: TExpr) -> TExpr:
            if op in "/%":
                helper = "Divide" if op == "/" else "Modulo"
                return TExpr(f"{helper}({convert(cur, FLOAT).code}, {convert(amount, FLOAT).code})", FLOAT)
            current = convert(cur, work)
            if current.literal is not None and op in "+*" and c_atof(current.literal) == (0 if op == "+" else 1):
                return convert(amount, work)          # 0 + x, 1 * x
            return TExpr(f"{current.wrapped(prec)} {op} {amount.wrapped(prec - 1)}", work, prec)

        short = None
        if numeric and op in "+-" and amount.literal is not None and c_atof(amount.literal) == 1 and target.type == INT:
            short = f"{target.code}{op}{op}"
        elif numeric and op in "+-*":
            short = f"{target.code} {op}= {amount.code}"
        return self._set(target, apply, [amount], short)

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
            return [Append(target.code, value)]
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
        """ScriptCmd_VectorAdd / VectorMultiply / VectorSet. The axis names are case-sensitive there."""
        if len(tokens) < 2:
            return []
        target = self._lvalue(tokens[0].text)
        if target is None:
            return self._legacy(name, tokens[0].text, args[1:])
        is_vector = target.type == VECTOR
        axis = tokens[1].text if tokens[1].text in ("x", "y", "z") else None
        if axis is not None:
            if len(args) < 3:
                return []
            amount = self.value(args[2], FLOAT)
            unit = {"x": "Vector3({}, 0.0f, 0.0f)", "y": "Vector3(0.0f, {}, 0.0f)", "z": "Vector3(0.0f, 0.0f, {})"}[axis]
            on_axis = unit.format(amount.code)
            if name == "vectorset":
                if is_vector:
                    return [Line(f"{target.code}.{axis} = {amount.code}")]
                return self._set(target, lambda cur: TExpr(f"With{axis.upper()}({convert(cur, VECTOR).code}, {amount.code})",
                                                           VECTOR), [amount])
            if name == "vectoradd":
                if is_vector:
                    return [Line(f"{target.code}.{axis} += {amount.code}")]
                return self._set(target, lambda cur: TExpr(f"{convert(cur, VECTOR).wrapped(ADD)} + {on_axis}", VECTOR, ADD),
                                 [amount])
            self.ctx.quirk(cmd.line, f"`{name} {tokens[0].text} {axis} ...` keeps only the {axis} component "
                                     "(the engine multiplies by a vector that is 0 on the other axes)")
            return self._set(target, lambda cur: TExpr(f"Scale({convert(cur, VECTOR).code}, {on_axis})", VECTOR), [amount])
        if name == "vectorset":
            self.ctx.quirk(cmd.line, "vectorset needs x, y or z: the engine logs an error and leaves the vector as it is")
            return [Comment(f"(no effect in .script: vectorset needs x, y or z) {_cmd_source(cmd)}")]
        if name == "vectoradd":
            if len(args) >= 3:          # vectoradd V a b: V = a + b
                a, b = self.value(args[1], VECTOR), self.value(args[2], VECTOR)
                value = TExpr(f"{a.wrapped(ADD)} + {b.wrapped(MUL)}", VECTOR, ADD)
                return [Line(f"{target.code} = {convert(value, target.type).code}",
                             assign=Assign(target.code, target.type, value, field=self._is_field(target)))]
            amount = self.value(args[1], VECTOR)
            return self._set(target, lambda cur: TExpr(f"{convert(cur, VECTOR).wrapped(ADD)} + {amount.wrapped(MUL)}",
                                                       VECTOR, ADD),
                             [amount], f"{target.code} += {amount.code}" if is_vector else None)
        # vectormultiply / vectorscale: a number scales, anything else multiplies component by component
        if len(args) >= 3:              # vectormultiply V a f: V = a * f
            base, factor_expr = self.value(args[1], VECTOR), args[2]
        else:
            base, factor_expr = None, args[1]
        factor = self.value(factor_expr)
        if isinstance(factor_expr, Number) and factor_expr.text.startswith("-"):
            self.ctx.quirk(cmd.line, "vectormultiply by a negative number sets the vector to (0,0,0) "
                                     "(the engine only takes text starting with a digit as a number)")
            value = TExpr("Vector3()", VECTOR)
            return [Line(f"{target.code} = {convert(value, target.type).code}", assign=Assign(target.code, target.type, value, field=self._is_field(target)),
                         trailing="vectormultiply by a negative number gives (0,0,0) in .script")]

        def scaled(vec: TExpr) -> TExpr:
            if factor.type == VECTOR:
                return TExpr(f"Scale({vec.code}, {factor.code})", VECTOR)
            return TExpr(f"{vec.wrapped(MUL)} * {convert(factor, FLOAT).wrapped(UNARY)}", VECTOR, MUL)

        if base is not None:
            value = scaled(base)
            return [Line(f"{target.code} = {convert(value, target.type).code}", assign=Assign(target.code, target.type, value, field=self._is_field(target)))]
        short = f"{target.code} *= {convert(factor, FLOAT).code}" if is_vector and factor.type != VECTOR else None
        return self._set(target, lambda cur: scaled(convert(cur, VECTOR)), [factor], short)

    def _token(self, cmd: Cmd, name: str, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        target = self._lvalue(tokens[0].text)
        helper = {"token.add": "TokenAdd", "token.del": "TokenRemove", "token.set": "TokenSet",
                  "token.scramble": "TokenShuffle"}.get(name)
        needed = {"TokenAdd": 1, "TokenRemove": 1, "TokenSet": 2, "TokenShuffle": 0}.get(helper or "", 0)
        if target is None or helper is None or len(args) - 1 < needed:
            return self._legacy(name, tokens[0].text, args[1:])
        extra = [self.value(a, INT if (helper in ("TokenRemove", "TokenSet") and i == 0) else STRING)
                 for i, a in enumerate(args[1:1 + needed])]
        return self._set(target, lambda cur: TExpr(f"{helper}({', '.join([convert(cur, STRING).code] + [e.code for e in extra])})",
                                                   STRING), extra)

def _cmd_source(cmd: Cmd) -> str:
    words = " ".join(t.text if not t.quoted else f'"{t.text}"' for t in cmd.args)
    return f"{cmd.name} {words}".strip()
