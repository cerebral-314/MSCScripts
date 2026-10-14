"""Statement tree for generated methods, printed by emit.py.

Expressions are already AngelScript text by the time they get here (with their
type and precedence in TExpr); statements stay structured so the printer can
make else-if chains, merge nested ifs and pick early returns.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Callable

# Precedence of an expression's outermost operator (higher binds weaker)
ATOM, UNARY, MUL, ADD, COMPARE, EQUALITY, AND, OR = range(8)


@dataclass
class TExpr:
    code: str
    type: str                 # string, int, float, bool, Vector3
    prec: int = ATOM
    literal: str | None = None   # the value when it is known while converting (for folding)
    numeric: "TExpr | None" = None  # a split local's number, read wherever a number is wanted (split.py)

    def wrapped(self, max_prec: int) -> str:
        return f"({self.code})" if self.prec > max_prec else self.code


@dataclass
class Stmt:
    comments: list[str] = field(default_factory=list, kw_only=True)
    trailing: str = field(default="", kw_only=True)
    blank: bool = field(default=False, kw_only=True)    # an empty line before it (from the source)


@dataclass
class Assign:
    """A Line that sets a variable to a whole new value."""
    target: str                # identifier as written
    type: str                  # the variable's type
    value: TExpr               # the value before conversion to `type`
    prefix: str = ""           # "float " when the line also declares the variable
    field: bool = False        # a field (the engine and other scripts can read it by name)


@dataclass
class Update:
    """A Line that sets a variable from its current value (`divide X 2`, `vectoradd V ...`)."""
    target: str
    type: str
    apply: Callable[[TExpr], TExpr]    # current value -> new value (before conversion to `type`)
    reads: str                         # code of the other operands


@dataclass
class Line(Stmt):
    code: str                  # without the semicolon
    declares: bool = False     # a variable declaration (never the only statement of a braceless body)
    assign: Assign | None = field(default=None, kw_only=True)
    update: Update | None = field(default=None, kw_only=True)


@dataclass
class Append(Stmt):
    """`target += value` on a string (consecutive appends are merged by the printer)."""
    target: str
    value: TExpr


@dataclass
class If(Stmt):
    cond: TExpr
    then: list[Stmt]
    else_: list[Stmt] | None = None
    compact: bool = False       # print as one line: if (cond) { a; b; }


@dataclass
class For(Stmt):
    header: str
    body: list[Stmt]


@dataclass
class Return(Stmt):
    value: str | None = None


@dataclass
class Comment(Stmt):
    text: str


@dataclass
class Blank(Stmt):
    pass


@dataclass
class Method:
    name: str
    params: list[tuple[str, str]]        # (type, name)
    returns: str                          # "void" or a type
    body: list[Stmt]
    comments: list[str] = field(default_factory=list)
    qualifiers: str = ""                  # e.g. "override"
    defaults: dict[str, str] = field(default_factory=dict)
    compact: bool = False                 # print on one line: void OnX() { A_OnX(); } // comment
