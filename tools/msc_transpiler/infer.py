"""Type inference for .script variables, parameters and events.

Every .script value is text. To write readable AngelScript the transpiler picks a real type
per variable from how the corpus assigns and uses it:

  * numbers assigned, or the target of add/subtract/... -> int or float
  * only 0/1 assigned and only tested for truth          -> bool
  * $vec/$relpos/(x,y,z)/origins                          -> Vector3
  * anything else, or conflicting evidence               -> string

Script variables share one type per name across the whole corpus: included files are
mixins of every script that includes them, so a name must mean the same everywhere.
Locals are typed per event handler; event parameters per event name.
"""

from __future__ import annotations

import re
from collections import defaultdict
from dataclasses import dataclass, field

from . import mapping
from .expr import Call, Expr, Literal, Name, Not, Number, Vector, param_index, parse_token
from .syntax import Cmd, CmdList, ParsedFile, Token

STRING, INT, FLOAT, BOOL, VECTOR = "string", "int", "float", "bool", "Vector3"
NUMERIC = (INT, FLOAT, BOOL)

MATH_COMMANDS = {"add", "subtract", "subract", "multiply", "divide", "inc", "incvar", "dec", "decvar", "mod", "capvar"}
STRING_COMMANDS = {"stradd", "strconc", "token.add", "token.del", "token.set", "token.scramble"}
VECTOR_COMMANDS = {"vectoradd", "vectormultiply", "vectorscale", "vectorset"}
NUMERIC_OPS = {"==", "!=", "<", ">", "<=", ">="}


@dataclass
class Evidence:
    """What we learned about one name."""
    ints: int = 0
    floats: int = 0
    bools: int = 0            # assigned exactly 0 or 1
    strings: int = 0
    literal_strings: int = 0  # text that is not another variable (so arithmetic can't make it a number)
    vectors: int = 0
    math: int = 0             # target of arithmetic
    numeric_compare: int = 0  # compared with == < ... against a number
    copies: set[str] = field(default_factory=set)   # assigned from another variable

    def resolve(self, others: dict[str, str]) -> str:
        strings, vectors = self.strings, self.vectors
        ints, floats, bools = self.ints, self.floats, self.bools
        literal_strings = self.literal_strings
        for other in self.copies:
            t = others.get(other)
            if t is None:              # not a variable anywhere: the word itself
                strings += 1
                literal_strings += 1
            elif t == STRING:
                strings += 1
            elif t == VECTOR:
                vectors += 1
            elif t == FLOAT:
                floats += 1
            elif t == INT:
                ints += 1
            elif t == BOOL:
                bools += 1
        if self.math and not literal_strings and not vectors:
            return FLOAT if (floats or self.math) else INT
        if strings:
            return STRING
        if vectors:
            return VECTOR if not (ints or floats or self.math) else STRING
        if bools and not ints and not floats and not self.math and not self.numeric_compare:
            return BOOL
        if floats or self.math:
            return FLOAT
        if ints or bools:
            return INT
        return STRING


def literal_type(expr: Expr) -> str | None:
    if isinstance(expr, Number):
        if expr.text.endswith("%"):
            return STRING
        return INT if expr.is_int else FLOAT
    if isinstance(expr, Vector):
        return VECTOR
    if isinstance(expr, Literal):
        return STRING
    if isinstance(expr, Call):
        return call_type(expr)
    if isinstance(expr, Not):
        return BOOL
    return None


def call_type(call: Call) -> str:
    name = call.name.lower()
    spec = mapping.FUNCTIONS.get(name)
    if spec is not None:
        return STRING if spec.returns == "entity" else spec.returns
    if name in ("$get", "$get_by_idx") and len(call.args) >= 2 and isinstance(call.args[1], (Name, Literal)):
        prop = call.args[1].text.lower()
        if prop in mapping.GET_PROPERTIES:
            t = mapping.GET_PROPERTIES[prop][1]
            return STRING if t == "entity" else t
        if prop in mapping.GET_PROPERTIES_ARG:
            t = mapping.GET_PROPERTIES_ARG[prop][1]
            return STRING if t == "entity" else t
        if prop.startswith("origin.") or prop.startswith("angles.") or prop.startswith("velocity."):
            return FLOAT
    if name in ("$math", "$randf", "$float", "$min", "$max", "$ratio", "$get_skill_ratio"):
        return FLOAT
    return STRING


