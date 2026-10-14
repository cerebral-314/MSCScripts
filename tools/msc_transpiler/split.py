"""Locals that hold a number and then text. Mixed into HandlerLowerer (lower.py).

.script variables have no type, so a handler may count something in a local and then turn the
same local into a message:

    local N_NPCS $get_token_amt(G_CRITICAL_NPCS)
    if ( N_NPCS > 1 ) stradd N_NPCS " Critical NPC's Remain!"
    if ( N_NPCS == 1 ) local N_NPCS "Only One Critical NPC Remains!"
    infomsg all N_NPCS MSG_REASON

As one AngelScript variable it would be text with a conversion at every numeric use. Instead
such a local becomes two: the number (`nNpcs`) and its text (`nNpcsText`). Each assignment sets
both the way .script would read them afterwards (text that reads as 0 sets the number to 0),
numeric uses read the number, text uses read the text, and assignments nobody reads afterwards
are removed.
"""

from __future__ import annotations

import re


from .expr import parse_token
from .infer import BOOL, FLOAT, INT, MATH_COMMANDS, STRING, VECTOR, command_reads
from .ir import Append, Assign, Comment, For, If, Line, Return, Stmt, TExpr
from .syntax import CmdList
from .values import c_atof, convert, format_number

# text appended with stradd keeps the number .script reads from the start of the text
_KEEPS_NUMBER = re.compile(r"[^0-9.+\-eE]")
# conversions that have no effect besides their value, so an unread assignment of them can go
_PURE = re.compile(r"\b(?!(?:Text|Float|Int|Vec|Truthy)\()[A-Za-z_]\w*\(")


class SplitLocals:
    splits: dict[str, tuple[str, str, str]]     # legacy name -> (number ident, number type, text ident)

    def _find_splits(self, evidence: dict) -> None:
        """Called once the locals have their types. A text local that is only ever read as a number
        becomes a number; one read both ways is split into a number and its text."""
        self.splits = {}
        reads: dict[str, list[int]] = {}           # name -> [numeric reads, text reads]
        self._count_reads(self.event.commands, reads)
        taken = {ident for ident, _ in self.locals.values()} | {n for n, _ in self.params.values()} \
            | set(self.ctx.fields) | {"result", "self", "host", "menuItem"}
        for name, (ident, t) in list(self.locals.items()):
            numeric_reads, text_reads = reads.get(name, [0, 0])
            if t != STRING or not numeric_reads or name in self.aliases:
                continue
            ev = evidence[name]
            num_t = FLOAT if (ev.floats or ev.math) else INT
            if not text_reads:
                self.locals[name] = (ident, num_t)      # only ever used as a number
                continue
            text_ident, n = ident + "Text", 2
            while text_ident in taken:
                text_ident, n = f"{ident}Text{n}", n + 1
            taken.add(text_ident)
            self.splits[name] = (ident, num_t, text_ident)
            self.locals[name] = (text_ident, STRING)

    def _count_reads(self, cmds: CmdList, reads: dict[str, list[int]]) -> None:
        """How often each local is read as a number and as text (see infer.command_reads)."""
        def read(text: str, numeric: bool) -> None:
            if text in self.locals:
                reads.setdefault(text, [0, 0])[0 if numeric else 1] += 1

        for cmd in cmds.cmds:
            command_reads(cmd, [parse_token(tok.text, tok.quoted) for tok in cmd.args], read)
            if cmd.if_list:
                self._count_reads(cmd.if_list, reads)
            for e in cmd.else_lists:
                self._count_reads(e, reads)

    # -- reads and writes ------------------------------------------------------------------

    def _split_read(self, name: str) -> TExpr:
        num, num_t, text = self.splits[name]
        return TExpr(text, STRING, numeric=TExpr(num, num_t))

    def _split_target(self, name: str, numeric: bool) -> TExpr:
        num, num_t, text = self.splits[name]
        return TExpr(num, num_t) if numeric else TExpr(text, STRING)

    def _split_assign(self, name: str, value: TExpr, declare: bool) -> list[Stmt]:
        """`local N value`: the number and the text the .script would read afterwards."""
        num, num_t, text = self.splits[name]
        if value.numeric is not None:                       # a copy of another split local
            pairs = [(num, num_t, value.numeric), (text, STRING, TExpr(value.code, STRING))]
        elif value.type in (INT, FLOAT, BOOL):
            pairs = [(num, num_t, value), (text, STRING, convert(TExpr(num, num_t), STRING))]
        elif value.type == STRING and value.literal is not None:
            pairs = [(text, STRING, value), (num, num_t, format_number(c_atof(value.literal), num_t))]
        elif value.type == VECTOR:
            pairs = [(text, STRING, convert(value, STRING)), (num, num_t, format_number(0, num_t))]
        else:
            pairs = [(text, STRING, value), (num, num_t, convert(TExpr(text, STRING), num_t))]
        return [self._split_line(ident, t, v, declare) for ident, t, v in pairs]

    def _split_resync(self, name: str, from_number: bool) -> list[Stmt]:
        """After a command changed one of the two, set the other."""
        num, num_t, text = self.splits[name]
        if from_number:
            return [self._split_line(text, STRING, convert(TExpr(num, num_t), STRING), False)]
        return [self._split_line(num, num_t, convert(TExpr(text, STRING), num_t), False)]

    def _split_line(self, ident: str, t: str, value: TExpr, declare: bool) -> Line:
        prefix = f"{t} " if declare else ""
        return Line(f"{prefix}{ident} = {convert(value, t).code}", declares=declare,
                    assign=Assign(ident, t, value, prefix))

    def _split_declare_early(self, name: str) -> None:
        num, num_t, text = self.splits[name]
        self.top_declarations.append(self._split_line(num, num_t, format_number(c_atof(name), num_t), True))
        self.top_declarations.append(self._split_line(text, STRING, TExpr(f'"{name}"', STRING, literal=name), True))

    def _split_command(self, cmd, name: str, run) -> list[Stmt]:
        """A command that changes split local `cmd.args[0]`: math works on the number, the rest on
        the text, then the other half follows."""
        target = cmd.args[0].text
        stmts = run()
        if name in MATH_COMMANDS:
            return stmts + self._split_resync(target, from_number=True)
        if name == "stradd" and len(cmd.args) == 2:
            added = self.value(parse_token(cmd.args[1].text, cmd.args[1].quoted))
            if added.literal and _KEEPS_NUMBER.match(added.literal[0]):
                return stmts               # "5" + " remain" still reads as 5
        return stmts + self._split_resync(target, from_number=False)

    def _split_cleanup(self, body: list[Stmt]) -> list[Stmt]:
        """Remove the assignments of the split halves that nothing reads afterwards, and declare a
        half where it is first set when nothing needs it earlier."""
        for num, _, text in self.splits.values():
            for ident in (num, text):
                body = [s for s in body if not (isinstance(s, Line) and s.code == f"{ident} = {ident}")]
                body, _ = _prune(body, ident, live_out=False)
                if not any(_mentions(s, ident) for s in body if not _declaration_of(s, ident)):
                    body = [s for s in body if not _declaration_of(s, ident)]
                body = _declare_at_first_assignment(body, ident)
        return body


