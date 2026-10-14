"""Type inference for .script variables, parameters and events.

Every .script value is text. To write readable AngelScript the transpiler picks a real type
per variable from how the corpus assigns and uses it:

  * numbers assigned, or the target of add/subtract/... -> int or float
  * only 0/1 assigned and only tested for truth          -> bool
  * $vec/$relpos/(x,y,z)/origins                          -> Vector3
  * anything else, or conflicting evidence               -> string

  * only entities ($get(x,id), entity parameters)       -> CBaseEntity@, CBasePlayer@

Script variables share one type per name across the whole corpus: included files are
mixins of every script that includes them, so a name must mean the same everywhere.
Locals are typed per event handler; event parameters per event name.

An entity is text in .script (its id, "PentP(idx,addr)"). A variable is an entity handle only
when everything it holds is an entity the engine hands over or a $function returns, and it is
never compared with text: the handle then reads back as the same id wherever text is needed.
"""

from __future__ import annotations

import re
from collections import defaultdict
from dataclasses import dataclass, field, replace

from . import mapping
from .expr import Call, Expr, Literal, Name, Not, Number, Vector, param_index, parse_token
from .syntax import Cmd, CmdList, ParsedFile, Token

STRING, INT, FLOAT, BOOL, VECTOR = "string", "int", "float", "bool", "Vector3"
ENTITY, PLAYER = "CBaseEntity@", "CBasePlayer@"
NUMERIC = (INT, FLOAT, BOOL)
HANDLES = (ENTITY, PLAYER)