class Inference:
    """Collects evidence from parsed files and resolves types."""

    def __init__(self) -> None:
        self.fields: dict[str, Evidence] = defaultdict(Evidence)
        self.params: dict[tuple[str, int], Evidence] = defaultdict(Evidence)   # (event, n)
        self.param_names: dict[tuple[str, int], dict[str, int]] = defaultdict(lambda: defaultdict(int))
        self.param_doc_names: dict[tuple[str, int], dict[str, int]] = defaultdict(lambda: defaultdict(int))
        self.max_param: dict[str, int] = defaultdict(int)
        self.returns: set[str] = set()      # events whose handlers use `return`
        self.called_as_function: set[str] = set()
        self.globals: set[str] = set()      # setvarg names
        self.event_names: set[str] = set()
        self._field_types: dict[str, str] | None = None
        self._param_types: dict[tuple[str, int], str] | None = None

    # -- collection ------------------------------------------------------------

    def add_file(self, parsed: ParsedFile) -> None:
        for event in parsed.events:
            if event.name:
                self.event_names.add(event.name)
            for op in event.load_ops:
                if op.kind in ("const", "setvar"):
                    self._assign(self.fields[op.name], parse_token(op.value, op.quoted), [])
            local_names: set[str] = set()
            self._collect_locals(event.commands, local_names)
            self._walk(event.name or "", event.commands, local_names)
            if event.name and event.header_comment:
                for index, pname in header_param_names(event.header_comment).items():
                    self.param_doc_names[(event.name, index)][pname] += 1

    def _collect_locals(self, cmds: CmdList, names: set[str]) -> None:
        for cmd in cmds.cmds:
            if cmd.name.lower() == "local" and cmd.args:
                names.add(cmd.args[0].text)
            if cmd.if_list:
                self._collect_locals(cmd.if_list, names)
            for e in cmd.else_lists:
                self._collect_locals(e, names)

    def _walk(self, event: str, cmds: CmdList, locals_: set[str]) -> None:
        for cmd in cmds.cmds:
            self._command(event, cmd, locals_)
            if cmd.if_list:
                self._walk(event, cmd.if_list, locals_)
            for e in cmd.else_lists:
                self._walk(event, e, locals_)

    def _target(self, name: str, locals_: set[str]) -> Evidence | None:
        if name in locals_:
            return None   # locals are typed per handler in lower.py
        if param_index(name):
            return None
        return self.fields[name]

    def _command(self, event: str, cmd: Cmd, locals_: set[str]) -> None:
        name = cmd.name.lower()
        args = [parse_token(t.text, t.quoted) for t in cmd.args]

        for i, a in enumerate(args):
            for sub in _walk_expr(a):
                if isinstance(sub, Name):
                    index = param_index(sub.text)
                    if index:
                        self.max_param[event] = max(self.max_param[event], index)
                if isinstance(sub, Call) and sub.name.lower() == "$func" and sub.args and isinstance(sub.args[0], Name):
                    self.called_as_function.add(sub.args[0].text)

        if name in ("callevent", "calleventloop") and args:
            for a in args[:2]:
                if isinstance(a, Name) and not param_index(a.text):
                    self.event_names.add(a.text)
        if name in ("setvar", "setvard", "setvarg", "local") and args:
            target = cmd.args[0].text
            if name == "setvarg":
                self.globals.add(target)
            # `local L_X PARAMn` names the parameter
            if name == "local" and len(args) == 2 and isinstance(args[1], Name):
                index = param_index(args[1].text)
                if index:
                    self.param_names[(event, index)][target] += 1
            evidence = self._target(target, locals_ if name == "local" else set())
            if evidence is not None:
                self._assign(evidence, args[1] if len(args) == 2 else None, args[1:])
        elif name in MATH_COMMANDS and args:
            evidence = self._target(cmd.args[0].text, locals_)
            if evidence is not None:
                evidence.math += 1
                if len(args) > 1 and isinstance(args[1], Number) and not args[1].is_int:
                    evidence.floats += 1
        elif name in STRING_COMMANDS and args:
            evidence = self._target(cmd.args[0].text, locals_)
            if evidence is not None:
                evidence.strings += 1
        elif name in VECTOR_COMMANDS and args:
            evidence = self._target(cmd.args[0].text, locals_)
            if evidence is not None:
                evidence.vectors += 1
        elif name == "return":
            self.returns.add(event)
        elif name in ("if", "if()"):
            self._condition(event, args, locals_)

        # parameters used directly as typed command arguments
        spec = mapping.COMMANDS.get(name)
        if spec:
            for param, arg in zip(spec.params, args):
                if param.type in ("int", "float", "bool", "Vector3") and isinstance(arg, Name):
                    index = param_index(arg.text)
                    if index:
                        ev = self.params[(event, index)]
                        if param.type == "Vector3":
                            ev.vectors += 1
                        elif param.type == "float":
                            ev.floats += 1
                        elif param.type == "int":
                            ev.ints += 1

    def _condition(self, event: str, args: list[Expr], locals_: set[str]) -> None:
        if len(args) == 3 and isinstance(args[1], Name):
            op = args[1].text
            for side, other in ((args[0], args[2]), (args[2], args[0])):
                if not isinstance(side, Name):
                    continue
                index = param_index(side.text)
                evidence = self.params[(event, index)] if index else self._target(side.text, locals_)
                if evidence is None:
                    continue
                if op in NUMERIC_OPS and isinstance(other, Number):
                    evidence.numeric_compare += 1
                elif op in ("equals", "isnot", "!equals") and isinstance(other, Literal):
                    evidence.strings += 1

    def _assign(self, evidence: Evidence, value: Expr | None, parts: list[Expr]) -> None:
        if value is None:
            if len(parts) > 1:
                evidence.strings += 1    # several tokens concatenate into text
                evidence.literal_strings += 1
            return
        if isinstance(value, Number):
            if value.text.endswith("%"):
                evidence.strings += 1
                evidence.literal_strings += 1
            elif value.text in ("0", "1"):
                evidence.bools += 1
            elif value.is_int:
                evidence.ints += 1
            else:
                evidence.floats += 1
        elif isinstance(value, Name):
            if param_index(value.text) or value.text.startswith(("game.", "const.", "ent_")):
                evidence.strings += 1 if value.text.startswith("ent_") else 0
            else:
                evidence.copies.add(value.text)
        else:
            t = literal_type(value)
            if t == STRING:
                evidence.strings += 1
                if isinstance(value, Literal):
                    evidence.literal_strings += 1
            elif t == VECTOR:
                evidence.vectors += 1
            elif t == FLOAT:
                evidence.floats += 1
            elif t == INT:
                evidence.ints += 1
            elif t == BOOL:
                evidence.bools += 1

    # -- results -----------------------------------------------------------------

    def field_types(self) -> dict[str, str]:
        if self._field_types is None:
            types: dict[str, str] = {name: STRING for name in self.fields}
            for _ in range(6):   # propagate copies
                changed = False
                for name, evidence in self.fields.items():
                    t = evidence.resolve(types)
                    if types.get(name) != t:
                        types[name] = t
                        changed = True
                if not changed:
                    break
            self._field_types = types
        return self._field_types

    def field_type(self, name: str) -> str:
        return self.field_types().get(name, STRING)


_PARAM_DOC = re.compile(r"PARAM(\d+)\s*[=:-]\s*<?([A-Za-z_][\w]*)", re.I)
_ANGLE = re.compile(r"<([^<>]+)>")


def header_param_names(comment: str) -> dict[int, str]:
    """`//PARAM1 = PlayerId  PARAM2 = ItemID` or `//<owner> <rendermode> <renderamt>`."""
    found = {int(i): name for i, name in _PARAM_DOC.findall(comment)}
    if found:
        return found
    names_ = {}
    for i, inner in enumerate(_ANGLE.findall(comment), start=1):
        word = re.split(r"[^A-Za-z0-9_]", inner.strip())[0]
        if word and not word[0].isdigit():
            names_[i] = word
    return names_


def _walk_expr(expr: Expr):
    yield expr
    if isinstance(expr, Call):
        for a in expr.args:
            yield from _walk_expr(a)
    elif isinstance(expr, Vector):
        for p in expr.parts:
            yield from _walk_expr(p)
    elif isinstance(expr, Not):
        yield from _walk_expr(expr.operand)


def token_exprs(tokens: list[Token]) -> list[Expr]:
    return [parse_token(t.text, t.quoted) for t in tokens]
