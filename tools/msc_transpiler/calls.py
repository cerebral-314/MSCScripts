"""Events calling events: callevent, calleventloop, callexternal, $func and return. Mixed into
HandlerLowerer (lower.py).

An event of this script is a method, so `callevent ev a b` is `OnEv(a, b)` with each argument
converted to the parameter's type. Delays, names known only at run time and other entities' events
go through the engine.
"""

from __future__ import annotations

from . import names
from .context import Signature
from .expr import Expr, Name, Number, param_index
from .infer import BOOL, FLOAT, INT, STRING
from .ir import Comment, For, If, Line, Stmt, TExpr
from .syntax import Cmd, Token
from .updates import _cmd_source
from .values import convert, format_number, join, lit


class EventCalls:
    def _func_call(self, args: list[Expr]) -> TExpr:
        target, rest = args[0], args[1:]
        if isinstance(target, Name) and self._event_target(target) is not None:
            sig = self.ctx.signatures.get(target.text)
            if sig.returns == "string":
                return TExpr(f"{sig.method}({', '.join(self._event_args(sig, rest))})", STRING)
        return TExpr(f"CallFunction({self.text(target).code}{self.args(rest)})", STRING)

    def _event_args(self, sig: Signature, args: list[Expr]) -> list[str]:
        return [self.value(a, t).code for (t, _), a in zip(sig.params, args)]

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
            delay = self.value(args[1], FLOAT) if len(args) > 1 else format_number(0, FLOAT)
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
        first_value = self.value(first)
        if len(args) > 1 and (first_value.type in (INT, FLOAT) or first_value.numeric is not None):
            # a number (not negative) starts with a digit: the engine takes it as a delay
            if len(args) > 2:
                self.ctx.quirk(cmd.line, "parameters of a delayed callevent are dropped by the engine")
            return [Line(f"CallEventDelayed({convert(first_value, FLOAT).code}, {self.text(args[1]).code})")]
        # The engine decides at run time: a first argument starting with a digit is a delay
        return [Line(f"CallEventOrDelay({self.arg(first).code}{self.args(args[1:])})")]

    def _calleventloop(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if len(args) < 2:
            return []
        rest = args[1:]
        event = self._event_target(rest[0]) if not isinstance(rest[0], Number) else None
        if event is None:
            if isinstance(rest[0], Number):
                self.ctx.quirk(cmd.line, "calleventloop with a delay")
            return [Line(f'LegacyCommand("calleventloop"{self.args(args)})')]
        if event == self.event_name:
            self.ctx.quirk(cmd.line, f"calleventloop {event} inside {event} is ignored by the engine")
            return [Comment(f"(no effect in .script: an event cannot call itself) {_cmd_source(cmd)}")]
        return self._loop(self.value(args[0], INT), event, rest[1:])

    def _loop(self, count: TExpr, event: str, params: list[Expr]) -> list[Stmt]:
        """calleventloop: the event runs `count` times (counted once, before the first run), each run
        seeing its index as game.script.iteration (loopIteration); `breakloop` stops it. The index of
        a loop this one runs inside is put back afterwards, as the engine does."""
        sig = self.ctx.signatures.get(event)
        self.ctx.uses_loop_iteration = True
        taken = {ident for ident, _ in self.locals.values()} | {n for n, _ in self.params.values()}
        index = next(n for n in ("i", "n", "iteration", "loopIndex") if n not in taken)
        out: list[Stmt] = []
        if count.literal is None and not (count.code in taken and names.is_identifier(count.code)):
            name = next(n for n in ("count", "loops", "loopCount") if n not in taken and n != index)
            out.append(self._loop_local(name, count.code))
            count = TExpr(name, INT)
        body: list[Stmt] = [Line(f"loopIteration = {index}"),
                            Line(f"{sig.method}({', '.join(self._event_args(sig, params))})")]
        if self.ctx.inference.breaks_loop(event):
            body.append(If(TExpr("breakLoop", BOOL), [Line("breakLoop = false"), Line("break")]))
        loop = For(f"int {index} = 0; {index} < {count.code}; {index}++", body)
        if self.event_name not in self.ctx.inference.loop_events:
            return out + [loop]
        outer = next(n for n in ("outerIteration", "outerLoopIteration") if n not in taken)
        return out + [self._loop_local(outer, "loopIteration"), loop, Line(f"loopIteration = {outer}")]

    def _loop_local(self, name: str, value: str) -> Line:
        """`int name = value` the first time; later loops of the handler reuse the variable. One first
        needed inside a block is declared at the top of the method, so later loops anywhere see it."""
        if name in self.loop_counts:
            return Line(f"{name} = {value}")
        self.loop_counts.add(name)
        if self.depth == 0:
            return Line(f"int {name} = {value}", declares=True)
        self.top_declarations.append(Line(f"int {name}", declares=True))
        return Line(f"{name} = {value}")

    def _callexternal(self, cmd: Cmd, tokens: list[Token], args: list[Expr]) -> list[Stmt]:
        if len(args) < 2:
            return []
        if isinstance(args[1], Number):
            return [Line(f'LegacyCommand("callexternal"{self.args(args)})')]
        target = self.entity(args[0])
        event = lit(args[1].text) if self._event_target(args[1]) is not None else self.text(args[1])
        return [Line(f"CallExternal({target.code}, {event.code}{self.args(args[2:])})")]

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