# -- dead stores ----------------------------------------------------------------------------

def _word(ident: str):
    return re.compile(rf"\b{re.escape(ident)}\b")


def _mentions(stmt: Stmt, ident: str) -> bool:
    w = _word(ident)
    if isinstance(stmt, Line):
        return bool(w.search(stmt.code))
    if isinstance(stmt, Append):
        return stmt.target == ident or bool(w.search(stmt.value.code))
    if isinstance(stmt, Return):
        return bool(stmt.value and w.search(stmt.value))
    if isinstance(stmt, If):
        return bool(w.search(stmt.cond.code)) or any(_mentions(s, ident) for s in stmt.then + (stmt.else_ or []))
    if isinstance(stmt, For):
        return bool(w.search(stmt.header)) or any(_mentions(s, ident) for s in stmt.body)
    return False


def _prune(stmts: list[Stmt], ident: str, live_out: bool) -> tuple[list[Stmt], bool]:
    """Drop unread assignments of `ident`. Returns the statements and whether `ident` is read
    before being set again (live at the start)."""
    w = _word(ident)
    out: list[Stmt] = []
    live = live_out
    for stmt in reversed(stmts):
        if isinstance(stmt, Line) and stmt.assign is not None and stmt.assign.target == ident \
                and not w.search(stmt.assign.value.code if stmt.assign.value else ""):
            value_code = stmt.code.split(" = ", 1)[1] if " = " in stmt.code else ""
            if not live and not _PURE.search(value_code) and not w.search(value_code):
                if stmt.declares:
                    out.append(Line(f"{stmt.assign.type} {ident}", declares=True, comments=stmt.comments,
                                    blank=stmt.blank))
                elif stmt.comments:
                    out.append(Comment(stmt.comments[0]))
                continue
            out.append(stmt)
            live = bool(w.search(value_code))
        elif isinstance(stmt, (Line, Append)) and _updates(stmt, ident):
            if not live and not _PURE.search(stmt.code if isinstance(stmt, Line) else stmt.value.code):
                continue
            out.append(stmt)
            live = True
        elif isinstance(stmt, If):
            then, live_then = _prune(stmt.then, ident, live)
            else_, live_else = _prune(stmt.else_, ident, live) if stmt.else_ else (None, live)
            stmt.then, stmt.else_ = then, else_
            out.append(stmt)
            live = live_then or live_else or bool(w.search(stmt.cond.code))
        elif isinstance(stmt, Return):
            out.append(stmt)
            live = bool(stmt.value and w.search(stmt.value))
        else:
            out.append(stmt)
            if _mentions(stmt, ident):
                live = True
    return list(reversed(out)), live


def _declaration_of(stmt: Stmt, ident: str) -> bool:
    return isinstance(stmt, Line) and stmt.declares and stmt.assign is not None and stmt.assign.target == ident \
        or isinstance(stmt, Line) and stmt.declares and stmt.code.endswith(f" {ident}") and " = " not in stmt.code


def _declare_at_first_assignment(body: list[Stmt], ident: str) -> list[Stmt]:
    """`string t;` ... `t = v;` with nothing using t in between (at the same level) -> `string t = v;`"""
    for i, stmt in enumerate(body):
        if not (isinstance(stmt, Line) and stmt.declares and " = " not in stmt.code and stmt.code.endswith(f" {ident}")):
            continue
        type_ = stmt.code[:-len(ident) - 1]
        for j in range(i + 1, len(body)):
            later = body[j]
            if not _mentions(later, ident):
                continue
            if isinstance(later, Line) and later.assign is not None and later.assign.target == ident \
                    and later.code.startswith(f"{ident} = ") and not _word(ident).search(later.code.split(" = ", 1)[1]):
                later.code = f"{type_} {later.code}"
                later.declares = True
                later.assign = Assign(ident, later.assign.type, later.assign.value, f"{type_} ", later.assign.field)
                later.comments = stmt.comments + later.comments
                return body[:i] + body[i + 1:]
            break
        break
    return body


def _updates(stmt: Stmt, ident: str) -> bool:
    if isinstance(stmt, Append):
        return stmt.target == ident
    return isinstance(stmt, Line) and stmt.update is not None and stmt.update.target == ident
