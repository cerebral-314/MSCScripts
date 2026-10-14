"""Typed values: AngelScript expressions for .script text, numbers and conditions, with the
conversions the interpreter does implicitly (every .script value is text)."""

from __future__ import annotations

import re

from .infer import BOOL, FLOAT, INT, STRING, VECTOR
from .ir import ADD, ATOM, COMPARE, EQUALITY, MUL, UNARY, TExpr

NUMERIC_TYPES = (INT, FLOAT)
TRUE = TExpr("true", BOOL, literal="1")
FALSE = TExpr("false", BOOL, literal="0")


# ----------------------------------------------------------------------------------------
# Values
# ----------------------------------------------------------------------------------------

def string_literal(text: str) -> str:
    r"""A string constant with the same bytes as the .script text (Latin-1): characters outside
    printable ASCII are written as \xHH, which AngelScript stores as that exact byte."""
    out = []
    for ch in text.replace("\\", "\\\\").replace('"', '\\"'):
        code = ord(ch)
        out.append(ch if 0x20 <= code < 0x7F else f"\\x{code & 0xFF:02X}")
    return '"' + "".join(out) + '"'


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


def format_number(value: float, type_: str) -> TExpr:
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
    if e.numeric is not None and want in (INT, FLOAT, BOOL):
        return convert(e.numeric, want)
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
        if t == VECTOR:
            return TExpr(f"Int(Text({e.code}))", INT)    # "(x,y,z)" reads as 0
        return TExpr(f"Int({e.code})", INT)
    if want == FLOAT:
        if t == INT:
            return TExpr(e.code, FLOAT, e.prec, e.literal)
        if t == BOOL:
            return TExpr(f"({e.code} ? 1.0f : 0.0f)", FLOAT)
        if t == VECTOR:
            return TExpr(f"Float(Text({e.code}))", FLOAT)  # "(x,y,z)" reads as 0
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
        return format_number(c_atoi(text), INT)
    if want == FLOAT:
        return format_number(c_atof(text), FLOAT)
    if want == BOOL:
        return TRUE if c_atoi(text) != 0 else FALSE
    return None


def truthy(e: TExpr) -> TExpr:
    """`if X` is atoi(X) != 0."""
    if e.numeric is not None:
        return truthy(e.numeric)
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


def missing_param(t: str, index: int) -> str:
    """The default of a parameter the caller did not pass. (In .script it reads as its own name,
    "PARAM4"; scripts test that with `equals 'PARAM4'`, which converts to an emptiness test.)"""
    return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, '""')


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