def handle_type(mapping_type: str) -> str | None:
    """mapping.py's entity / player -> the handle type."""
    return {"entity": ENTITY, "player": PLAYER}.get(mapping_type)

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
    vector_ops: int = 0       # target of vectoradd / vectorset / vectormultiply
    math: int = 0             # target of arithmetic
    numeric_compare: int = 0  # compared with == < ... against a number
    from_params: int = 0      # set from an event parameter (setvard X PARAM1)
    copies: set[str] = field(default_factory=set)   # assigned from another variable
    numeric_reads: int = 0    # read as a number (numeric tests, `if X`, math, numeric arguments)
    text_reads: int = 0       # read as text (text tests, printing, text arguments, copies)
    entities: int = 0         # assigned an entity: $get(x,id), an entity parameter, ...
    players: int = 0          # ... a player
    entity_uses: int = 0      # used where an entity goes ($get's first argument, entity parameters)
    text_compare: int = 0     # compared with text or a number (`equals 0`): an entity handle can't be
    opaque: int = 0           # passed a variable whose type is decided later (keeps a parameter text)
    param_sources: list = field(default_factory=list)   # (event, n): setvard X PARAMn
    arg_fields: set[str] = field(default_factory=set)    # a parameter callers pass these fields as

    def resolve(self, others: dict[str, str]) -> str:
        strings, vectors = self.strings, self.vectors
        ints, floats, bools = self.ints, self.floats, self.bools
        literal_strings = self.literal_strings
        entities, players = self.entities, self.players
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
            elif t in HANDLES:
                entities += 1
                players += t == PLAYER
        if entities and not (strings or vectors or ints or floats or bools or self.math or self.vector_ops
                             or self.numeric_compare or self.text_compare or self.from_params or self.opaque):
            return PLAYER if players == entities else ENTITY
        # an entity id is text: never a number, whatever else is assigned
        strings += entities + self.entity_uses
        literal_strings += entities + self.entity_uses
        if self.math and not literal_strings and not vectors:
            return FLOAT if (floats or self.math) else INT
        # changed with vector commands and never plain text: a vector, even when some values come
        # from text (Vec() reads them as the engine's StringToVec does)
        if self.vector_ops and not literal_strings and not self.math and not self.numeric_compare:
            return VECTOR
        # only ever read as a number and never given literal text: a number, whatever text
        # expressions it is assigned (they are converted where they are assigned)
        if strings and not literal_strings and self.numeric_reads and not self.text_reads and not vectors:
            return FLOAT if (floats or self.math or not (ints or bools)) else INT
        if strings:
            return STRING
        # holds what callers pass (entity ids, names) and is never used as a number: text, even
        # when it is also reset with 0
        if self.from_params and not (self.math or self.numeric_compare or floats or vectors):
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
        return handle_type(spec.returns) or spec.returns
    if name in ("$get", "$get_by_idx") and len(call.args) >= 2 and isinstance(call.args[1], (Name, Literal)):
        prop = call.args[1].text.lower()
        if prop in mapping.GET_PROPERTIES:
            t = mapping.GET_PROPERTIES[prop][1]
            return handle_type(t) or t
        if prop in mapping.GET_PROPERTIES_ARG:
            t = mapping.GET_PROPERTIES_ARG[prop][1]
            return handle_type(t) or t
        base, _, component = prop.partition(".")
        if component in mapping.COMPONENTS and base in mapping.GET_VECTOR_COMPONENTS:
            return FLOAT
        if any(prop.startswith(p) for p in mapping.GET_PREFIXED):
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
        # `local L PARAMn`: the local's evidence (gathered over its handler) speaks for the parameter
        self._param_locals: dict[tuple[str, int], list[Evidence]] = defaultdict(list)
        self._locals: dict[str, Evidence] = {}      # the current handler's locals
        # a parameter passed on as another event's parameter (callevent other PARAM2): same value
        self._param_links: dict[tuple[str, int], set[tuple[str, int]]] = defaultdict(set)
        # calleventloop: the events run in loops, and the events that `breakloop` (or call one that does)
        self.loop_events: set[str] = set()
        self._breaks: set[str] = set()
        self._calls: dict[str, set[str]] = defaultdict(set)
        self._breaking: set[str] | None = None
        # menu items: the events run when one is chosen (PARAM1 the player, PARAM2 the item's data)
        self.menu_callbacks: set[str] = set()
        self._menu_item: dict[str, Expr | str] = {}

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
            self._locals = defaultdict(Evidence)
            self._menu_item = {}
            self._walk(event.name or "", event.commands, local_names)
            if event.name and event.header_comment:
                for index, pname in header_param_names(event.header_comment).items():
                    self.param_doc_names[(event.name, index)][pname] += 1

    def _collect_locals(self, cmds: CmdList, names: set[str]) -> None:
        for cmd in cmds.cmds:
            if cmd.name.lower() == "local" and cmd.args and not param_index(cmd.args[0].text):
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
            # locals are typed per handler in lower.py; this copy only informs parameter types
            return self._locals[name]
        if param_index(name):
            return None
        return self.fields[name]

    def _command(self, event: str, cmd: Cmd, locals_: set[str]) -> None:
        name = cmd.name.lower()
        args = [parse_token(t.text, t.quoted) for t in cmd.args]

        def field_read(text: str, numeric: bool) -> None:
            if text in locals_ or param_index(text) or not text[:1].isalpha() \
                    or text.lower().startswith(("game.", "const.", "ent_")):
                return
            ev = self.fields[text]
            if numeric:
                ev.numeric_reads += 1
            else:
                ev.text_reads += 1
        command_reads(cmd, args, field_read)

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
                    self._calls[event].add(a.text)
            if name == "calleventloop" and len(args) > 1 and isinstance(args[1], Name):
                self.loop_events.add(args[1].text)
        if name == "breakloop":
            self._breaks.add(event)
        if name == "local" and len(args) == 2 and cmd.args[0].text.lower().startswith("reg.mitem."):
            self._menu_item[cmd.args[0].text.lower()[len("reg.mitem."):]] = args[1]
        if name == "menuitem.register":
            self._register_menu_item(event, locals_)
        if name in ("setvar", "setvard", "setvarg", "local") and args:
            target = cmd.args[0].text
            if name == "setvarg":
                self.globals.add(target)
            # `local L_X PARAMn` names the parameter; `local`/`setvard X PARAMn` also types it
            if len(args) == 2 and isinstance(args[1], Name) and param_index(args[1].text):
                index = param_index(args[1].text)
                if name == "local":
                    self.param_names[(event, index)][target] += 1
                    if target in locals_:
                        self._param_locals[(event, index)].append(self._locals[target])
                elif name in ("setvar", "setvard") and not param_index(target):
                    self.params[(event, index)].copies.add(target)
                    self.fields[target].param_sources.append((event, index))
            evidence = self._target(target, locals_ if name == "local" else set())
            if evidence is not None:
                self._assign(evidence, args[1] if len(args) == 2 else None, args[1:], locals_)
        elif name in MATH_COMMANDS and args:
            evidence = self._target(cmd.args[0].text, locals_)
            if evidence is not None:
                evidence.math += 1
                if len(args) > 1 and isinstance(args[1], Number) and not args[1].is_int:
                    evidence.floats += 1
            for amount in args[1:]:          # an amount that is a parameter: a number
                if isinstance(amount, Name) and param_index(amount.text):
                    self.params[(event, param_index(amount.text))].floats += 1
        elif name in STRING_COMMANDS and args:
            evidence = self._target(cmd.args[0].text, locals_)
            if evidence is not None:
                evidence.strings += 1
        elif name in VECTOR_COMMANDS and args:
            evidence = self._target(cmd.args[0].text, locals_)
            if evidence is not None:
                evidence.vectors += 1
                evidence.vector_ops += 1
        elif name == "return":
            self.returns.add(event)

        # literal values passed to an event: callevent <event> a b / callexternal <target> <event> a b
        if name in ("callevent", "callexternal") and args:
            start = 1 if name == "callexternal" else 0
            if name == "callevent" and isinstance(args[0], Number):
                start = None                 # delayed: the engine drops the parameters
            if start is not None and len(args) > start and isinstance(args[start], Name):
                called = args[start].text
                for i, value in enumerate(args[start + 1:], start=1):
                    if isinstance(value, Call) and value.name.lower() == "$pass" and value.args:
                        value = value.args[0]
                    if isinstance(value, (Number, Literal, Call)):
                        self._assign(self.params[(called, i)], value, [])
                    elif isinstance(value, Name) and not param_index(value.text):
                        if value.text.lower().startswith(("ent_", "game.")):
                            self._assign(self.params[(called, i)], value, [])
                        elif value.text in locals_:
                            self.params[(called, i)].opaque += 1
                        else:
                            self.params[(called, i)].arg_fields.add(value.text)
                    elif isinstance(value, Name) and param_index(value.text):
                        mine = (event, param_index(value.text))
                        self._param_links[mine].add((called, i))
                        self._param_links[(called, i)].add(mine)
        elif name in ("if", "if()"):
            self._condition(event, args, locals_)

        # parameters used directly as typed command arguments
        spec = mapping.COMMANDS.get(name)
        if spec:
            for param, arg in zip(spec.params, args):
                self._typed_use(event, param.type, arg)
        # ... and as typed $function arguments ($get's first argument is an entity)
        for a in args:
            for sub in _walk_expr(a):
                if isinstance(sub, Call) and sub.name.lower() in ("$get", "$get_by_name") and sub.args:
                    self._typed_use(event, "entity", sub.args[0])
                if isinstance(sub, Call):
                    fspec = mapping.FUNCTIONS.get(f"{sub.name}/{len(sub.args)}") or mapping.FUNCTIONS.get(sub.name)
                    if fspec and len(fspec.params) == len(sub.args):
                        for ptype, arg in zip(fspec.params, sub.args):
                            self._typed_use(event, ptype, arg)

    def _typed_use(self, event: str, type_: str, arg: Expr) -> None:
        if isinstance(arg, Call) and arg.name.lower() == "$pass" and arg.args:
            arg = arg.args[0]
        if type_ not in ("int", "float", "bool", "Vector3", "entity") or not isinstance(arg, Name):
            return
        index = param_index(arg.text)
        if not index:
            return
        ev = self.params[(event, index)]
        if type_ == "entity":
            # an entity id is text ("PentP(...)"): never a number, whatever callers pass
            ev.entity_uses += 1
            return
        if type_ == "Vector3":
            ev.vectors += 1
        elif type_ == "float":
            ev.floats += 1
        else:
            ev.ints += 1

    def _condition(self, event: str, args: list[Expr], locals_: set[str]) -> None:
        # `!startswith` / `!equals` parse as a negated name
        op_expr = args[1] if len(args) == 3 else None
        if isinstance(op_expr, Not) and isinstance(op_expr.operand, Name):
            op_expr = Name("!" + op_expr.operand.text)
        if len(args) == 3 and isinstance(op_expr, Name):
            op = op_expr.text
            for side, other in ((args[0], args[2]), (args[2], args[0])):
                if not isinstance(side, Name):
                    continue
                index = param_index(side.text)
                evidence = self.params[(event, index)] if index else self._target(side.text, locals_)
                if evidence is None:
                    continue
                if op in NUMERIC_OPS and isinstance(other, Number):
                    evidence.numeric_compare += 1
                elif _is_missing_marker(other, op) and side is args[0]:
                    # `X equals 'PARAM4'` / `X startswith PARAM`: tested for an omitted parameter, which
                    # converts to X.isEmpty(), so X stays text even when it also holds numbers
                    evidence.strings += 1
                    evidence.literal_strings += 1
                elif op in ("equals", "isnot", "!equals") and isinstance(other, Literal):
                    evidence.strings += 1
                    evidence.text_compare += 1
                if op in ("equals", "isnot", "!equals", "startswith", "!startswith", "contains", "!contains") \
                        and (isinstance(other, (Number, Literal)) or isinstance(other, Name)
                             and other.text.lower().startswith("ent_")):
                    evidence.text_compare += 1

    def _assign(self, evidence: Evidence, value: Expr | None, parts: list[Expr], locals_: set[str] = frozenset()) -> None:
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
            builtin = INT if value.text.lower() == "game.script.iteration" else mapping.BUILTINS.get(value.text, ("", ""))[1]
            if builtin == INT:
                evidence.ints += 1
            elif builtin == FLOAT:
                evidence.floats += 1
            elif builtin == VECTOR:
                evidence.vectors += 1
            elif builtin == BOOL:
                evidence.bools += 1
            elif param_index(value.text) or value.text.startswith(("game.", "const.", "ent_")):
                evidence.strings += 1 if value.text.startswith("ent_") else 0
            elif value.text in locals_:
                pass            # a local of the handler: its type is decided per handler, not here
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
            elif t in HANDLES:
                evidence.entities += 1
                evidence.players += t == PLAYER

    def _register_menu_item(self, event: str, locals_: set[str]) -> None:
        """menuitem.register: the callbacks of the item get the player and the item's data."""
        data = self._menu_item.get("data")
        for key in ("callback", "cb_failed"):
            callback = self._menu_item.get(key)
            if not isinstance(callback, Name) or param_index(callback.text):
                continue
            self.menu_callbacks.add(callback.text)
            self.event_names.add(callback.text)
            target = self.params[(callback.text, 2)]
            if isinstance(data, Name) and data.text in locals_:
                self._param_locals[(callback.text, 2)].append(self._locals[data.text])
            elif isinstance(data, Name) and param_index(data.text):
                mine = (event, param_index(data.text))
                self._param_links[mine].add((callback.text, 2))
                self._param_links[(callback.text, 2)].add(mine)
            elif isinstance(data, Name) and not data.text.lower().startswith(("game.", "const.", "ent_")):
                target.copies.add(data.text)
            elif data is not None:
                self._assign(target, data, [])

    # -- results -----------------------------------------------------------------

    def known_param_type(self, event: str, index: int) -> str | None:
        """An entity parameter the engine guarantees: an engine event's entity, the player of a menu
        item's callback."""
        spec = mapping.ENGINE_EVENTS.get(event)
        if spec and index <= len(spec.params):
            return handle_type(spec.params[index - 1].type)
        if event in self.menu_callbacks and index == 1:
            return PLAYER
        return None

    def _with_sources(self, evidence: Evidence) -> Evidence:
        """setvard X PARAMn: an entity parameter assigns an entity, any other one caller-given text."""
        if not evidence.param_sources:
            return evidence
        out = replace(evidence, copies=set(evidence.copies), param_sources=[])
        for event, index in evidence.param_sources:
            t = self.known_param_type(event, index)
            if t in HANDLES:
                out.entities += 1
                out.players += t == PLAYER
            else:
                out.from_params += 1
        return out

    def breaks_loop(self, event: str) -> bool:
        """Whether running the event can `breakloop` (itself or through an event it calls)."""
        if self._breaking is None:
            breaking = set(self._breaks)
            changed = True
            while changed:
                changed = False
                for caller, called in self._calls.items():
                    if caller not in breaking and called & breaking:
                        breaking.add(caller)
                        changed = True
            self._breaking = breaking
        return event in self._breaking

    def field_types(self) -> dict[str, str]:
        if self._field_types is None:
            types: dict[str, str] = {name: STRING for name in self.fields}
            fields = {name: self._with_sources(evidence) for name, evidence in self.fields.items()}
            for _ in range(6):   # propagate copies
                changed = False
                for name, evidence in fields.items():
                    t = evidence.resolve(types)
                    if types.get(name) != t:
                        types[name] = t
                        changed = True
                if not changed:
                    break
            self._field_types = types
            # a field only ever set from event parameters holds what they hold: give it their type,
            # then type the parameters again with it
            fed = {name: self._fed_type(evidence) for name, evidence in self.fields.items() if self._param_fed(evidence)}
            for name, t in fed.items():
                if t is not None:
                    types[name] = t
            if self._param_types:
                self._param_types.clear()       # typed before the fields were final
        return self._field_types

    @staticmethod
    def _param_fed(evidence: Evidence) -> bool:
        return bool(evidence.param_sources) and not any((
            evidence.ints, evidence.floats, evidence.bools, evidence.strings, evidence.vectors, evidence.entities,
            evidence.copies, evidence.math, evidence.vector_ops, evidence.text_compare))

    def _fed_type(self, evidence: Evidence) -> str | None:
        found = {self.param_type(event, index) for event, index in evidence.param_sources}
        if len(found) == 1:
            return found.pop()
        if found <= {INT, FLOAT}:
            return FLOAT
        if found <= set(HANDLES):
            return ENTITY
        return None

    def field_type(self, name: str) -> str:
        return self.field_types().get(name, STRING)

    def param_type(self, event: str, index: int) -> str:
        """A parameter's type from how handlers use it and what callers pass. One with no evidence of
        its own takes the type of the parameters it is passed on as (or receives its value from)."""
        if self._param_types is None:
            self._param_types = {}
        key = (event, index)
        if key in self._param_types:
            return self._param_types[key]
        t = self._own_param_type(key)
        if t is None:
            # the types of the parameters it is passed on as or receives from: a handle only when
            # every one of them is a handle, otherwise the first other type found
            seen, queue, found = {key}, list(self._param_links.get(key, ())), []
            while queue:
                other = queue.pop(0)
                if other in seen:
                    continue
                seen.add(other)
                own = self._own_param_type(other)
                if own is None:
                    queue.extend(self._param_links.get(other, ()))
                else:
                    found.append(own)
            others = [f for f in found if f not in HANDLES]
            if others:
                t = others[0]
            elif found:
                t = PLAYER if all(f == PLAYER for f in found) else ENTITY
        self._param_types[key] = t or STRING
        return self._param_types[key]

    def _own_param_type(self, key: tuple[str, int]) -> str | None:
        """The type its own evidence gives, or None when there is none."""
        known = self.known_param_type(*key)
        if known is not None:
            return known
        evidence = self.params.get(key, Evidence())
        fed = {c for c in evidence.copies if c in self.fields and self._param_fed(self.fields[c])}
        combined = replace(evidence, copies=set(evidence.copies) - fed | set(evidence.arg_fields),
                           param_sources=list(evidence.param_sources), numeric_reads=0, text_reads=0)
        field_types = self.field_types()
        for local in self._param_locals.get(key, []):
            t = local.resolve(field_types)
            if local.literal_strings:        # e.g. tested for an omitted parameter: stays text
                combined.strings += 1
                combined.literal_strings += 1
            elif local.math or t in (INT, FLOAT):
                combined.floats += 1 if t != INT else 0
                combined.ints += 1 if t == INT else 0
            elif t == VECTOR:
                combined.vectors += 1
            elif t in HANDLES:
                combined.entities += 1
                combined.players += t == PLAYER
            elif local.strings or local.literal_strings:
                combined.strings += 1
        if not any((combined.ints, combined.floats, combined.bools, combined.strings, combined.literal_strings,
                    combined.vectors, combined.math, combined.numeric_compare, combined.copies, combined.entities,
                    combined.opaque, combined.text_compare, combined.arg_fields)):
            return None
        t = combined.resolve(field_types)
        if t == STRING and combined.numeric_compare and not combined.strings and not combined.literal_strings:
            return FLOAT                     # only ever compared as a number
        return t


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


