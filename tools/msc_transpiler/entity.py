"""The [script "..."] class of a file: what the engine creates when the script spawns.

Every file gets one. A leaf's holds the leaf's own code. A library's is `shared`: compiled
once and reused by every script module, and it is also the base class of the scripts that
include the library, so library code is compiled once rather than once per script.

A class derives from the shared class of its biggest include (one whose own includes are all
part of this script's) and mixes in the rest of its files. Fields it inherits are not declared
again; where this script's include order gives one a different starting value, the
constructor sets it.
"""

from __future__ import annotations

from . import names
from .corpus import normalize
from .emit import emit_method, emit_methods
from .infer import BOOL, ENTITY, FLOAT, INT, PLAYER, VECTOR
from .ir import Line, Method

ENTITY_SUFFIX = "Script"


class EntityClasses:
    """Mixed into Project: everything about the spawnable class of each file."""

    def entity_class_of(self, name: str) -> str:
        if not self.is_library(name):
            return self.class_of(name)
        if not hasattr(self, "_taken_class_names"):
            self._taken_class_names = {n.lower() for n in self.class_names.values()}
        candidate = self.class_of(name) + ENTITY_SUFFIX
        return candidate if candidate.lower() not in self._taken_class_names else candidate + "Entity"

    def base_of(self, name: str) -> str | None:
        """The include whose shared class this file's class derives from: the biggest one whose own
        include closure lies inside this file's (so everything the base runs, this script runs too)."""
        cache = self.__dict__.setdefault("_bases", {})
        key = normalize(name).lower()
        if key in cache:
            return cache[key]
        files = self.load(name).files
        inside = {f.lower() for f in files}
        best, best_weight = None, 0
        for candidate in files[1:]:
            closure = self.load(candidate).files
            lowered = {f.lower() for f in closure}
            if key in lowered or not lowered <= inside:
                continue
            weight = sum(self._weight(f) for f in closure)
            if weight > best_weight:
                best, best_weight = candidate, weight
        cache[key] = best
        return best

    def class_mixins(self, name: str) -> list[str]:
        """The files mixed into the class, in parse order (a library's own mixin comes first)."""
        files = self.load(name).files
        base = self.base_of(name)
        in_base = {f.lower() for f in self.load(base).files} if base else set()
        mixins = [f for f in files[1:] if f.lower() not in in_base]
        return ([files[0]] if self.is_library(name) else []) + mixins

    def _weight(self, name: str) -> int:
        cache = self.__dict__.setdefault("_weights", {})
        key = normalize(name).lower()
        if key not in cache:
            cache[key] = sum(len(e.commands.cmds) + 1 for e in self.info(name).parsed.events)
        return cache[key]

    def file_context(self, name: str):
        """The context a file's own code is generated in (a leaf sees its whole closure)."""
        cache = self.__dict__.setdefault("_contexts", {})
        key = normalize(name).lower()
        if key not in cache:
            cache[key] = self.context(name) if self.is_library(name) else self.context(name, self.load(name).files)
        return cache[key]

    def field_inits(self, name: str) -> dict[str, str]:
        """The fields a file declares, with the initializer its own code is written with."""
        cache = self.__dict__.setdefault("_field_inits", {})
        key = normalize(name).lower()
        if key not in cache:
            info = self.info(name)
            ctx = self.file_context(name)
            cache[key] = {var: self._initializer(var, self.inference.field_type(var), raw, False, ctx)
                          for var, raw in info.declared.items()}
        return cache[key]

    def desired_fields(self, name: str) -> dict[str, tuple[str, str]]:
        """Every field of the file's class and the value it starts with: var -> (initializer, origin).
        The first file in parse order that declares a field gives its value, except constants, where
        the engine keeps the first definition it read."""
        cache = self.__dict__.setdefault("_desired", {})
        key = normalize(name).lower()
        if key in cache:
            return cache[key]
        loaded = self.load(name)
        info = self.info(name)
        result: dict[str, tuple[str, str]] = {}
        for f in loaded.files:
            for var, code in self.field_inits(f).items():
                result.setdefault(var, (code, f))
        ctx = self.file_context(name)
        for const, winner in loaded.consts.items():
            if const in info.declared or not names.is_identifier(const) or const not in result:
                continue
            first = next((f for f in loaded.files[1:] if const in self.info(f).declared), None)
            if first and first.lower() == winner.file.lower() and self.info(first).declared.get(const, "") == winner.value:
                continue
            code = self._initializer(const, self.inference.field_type(const), winner.value, winner.quoted, ctx)
            result[const] = (code, winner.file)
        if self.is_library(name):
            for var in sorted(self.guaranteed_fields(name)):
                if var not in result:
                    t = self.inference.field_type(var)
                    result[var] = ({INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()", ENTITY: "null",
                                    PLAYER: "null"}.get(t, f'"{var}"'), "")
        cache[key] = result
        return result

    # -- output -----------------------------------------------------------------------------

    def entity_lines(self, name: str, own_methods: list[Method]) -> list[str]:
        """The class, from its declaration to its closing brace. `own_methods` are a leaf's handlers."""
        info = self.info(name)
        loaded = self.load(name)
        ctx = self.file_context(name)
        is_library = self.is_library(name)
        base = self.base_of(name)
        mixins = self.class_mixins(name)
        parents = [self.entity_class_of(base) if base else "ScriptEntity"] + [self.class_of(f) for f in mixins]

        lines: list[str] = []
        if is_library:
            lines += ["// This file as a script of its own: what spawns when it is spawned directly, and the",
                      "// base class of the scripts that include it. Shared, so it is compiled only once."]
        lines.append(f'[script "{info.name}"]')
        lines.append(f"{'shared ' if is_library else ''}class {self.entity_class_of(name)} : {', '.join(parents)}")
        lines.append("{")
        body: list[str] = []

        # fields
        desired = self.desired_fields(name)
        inherited = self.desired_fields(base) if base else {}
        from_mixins: dict[str, str] = {}
        for f in mixins:
            for var, code in self.field_inits(f).items():
                from_mixins.setdefault(var, code)
        own = set(info.declared) - set(inherited) if not is_library else set()
        body += self._field_lines(info, ctx, only=own) if own else []
        corrections, expected, constructor = [], [], []
        for var, (code, origin) in desired.items():
            t = self.inference.field_type(var)
            if var in inherited:
                if inherited[var][0] != code:
                    from_file = origin and origin.lower() != info.name.lower()
                    at = "@" if t in (ENTITY, PLAYER) else ""       # a handle is pointed, not copied
                    constructor.append(f"\t\t{at}{names.variable(var)} = {code};" + (f" // from {origin}" if from_file else ""))
            elif var in own or from_mixins.get(var) == code:
                continue
            elif origin:
                corrections.append(f"\t{t} {names.variable(var)} = {code}; // from {origin}")
            else:
                expected.append(f"\t{t} {names.variable(var)} = {code};")
        if corrections:
            _gap(body)
            body.append("\t// Constants defined by included files, with the value that wins for this script")
            body += corrections
        if expected:
            _gap(body)
            body.append("\t// Variables every script that includes this file declares")
            body += expected
        if constructor:
            _gap(body)
            body.append("\t// Variables declared by included files, with the value they start with in this script")
            body.append(f"\t{self.entity_class_of(name)}()")
            body.append("\t{")
            body += constructor
            body.append("\t}")

        # event methods: this script's own code, then forwarders where included handlers run differently
        own_by_name = {m.name: m for m in own_methods}
        own_name = info.name.lower()
        plan = self.wiring.plan(name)
        event_methods: list[Method] = []
        forwarders: list[Method] = []
        for event in self.wiring.class_declared(name):
            hs = plan.handlers.get(event, [])
            sig = self.signatures.get(event)
            mine = [m for f, m in hs if f.lower() == own_name] if not is_library else []
            inline = None
            if len(mine) == 1 and hs[-1][1] == mine[0] and sig.returns == "void":
                inline = own_by_name.pop(mine[0], None)
            method = self.wiring.event_method(event, name, self.wiring.class_declared(name)[event], inline)
            (event_methods if mine else forwarders).append(method)
        for method in list(own_by_name.values()) + event_methods:
            _gap(body)
            body += emit_method(method)

        wiring: list[list[str]] = []
        for method in (self._on_load_method(name), self._first_think_method(name)):
            out = emit_method(method)
            base_out = None
            if base:
                base_method = self._on_load_method(base) if method.name == "OnLoad" else self._first_think_method(base)
                base_out = emit_method(base_method)
            if (base is None and method.body) or (base is not None and out != base_out):
                wiring.append(out)
        dispatch = self.wiring.entity_dispatch(name)
        if dispatch is not None:
            wiring.append(emit_method(dispatch))
        if forwarders or wiring:
            _gap(body)
            body.append("\t// ---- Engine wiring (generated) ----")
        if forwarders:
            body.append("")
            body.append("\t// Events whose included handlers run differently here than in the included files")
            emit_methods(body, forwarders)
        for out in wiring:
            body.append("")
            body += out

        lines += body
        lines.append("}")
        self.quirks.extend(ctx.quirks)
        return lines

    def _on_load_method(self, name: str) -> Method:
        loaded = self.load(name)
        return self._on_load(loaded, self.file_context(name), self.wiring.plan(name))

    def _first_think_method(self, name: str) -> Method:
        plan = self.wiring.plan(name)
        return Method("OnFirstThink", [], "void", [Line(f"{m}()") for m in plan.first_think],
                      comments=["Unnamed .script blocks: run on the first think after spawn"], qualifiers="override")


def _gap(lines: list[str]) -> None:
    if lines and lines[-1] != "":
        lines.append("")
