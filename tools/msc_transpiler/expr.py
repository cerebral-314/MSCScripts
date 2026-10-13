"""Turning MS-Script tokens into expression trees.

Every command parameter in .script is one whitespace-free token (or a quoted
string) that the interpreter evaluates with CScript::GetVar at run time:
'text' is a literal, $name(a,b) calls a function (arguments split on
top-level commas and evaluated first), (x,y,z) is a vector, and anything else
is a variable lookup that falls back to the text itself when no such variable
exists. These trees keep that information so later stages can decide what is
a variable, a literal or a call.
"""

from __future__ import annotations

import re
from dataclasses import dataclass, field

NUMBER = re.compile(r"^[+-]?(\d+\.?\d*|\.\d+)$")
PERCENT = re.compile(r"^[+-]?(\d+\.?\d*|\.\d+)%$")
PARAM = re.compile(r"^param(\d+)$", re.I)


@dataclass
class Expr:
    pass


@dataclass
class Literal(Expr):
    text: str
    quoted: bool = False          # "..." or '...' in the source


@dataclass
class Number(Expr):
    text: str                     # as written (e.g. "0.5", "20%")

    @property
    def value(self) -> float:
        return float(self.text.rstrip("%"))

    @property
    def is_int(self) -> bool:
        return "." not in self.text and not self.text.endswith("%")


@dataclass
class Name(Expr):
    """A bare word: variable, constant, parameter, built-in, or (if nothing matches) its own text."""
    text: str


@dataclass
class Call(Expr):
    name: str                     # with the $ (e.g. "$get", "$vec.x")
    args: list[Expr] = field(default_factory=list)
    raw: str = ""


@dataclass
class Vector(Expr):
    parts: list[Expr]
    raw: str = ""


@dataclass
class Not(Expr):
    operand: Expr


def split_args(text: str) -> list[str]:
    """Split on commas that are not nested inside parentheses (BreakUpLine)."""
    parts, depth, start = [], 0, 0
    for i, ch in enumerate(text):
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif ch == "," and depth == 0:
            parts.append(text[start:i])
            start = i + 1
    parts.append(text[start:])
    return parts


def _matching_paren(text: str, open_index: int) -> int:
    depth = 0
    for i in range(open_index, len(text)):
        if text[i] == "(":
            depth += 1
        elif text[i] == ")":
            depth -= 1
            if depth == 0:
                return i
    return -1


def parse_token(text: str, quoted: bool = False) -> Expr:
    """Parse one command parameter / condition operand."""
    if quoted:
        return Literal(text, quoted=True)
    if len(text) >= 2 and text[0] == "'" and text[-1] == "'":
        return Literal(text[1:-1], quoted=True)
    if text.startswith("!") and len(text) > 1:
        return Not(parse_token(text[1:]))
    if text.startswith("$"):
        open_index = text.find("(")
        if open_index > 1:
            close = _matching_paren(text, open_index)
            if close == -1:
                close = len(text)
            inner = text[open_index + 1:close]
            args = [parse_token(part) for part in split_args(inner)] if inner != "" else []
            return Call(text[:open_index], args, raw=text)
        return Call(text, [], raw=text)
    if text.startswith("(") and text.endswith(")") and "," in text:
        return Vector([parse_token(part) for part in split_args(text[1:-1])], raw=text)
    if NUMBER.match(text) or PERCENT.match(text):
        return Number(text)
    return Name(text)


def walk(expr: Expr):
    yield expr
    if isinstance(expr, Call):
        for arg in expr.args:
            yield from walk(arg)
    elif isinstance(expr, Vector):
        for part in expr.parts:
            yield from walk(part)
    elif isinstance(expr, Not):
        yield from walk(expr.operand)


def param_index(name: str) -> int | None:
    match = PARAM.match(name)
    return int(match.group(1)) if match else None


def source_text(expr: Expr) -> str:
    """Re-create the .script spelling (for comments and diagnostics)."""
    if isinstance(expr, Literal):
        return f"'{expr.text}'" if expr.quoted else expr.text
    if isinstance(expr, Number):
        return expr.text
    if isinstance(expr, Name):
        return expr.text
    if isinstance(expr, Not):
        return "!" + source_text(expr.operand)
    if isinstance(expr, Call):
        return expr.raw or f"{expr.name}({','.join(source_text(a) for a in expr.args)})"
    if isinstance(expr, Vector):
        return expr.raw or "(" + ",".join(source_text(p) for p in expr.parts) + ")"
    return str(expr)