def command_reads(cmd: Cmd, args: list[Expr], read) -> None:
    """Call read(name, numeric) for every variable the command reads: numeric for numeric tests,
    `if X`, math and numeric arguments; text for everything else."""
    name = cmd.name.lower()
    if cmd.conditional and len(args) == 3:
        op = args[1].text if isinstance(args[1], Name) else ""
        for side in (args[0], args[2]):
            _expr_reads(side, op in NUMERIC_OPS, read)
    elif cmd.conditional and len(args) == 1:
        _expr_reads(args[0], True, read)
    elif name in MATH_COMMANDS or name == "repeatdelay":
        for a in args:
            _expr_reads(a, True, read)      # the target's current value and the amount; a delay
    elif name == "calleventloop" and args:
        _expr_reads(args[0], True, read)    # the number of runs
        for a in args[1:]:
            _expr_reads(a, False, read)
    elif name in ("local", "setvar", "setvard", "setvarg"):
        for a in args[1:]:
            _expr_reads(a, False, read)
    elif name in STRING_COMMANDS or name in VECTOR_COMMANDS:
        for a in args:
            _expr_reads(a, False, read)     # they read the text
    else:
        spec = mapping.COMMANDS.get(name)
        types = [p.type for p in spec.params] if spec else []
        for i, a in enumerate(args):
            _expr_reads(a, i < len(types) and types[i] in ("int", "float", "bool"), read)


def _expr_reads(expr: Expr, numeric: bool, read) -> None:
    if isinstance(expr, Not):
        _expr_reads(expr.operand, numeric, read)
    elif isinstance(expr, Name):
        read(expr.text, numeric)
    elif isinstance(expr, Call):
        spec = mapping.FUNCTIONS.get(f"{expr.name.lower()}/{len(expr.args)}") or mapping.FUNCTIONS.get(expr.name.lower())
        types = spec.params if spec and len(spec.params) == len(expr.args) else []
        for i, a in enumerate(expr.args):
            _expr_reads(a, i < len(types) and types[i] in ("int", "float", "bool"), read)
    elif isinstance(expr, Vector):
        for p in expr.parts:
            _expr_reads(p, True, read)


def _is_missing_marker(expr: Expr, op: str) -> bool:
    """'PARAM4' (or the prefix PARAM) on the right of a text test: .script's omitted-parameter check."""
    if op not in ("equals", "isnot", "!equals", "startswith", "!startswith", "contains", "!contains"):
        return False
    if isinstance(expr, Literal):
        return bool(re.fullmatch(r"PARAM\d*", expr.text))
    return isinstance(expr, Name) and expr.text == "PARAM"


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
