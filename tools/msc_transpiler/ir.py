"""Statement tree for generated methods, printed by emit.py.

Expressions are already AngelScript text by the time they get here (with their
type and precedence in TExpr); statements stay structured so the printer can
make else-if chains, merge nested ifs and pick early returns.
"""

from __future__ import annotations

from dataclasses import dataclass, field

# Precedence of an expression's outermost operator (higher binds weaker)
ATOM, UNARY, MUL, ADD, COMPARE, EQUALITY, AND, OR = range(8)


@dataclass
class TExpr:
    code: str
    type: str                 # string, int, float, bool, Vector3
    prec: int = ATOM
    literal: str | None = None   # the value when it is known while converting (for folding)

    def wrapped(self, max_prec: int) -> str:
        return f"({self.code})" if self.prec > max_prec else self.code


@dataclass
class Stmt:
    comments: list[str] = field(default_factory=list, kw_only=True)
    trailing: str = field(default="", kw_only=True)


@dataclass
class Line(Stmt):
    code: str                  # without the semicolon


@dataclass
class If(Stmt):
    cond: TExpr
    then: list[Stmt]
    else_: list[Stmt] | None = None


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
