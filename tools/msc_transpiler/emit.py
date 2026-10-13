"""Printing statement trees as AngelScript, with the readability rewrites that are safe
on any tree: else-if chains, merging an if that only wraps another if, and braceless
single-statement bodies.
"""

from __future__ import annotations

from .ir import AND, Append, Blank, Comment, For, If, Line, Method, Return, Stmt, TExpr

INDENT = "\t"


def _merge_appends(stmts: list[Stmt]) -> list[Stmt]:
    from .values import join
    out: list[Stmt] = []
    for stmt in stmts:
        prev = out[-1] if out else None
        if isinstance(stmt, Append) and isinstance(prev, Append) and prev.target == stmt.target                 and not stmt.comments and not prev.trailing:
            first = prev.value if prev.value.type == "string" else join([prev.value])
            out[-1] = Append(prev.target, join([first, stmt.value]), comments=prev.comments, trailing=stmt.trailing)
        else:
            out.append(stmt)
    return out


def simplify(stmts: list[Stmt]) -> list[Stmt]:
    out: list[Stmt] = []
    for stmt in _merge_appends(stmts):
        if isinstance(stmt, If):
            stmt.then = simplify(stmt.then)
            if stmt.else_ is not None:
                stmt.else_ = simplify(stmt.else_) or None
            # if (a) { if (b) { X } }  ->  if (a && b) { X }
            while (stmt.else_ is None and len(stmt.then) == 1 and isinstance(stmt.then[0], If)
                   and stmt.then[0].else_ is None and not stmt.then[0].comments and not stmt.then[0].trailing):
                inner = stmt.then[0]
                stmt.cond = TExpr(f"{stmt.cond.wrapped(AND)} && {inner.cond.wrapped(AND)}", "bool", AND)
                stmt.then = inner.then
            if not stmt.then and stmt.else_ is None:
                out.append(Line(f"if ({stmt.cond.code}) {{}}", comments=stmt.comments, trailing=stmt.trailing))
                continue
        elif isinstance(stmt, For):
            stmt.body = simplify(stmt.body)
        out.append(stmt)
        if isinstance(stmt, Return):
            break       # anything after it never runs
    return out


def _is_simple(stmts: list[Stmt]) -> bool:
    return (len(stmts) == 1 and isinstance(stmts[0], (Line, Return, Append))
            and not stmts[0].comments and not stmts[0].trailing
            and not (isinstance(stmts[0], Line) and stmts[0].declares))


def _comment_lines(comments: list[str], indent: str) -> list[str]:
    return [f"{indent}// {c}" if c else f"{indent}//" for c in comments]


def _trail(stmt: Stmt) -> str:
    return f" // {stmt.trailing}" if stmt.trailing else ""


def emit_block(stmts: list[Stmt], depth: int) -> list[str]:
    lines: list[str] = []
    indent = INDENT * depth
    for stmt in stmts:
        lines.extend(_comment_lines(stmt.comments, indent))
        if isinstance(stmt, Append):
            # string += accepts numbers directly; bools and vectors need .script's text form
            value = stmt.value.code if stmt.value.type in ("string", "int", "float") else f"Text({stmt.value.code})"
            lines.append(f"{indent}{stmt.target} += {value};{_trail(stmt)}")
        elif isinstance(stmt, Line):
            lines.append(f"{indent}{stmt.code};{_trail(stmt)}" if not stmt.code.endswith("}") else f"{indent}{stmt.code}{_trail(stmt)}")
        elif isinstance(stmt, Return):
            lines.append(f"{indent}return{' ' + stmt.value if stmt.value else ''};{_trail(stmt)}")
        elif isinstance(stmt, Comment):
            lines.append(f"{indent}// {stmt.text}")
        elif isinstance(stmt, Blank):
            lines.append("")
        elif isinstance(stmt, For):
            lines.append(f"{indent}for ({stmt.header}){_trail(stmt)}")
            lines.extend(_braced(stmt.body, depth))
        elif isinstance(stmt, If):
            lines.extend(_emit_if(stmt, depth, prefix=""))
    return lines


def _braced(body: list[Stmt], depth: int) -> list[str]:
    indent = INDENT * depth
    return [f"{indent}{{", *emit_block(body, depth + 1), f"{indent}}}"]


def _body(body: list[Stmt], depth: int, allow_braceless: bool) -> list[str]:
    if allow_braceless and _is_simple(body):
        return emit_block(body, depth + 1)
    return _braced(body, depth)


def _emit_if(stmt: If, depth: int, prefix: str) -> list[str]:
    indent = INDENT * depth
    if stmt.compact and stmt.else_ is None and all(isinstance(s, (Line, Return)) for s in stmt.then):
        body = " ".join(emit_block([s], 0)[0] for s in stmt.then)
        return [f"{indent}{prefix}if ({stmt.cond.code}) {{ {body} }}{_trail(stmt)}"]
    # braceless only when every branch of the chain is a single simple statement
    chain_simple = _chain_is_simple(stmt)
    lines = [f"{indent}{prefix}if ({stmt.cond.code}){_trail(stmt)}"]
    lines.extend(_body(stmt.then, depth, chain_simple))
    else_ = stmt.else_
    if else_:
        if len(else_) == 1 and isinstance(else_[0], If) and not else_[0].comments:
            lines.extend(_emit_if(else_[0], depth, prefix="else "))
        else:
            lines.append(f"{indent}else")
            lines.extend(_body(else_, depth, chain_simple))
    return lines


def _chain_is_simple(stmt: If) -> bool:
    if not _is_simple(stmt.then):
        return False
    else_ = stmt.else_
    if not else_:
        return True
    if len(else_) == 1 and isinstance(else_[0], If) and not else_[0].comments:
        return _chain_is_simple(else_[0])
    return _is_simple(else_)


def emit_method(method: Method, depth: int = 1) -> list[str]:
    indent = INDENT * depth
    params = ", ".join(
        f"{_param_decl(t)} {n}" + (f" = {method.defaults[n]}" if n in method.defaults else "")
        for t, n in method.params)
    qualifiers = f" {method.qualifiers}" if method.qualifiers else ""
    signature = f"{method.returns} {method.name}({params}){qualifiers}"
    body = simplify(method.body)
    if method.compact and len(body) <= 1 and all(isinstance(s, (Line, Return)) and not s.comments for s in body):
        inner = f" {emit_block(body, 0)[0]} " if body else ""
        trail = f" // {method.comments[0]}" if method.comments else ""
        return [f"{indent}{signature} {{{inner}}}{trail}"]
    lines = _comment_lines(method.comments, indent)
    lines.append(f"{indent}{signature}")
    lines.append(f"{indent}{{")
    while method.returns == "void" and body and isinstance(body[-1], Return) and body[-1].value is None             and not body[-1].comments and not body[-1].trailing:
        body = body[:-1]
    lines.extend(emit_block(body, depth + 1))
    lines.append(f"{indent}}}")
    return lines


def _param_decl(type_: str) -> str:
    return "const string &in" if type_ == "string" else ("const Vector3 &in" if type_ == "Vector3" else type_)


def emit_methods(lines: list[str], methods: list[Method]) -> None:
    """One-line methods stay together; others are set apart by a blank line."""
    previous_compact = True
    for method in methods:
        out = emit_method(method)
        if len(out) > 1 or not previous_compact:
            lines.append("")
        lines.extend(out)
        previous_compact = len(out) == 1
