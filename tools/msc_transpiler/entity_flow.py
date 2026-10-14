"""Which variables hold entities. Mixed into Inference (infer.py).

An entity is text in .script: its id, "PentP(idx,addr)". Converted code holds it as a handle
(CBaseEntity@, CBasePlayer@) where that changes nothing:

  * Every value that flows into the variable is an entity: one the engine passes (an engine event's
    entity parameter, the player of a menu callback), one a $function returns ($get(x,id),
    $get(x,owner), ...), "0" or "" (no entity), or another variable that holds entities.
  * It is never used as anything else: no arithmetic, no numeric tests, no comparison with text
    (other than "0"/"" for a parameter; a field may outlive its entity, so not even that).

Variables are fields, event parameters (per event name, across the corpus) and handler locals (per
event name). Values flow into them through setvard / local, and into parameters through callevent,
calleventloop and callexternal. The solution is the largest set of variables that satisfies both
rules and is reached by at least one real entity: a parameter nobody is seen passing anything to
stays text.

Lists of entities count too: $get_tsphere / $get_tbox / $sort_entlist and getplayers give a
`;`-list of ids, and so does a variable that only ever holds such lists (or has entities added to
it with token.add). An entry of one ($get_token(list, n)) is an entity.
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass, field

from . import mapping
from .expr import Call, Expr, Literal, Name, Number, param_index

ENTITY, PLAYER = "CBaseEntity@", "CBasePlayer@"
NULL_TEXT = ("0", "")
# $functions that return a ;-list of entity ids ("none" when there are none)
ENTITY_LISTS = {"$get_tsphere", "$get_tbox", "$sort_entlist"}
LIST_ENTRIES = {"$get_token", "$get_random_token"}

Node = tuple       # ("field", name) | ("param", event, n) | ("local", event, name)


@dataclass
class Flow:
    seeds: set[str] = field(default_factory=set)       # ENTITY / PLAYER values flowing in
    sources: set[Node] = field(default_factory=set)    # variables flowing in
    conflicts: int = 0                                 # anything else flowing in
    use_conflicts: int = 0                             # used as a number, a vector or compared with text
    null_compares: int = 0                             # compared with "0" / ""
    list_entries: set[Node] = field(default_factory=set)   # $get_token(<list variable>, n)
    entries: set[Node] = field(default_factory=set)        # (a list) token.add <list> <variable>



class EntityFlow:
    def _init_flow(self) -> None:
        self.flows: dict[Node, Flow] = defaultdict(Flow)
        self.list_flows: dict[Node, Flow] = defaultdict(Flow)     # variables holding ;-lists of entities
        self._entity_lists: dict[Node, str] | None = None
        self._entity_types: dict[Node, str] | None = None
        # events the engine fires under names scripts choose, with an engine event's parameters
        self._dmgevents: set[str] = set()
        self._attack_callbacks: set[str] = set()
        self._literal_values: dict[str, set[str]] = defaultdict(set)   # const X <word>, by name
        self._aliases: dict[str, str] | None = None

    # -- collection (called from Inference._command) ---------------------------------------

    def flow_node(self, event: str, text: str, locals_: set[str]) -> Node | None:
        """The variable a bare token names, or None for anything else (a word, game.*, ent_*)."""
        index = param_index(text)
        if index:
            return ("param", event, index)
        if text in locals_:
            return ("local", event, text)
        if not text[:1].isalpha() or text.lower().startswith(("game.", "const.", "ent_", "reg.")):
            return None
        return ("field", text)

    def flow_value(self, target: Node, value: Expr | None, event: str, locals_: set[str],
                   tokens: int = 1, entity_type=None) -> None:
        """`target` is given `value` (several tokens are joined text)."""
        flow = self.flows[target]
        if value is None or tokens > 1:
            flow.conflicts += 1
        elif isinstance(value, Number):
            if value.text in NULL_TEXT:
                return
            flow.conflicts += 1
        elif isinstance(value, Literal):
            if value.text in NULL_TEXT or (value.text.startswith("PARAM") and value.text[5:].isdigit()):
                return       # no entity (an omitted parameter reads as empty in converted code)
            flow.conflicts += 1
        elif isinstance(value, Name):
            source = self.flow_node(event, value.text, locals_)
            if source is None:
                flow.conflicts += 1        # a word, or an ent_* name the receiver resolves itself
            else:
                flow.sources.add(source)
        elif isinstance(value, Call) and entity_type is not None and entity_type(value) is not None:
            flow.seeds.add(entity_type(value))
        elif isinstance(value, Call) and value.name.lower() in LIST_ENTRIES and value.args \
                and isinstance(value.args[0], Name) and self.flow_node(event, value.args[0].text, locals_):
            flow.list_entries.add(self.flow_node(event, value.args[0].text, locals_))
        else:
            flow.conflicts += 1

    def flow_list_value(self, target: Node, value: Expr | None, event: str, locals_: set[str], tokens: int = 1,
                        added: bool = False) -> None:
        """`target` is given `value` as a whole (setvard L ...), or `value` is added to it (token.add)."""
        flow = self.list_flows[target]
        if value is None or tokens > 1:
            flow.conflicts += 1
        elif isinstance(value, Call) and not added and value.name.lower() in ENTITY_LISTS:
            first = value.args[0].text.lower() if value.args and isinstance(value.args[0], (Name, Literal)) else ""
            flow.seeds.add(PLAYER if value.name.lower() != "$sort_entlist" and first == "player" else ENTITY)
        elif isinstance(value, (Literal, Name)) and value.text.lower() in ("", "none") and not added:
            return       # no entities
        elif isinstance(value, Name):
            source = self.flow_node(event, value.text, locals_)
            if source is None:
                flow.conflicts += 1
            elif added:
                flow.entries.add(source)       # token.add L X (decided when solving)
            else:
                flow.sources.add(source)
        elif added and isinstance(value, Call) and self._entity_call(value) is not None:
            flow.seeds.add(self._entity_call(value))
        else:
            flow.conflicts += 1

    def flow_player_list(self, target: Node) -> None:
        """getplayers L: every player's id."""
        self.list_flows[target].seeds.add(PLAYER)

    def flow_use(self, node: Node | None, kind: str) -> None:
        """`kind`: "number" (arithmetic, numeric tests, numeric arguments), "text" (compared with text),
        "null" (compared with "0" / "")."""
        if node is None:
            return
        flow = self.flows[node]
        if kind == "null":
            flow.null_compares += 1
        else:
            flow.use_conflicts += 1

    def note_engine_aliases(self, cmd_name: str, target: str, args: list[Expr]) -> None:
        """dmgevent:<x> (xdodamage flags): the engine fires <x>_dodamage like game_dodamage.
        local reg.attack.callback <x>: it fires <x>_damaged_other and <x>_strike for the attack
        (<x> is often a constant: const ATK1_CALLBACK atk1)."""
        for a in args:
            text = a.text if isinstance(a, (Name, Literal)) else ""
            for part in text.split(";"):
                if part.lower().startswith("dmgevent:") and len(part) > 9:
                    self._dmgevents.add(part[9:].lstrip("*"))
        if cmd_name == "local" and target.lower() == "reg.attack.callback" and args and isinstance(args[0], Name):
            self._attack_callbacks.add(args[0].text)

    def note_literal_value(self, name: str, value: str) -> None:
        self._literal_values[name].add(value)

    @property
    def engine_aliases(self) -> dict[str, str]:
        if self._aliases is None:
            aliases = {x + "_dodamage": "game_dodamage" for x in self._dmgevents}
            for name in self._attack_callbacks:
                for callback in {name} | self._literal_values.get(name, set()):
                    aliases[callback + "_damaged_other"] = "game_damaged_other"
                    aliases[callback + "_strike"] = "attack_strike"
            self._aliases = aliases
        return self._aliases

    def engine_spec(self, event: str):
        """The engine's signature of an event it fires, if any."""
        spec = mapping.ENGINE_EVENTS.get(event)
        if spec is None and event in self.engine_aliases:
            alias = self.engine_aliases[event]
            spec = mapping.ENGINE_EVENTS.get(alias) or mapping.ENGINE_EVENT_FORMS.get(alias)
        return spec

    # -- solution ------------------------------------------------------------------------------

    def entity_type(self, node: Node) -> str | None:
        if self._entity_types is None:
            self._entity_types = self._solve()
        if node[0] == "param" and node not in self._entity_types:
            return self.known_param_type(node[1], node[2])      # nothing else refers to it
        return self._entity_types.get(node)

    def _solve_lists(self) -> dict[Node, str]:
        """Which variables only ever hold ;-lists of entity ids (players when all are players)."""
        flows = self.list_flows
        for flow in flows.values():
            for entry in flow.entries:
                # token.add L PARAM1: an entity the engine passed; any other variable is not known yet
                known = self.known_param_type(entry[1], entry[2]) if entry[0] == "param" else None
                if known is None:
                    flow.conflicts += 1
                else:
                    flow.seeds.add(known)
            flow.entries = set()
        ok = {n for n, f in flows.items() if not f.conflicts}
        changed = True
        while changed:
            changed = False
            for node in list(ok):
                if any(s not in ok for s in flows[node].sources):
                    ok.discard(node)
                    changed = True
        grounded = {n for n in ok if flows[n].seeds}
        changed = True
        while changed:
            changed = False
            for node in ok - grounded:
                if any(s in grounded for s in flows[node].sources):
                    grounded.add(node)
                    changed = True
        players = {n for n in grounded if flows[n].seeds <= {PLAYER}}
        changed = True
        while changed:
            changed = False
            for node in list(players):
                if any(s not in players for s in flows[node].sources if s in grounded):
                    players.discard(node)
                    changed = True
        return {n: (PLAYER if n in players else ENTITY) for n in grounded}

    def _solve(self) -> dict[Node, str]:
        lists = self._solve_lists()
        self._entity_lists = lists
        for flow in list(self.flows.values()):
            for lst in flow.list_entries:
                if lst in lists:
                    flow.seeds.add(lists[lst])
                else:
                    flow.conflicts += 1        # an entry of a list of anything: text
            flow.list_entries = set()
        fixed: dict[Node, str] = {}
        referenced = set(self.flows) | {s for flow in list(self.flows.values()) for s in flow.sources}
        for node in referenced:
            if node[0] == "param":
                t = self.known_param_type(node[1], node[2])
                if t is not None:
                    fixed[node] = t

        def acceptable(node: Node) -> bool:
            flow = self.flows.get(node)
            if flow is None:
                return False
            if flow.conflicts or flow.use_conflicts:
                return False
            return not (node[0] == "field" and flow.null_compares)

        entity = set(fixed) | {n for n in self.flows if acceptable(n)}
        changed = True
        while changed:          # drop every variable something non-entity flows into
            changed = False
            for node in list(entity):
                if node in fixed:
                    continue
                if any(s not in entity for s in self.flows[node].sources):
                    entity.discard(node)
                    changed = True

        grounded = set(fixed) | {n for n in entity if self.flows[n].seeds}
        changed = True
        while changed:          # ... and every one no real entity reaches
            changed = False
            for node in entity - grounded:
                if any(s in grounded for s in self.flows[node].sources):
                    grounded.add(node)
                    changed = True

        players = {n for n, t in fixed.items() if t == PLAYER} | \
            {n for n in grounded if n not in fixed and self.flows[n].seeds <= {PLAYER}}
        changed = True
        while changed:          # a player when everything flowing in is a player
            changed = False
            for node in list(players):
                if node in fixed:
                    continue
                if any(s not in players for s in self.flows[node].sources if s in grounded):
                    players.discard(node)
                    changed = True
        return {n: (PLAYER if n in players else ENTITY) for n in grounded}
