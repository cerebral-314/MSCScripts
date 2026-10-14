"""Turning parsed scripts into AngelScript files.

Layout of the output (scripts/angelscript/converted/<same path>.as):

* A file that other scripts #include ("library") becomes a `mixin class` holding its
  variables and event handlers. Handlers are named <Class>_On<Event> because several
  included files usually handle the same event and every one of them must run. The file
  also has a shared [script "<path>"] class (see entity.py), compiled once, which is both
  what spawns when the library is spawned directly and the base class of the scripts that
  include it.
* A file nothing includes ("leaf") becomes a class tagged [script "<path>"] that derives from
  its biggest include's shared class and mixes in the rest, in the engine's parse order. Its
  own handlers are written as the event methods themselves (On<Event>), calling the included
  files' handlers in the order the .script engine runs them.
* A generated section at the end of each class connects it to the engine: load-time work,
  first-think blocks, timers and event dispatch by .script name (see wiring.py).
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass, field

from . import engine, names
from .corpus import Corpus, normalize
from .emit import emit_method, emit_methods
from .expr import Call, Name, Number, Literal, parse_token, param_index, walk
from .infer import BOOL, FLOAT, HANDLES, INT, STRING, VECTOR, Inference
from .ir import Line, Method, Stmt, TExpr
from .loader import Load, load
from .context import FileContext, Quirk, SignatureTable
from .lower import HandlerLowerer
from .values import convert, number_code, string_literal
from .syntax import Cmd, CmdList, Event, Include, ParsedFile, ScopeDirective
from .entity import EntityClasses
from .wiring import EventWiring
from .runtime_gen import api_names

HEADER = "#pragma context server"
RUNTIME_INCLUDE = '#include "runtime/ScriptEntity.as"'


def output_path(script: str) -> str:
    return f"converted/{normalize(script)}.as"


@dataclass
class FileInfo:
    name: str
    parsed: ParsedFile
    kind: str
    declared: dict[str, str] = field(default_factory=dict)       # field name -> initializer source ("" if none)
    declared_const: set[str] = field(default_factory=set)
    called_events: set[str] = field(default_factory=set)
    handler_names: dict[int, str] = field(default_factory=dict)   # id(Event) -> method name
    block_names: dict[int, str] = field(default_factory=dict)     # id(Event) of unnamed blocks -> method name


class Project(EntityClasses):
    def __init__(self, corpus: Corpus):
        self.corpus = corpus
        self.all_names = corpus.names()
        self.class_names = names.unique_class_names(self.all_names, api_names())
        self.included_by: dict[str, set[str]] = defaultdict(set)
        for name in self.all_names:
            parsed = corpus.parse(name, engine.WORLD)
            for inc in parsed.includes:
                target = corpus.path(inc.path)
                if target is not None:
                    self.included_by[normalize(inc.path).lower()].add(name)
        self.inference = Inference()
        for name in self.all_names:
            self.inference.add_file(corpus.parse(name, self.kind_of(name)))
        self.signatures = SignatureTable(self.inference, sorted(self.inference.event_names))
        self.assigned_anywhere: set[str] = set(self.inference.fields)
        self._infos: dict[str, FileInfo] = {}
        self._loads: dict[str, Load] = {}
        self._guaranteed: dict[str, set[str]] | None = None
        self._possible: dict[str, set[str]] = {}
        self.quirks: list[Quirk] = []
        self.wiring = EventWiring(self)

    # -- facts about files ----------------------------------------------------------------

    def canonical(self, name: str) -> str:
        path = self.corpus.path(name)
        return normalize(path.relative_to(self.corpus.root).as_posix()) if path else normalize(name)

    def is_library(self, name: str) -> bool:
        return bool(self.included_by.get(normalize(name).lower()))

    def class_of(self, name: str) -> str:
        return self.class_names.get(self.canonical(name).lower(), names.class_name(name))

    def kind_of(self, name: str) -> str:
        lower = normalize(name).lower()
        if lower.startswith("items/"):
            return engine.ITEM
        if lower in ("world", "global"):
            return engine.WORLD
        return engine.MONSTER

    def load(self, leaf: str) -> Load:
        key = normalize(leaf).lower()
        if key not in self._loads:
            self._loads[key] = load(self.corpus, leaf, kind_for=self.kind_of)
        return self._loads[key]

    def info(self, name: str) -> FileInfo:
        key = normalize(name).lower()
        if key in self._infos:
            return self._infos[key]
        parsed = self.corpus.parse(name, self.kind_of(name))
        info = FileInfo(parsed.name, parsed, self.kind_of(name))
        cls = self.class_of(parsed.name)
        counts: dict[str, int] = defaultdict(int)
        for item in parsed.events:
            if item.name:
                counts[item.name] += 1
                n = counts[item.name]
                info.handler_names[id(item)] = f"{cls}_{self.signatures.get(item.name).method}{'' if n == 1 else f'_{n}'}"
        scope = "shared"
        blocks: dict[str, int] = defaultdict(int)
        for item in parsed.items:
            if isinstance(item, ScopeDirective):
                scope = item.scope
            elif isinstance(item, Include):
                scope = "shared"
            elif isinstance(item, Event):
                if (item.explicit_scope or scope) == "client":
                    continue
                if not item.name and _has_runtime(item):
                    kind = "Timer" if item.repeat_delay is not None else "FirstThink"
                    blocks[kind] += 1
                    info.block_names[id(item)] = f"{cls}_{kind}{'' if blocks[kind] == 1 else blocks[kind]}"
                local_names = _locals_of(item.commands)
                for op in item.load_ops:
                    if op.kind in ("const", "setvar") and names.is_identifier(op.name) and not param_index(op.name):
                        if op.name not in info.declared:
                            info.declared[op.name] = op.value if op.kind == "const" or op.name not in info.declared else ""
                        if op.kind == "const":
                            info.declared_const.add(op.name)
                for cmd in _all_commands(item.commands):
                    lower = cmd.name.lower()
                    # setvar, and math / text / vector / token commands, store a script variable
                    # (ScriptCmd_MathSet etc. end in SetVar): those are fields too. A global of the
                    # same name stays a lookup, since the command reads the global's value first.
                    writes = lower in HandlerLowerer.WRITE_COMMANDS - {"local", "subract"}
                    if writes and cmd.args:
                        target = cmd.args[0].text
                        if names.is_identifier(target) and not param_index(target) and target not in local_names \
                                and (lower in ("setvar", "setvard") or target not in self.inference.globals):
                            info.declared.setdefault(target, "")
                    for event in _called_events(cmd):
                        info.called_events.add(event)
        self._infos[key] = info
        return info

    def closure_files(self, name: str) -> list[str]:
        """The file's own include closure (itself first), independent of who includes it."""
        seen: list[str] = []

        def visit(n: str) -> None:
            parsed = self.corpus.parse(n, engine.WORLD)
            if parsed is None or any(s.lower() == parsed.name.lower() for s in seen):
                return
            seen.append(parsed.name)
            for inc in parsed.includes:
                if not inc.client_only:
                    visit(inc.path)

        visit(name)
        return seen

    def _library_scan(self) -> None:
        """For every library: the names every including leaf declares (safe to use as fields) and
        the names any including leaf declares (variables that may exist at run time)."""
        self._guaranteed = {}
        self._possible = {}
        leaves_by_lib: dict[str, list[set[str]]] = defaultdict(list)
        for leaf in self.all_names:
            if self.is_library(leaf):
                continue
            files = self.closure_files(leaf)
            declared: set[str] = set()
            for f in files:
                declared |= set(self.info(f).declared)
            for f in files[1:]:
                leaves_by_lib[f.lower()].append(declared)
        for lib, sets in leaves_by_lib.items():
            self._guaranteed[lib] = set.intersection(*sets) if sets else set()
            self._possible[lib] = set.union(*sets) if sets else set()

    def guaranteed_fields(self, library: str) -> set[str]:
        if self._guaranteed is None:
            self._library_scan()
        return self._guaranteed.get(normalize(library).lower(), set())

    def possible_vars(self, name: str, closure: list[str]) -> set[str]:
        if self._guaranteed is None:
            self._library_scan()
        names_: set[str] = set()
        for f in closure:
            names_ |= set(self.info(f).declared)
        return names_ | self._possible.get(normalize(name).lower(), set())

    def visible_fields(self, name: str, leaf_closure: list[str] | None = None) -> dict[str, str]:
        files = leaf_closure if leaf_closure is not None else self.closure_files(name)
        visible: set[str] = set()
        for f in files:
            visible |= set(self.info(f).declared)
        if leaf_closure is None and self.is_library(name):
            visible |= self.guaranteed_fields(name)
        return {n: self.inference.field_type(n) for n in visible}

    def context(self, name: str, leaf_closure: list[str] | None = None) -> FileContext:
        fields = self.visible_fields(name, leaf_closure)
        closure = leaf_closure if leaf_closure is not None else self.closure_files(name)
        dynamic = self.possible_vars(name, closure) - set(fields)
        return FileContext(self.canonical(name), self.class_of(name), self.inference, fields, dynamic,
                           self.signatures, kind=self.kind_of(name))

    # -- output -------------------------------------------------------------------------

    def generate(self, name: str) -> str:
        name = self.canonical(name)
        text = self._generate_library(name) if self.is_library(name) else self._generate_leaf(name)
        return _comment_text(text)

    def _file_header(self, info: FileInfo) -> list[str]:
        lines = [HEADER, "", f"// Converted from {info.name}.script by msc_transpiler."]
        for c in info.parsed.header_comments:
            lines.append(f"// {c}" if c else "//")
        lines.append("")
        lines.append(RUNTIME_INCLUDE)
        for inc in info.parsed.includes:
            if inc.client_only:
                continue
            target = self.corpus.path(inc.path)
            if target is None:
                lines.append(f"// #include {inc.path} - not found{' (optional)' if inc.casual else ''}")
                continue
            lines.append(f'#include "{output_path(self.canonical(inc.path))}"')
        lines.append("")
        return lines

    def _field_lines(self, info: FileInfo, ctx: FileContext, only: set[str] | None = None,
                     values: dict[str, tuple[str, bool]] | None = None) -> list[str]:
        consts, variables = [], []
        for var in info.declared:
            if only is not None and var not in only:
                continue
            t = self.inference.field_type(var)
            raw = values[var][0] if values and var in values else info.declared[var]
            quoted = values[var][1] if values and var in values else False
            init = self._initializer(var, t, raw, quoted, ctx)
            line = f"\t{t} {names.variable(var)} = {init};"
            (consts if var in info.declared_const else variables).append(line)
        out = []
        if consts:
            out.append("\t// Constants")
            out.extend(consts)
        if variables:
            if consts:
                out.append("")
            out.append("\t// Variables (an unset .script variable reads as its own name)")
            out.extend(variables)
        return out

    def _initializer(self, var: str, t: str, raw: str, quoted: bool, ctx: FileContext) -> str:
        if t in HANDLES:
            return "null"      # anything else is assigned in OnLoad
        if raw == "":
            return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, string_literal(var))
        if not quoted and param_index(raw):
            # `setvard X PARAM1` also runs at load, when there are no parameters: X starts empty
            return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, '""')
        expr = parse_token(raw, quoted)
        if isinstance(expr, Number):
            if t in (INT, FLOAT):
                return number_code(expr.text, t)
            if t == BOOL:
                return "true" if expr.value else "false"
            if t == VECTOR:
                return "Vector3()"   # a number read as a vector is (0,0,0)
            return string_literal(raw)
        if isinstance(expr, (Literal,)) or (isinstance(expr, Name) and expr.text not in ctx.fields):
            text = expr.text
            if t == STRING:
                return string_literal(text)
            if t == VECTOR:
                return f"Vec({string_literal(text)})"
            return {INT: "0", FLOAT: "0.0f", BOOL: "false"}[t] if not text.replace(".", "", 1).lstrip("-").isdigit() \
                else number_code(text, t)
        # anything that needs evaluation is assigned in OnLoad instead
        return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, string_literal(var))

    def _handler_methods(self, info: FileInfo, ctx: FileContext) -> list[Method]:
        """Every event handler of the file as its own method."""
        methods: list[Method] = []
        scope = "shared"
        for item in info.parsed.items:
            if isinstance(item, ScopeDirective):
                scope = item.scope
                continue
            if isinstance(item, Include):
                scope = "shared"
                continue
            if not isinstance(item, Event) or (item.explicit_scope or scope) == "client":
                continue
            if item.name:
                sig = self.signatures.get(item.name)
                method_name = info.handler_names[id(item)]
                lowerer = HandlerLowerer(ctx, item, sig, method_name)
            else:
                if id(item) not in info.block_names:
                    continue
                method_name = info.block_names[id(item)]
                lowerer = HandlerLowerer(ctx, item, None, method_name)
                lowerer.event_name = method_name
            method = lowerer.lower()
            if item.leading_comments:
                method.comments = list(item.leading_comments) + method.comments
            label = item.name or ("timer" if item.repeat_delay is not None else "first think")
            method.comments.insert(0, f"{label}" if item.name else f"unnamed block ({label})")
            methods.append(method)
        return methods

    # library -------------------------------------------------------------------------------

    def _generate_library(self, name: str) -> str:
        info = self.info(name)
        ctx = self.context(name)
        class_name = self.class_of(name)
        lines = self._file_header(info)
        lines.append(f"// Included by other scripts: its handlers run as part of every script that includes it.")
        lines.append(f"mixin class {class_name}")
        lines.append("{")
        fields = self._field_lines(info, ctx)
        lines.extend(fields)
        for method in self._handler_methods(info, ctx):
            lines.append("")
            lines.extend(emit_method(method))

        declared = self.wiring.mixin_declared(name)
        events = [self.wiring.event_method(e, name, runs) for e, runs in declared.items()]
        dispatch = self.wiring.mixin_dispatch(name)
        if events or dispatch:
            lines.append("")
            lines.append("\t// ---- Engine wiring (generated) ----")
        if events:
            lines.append("")
            lines.append("\t// What each event runs in a script that includes this file")
            lines.append("\t// (a script with more handlers for an event declares its own)")
            emit_methods(lines, events)
        if dispatch:
            lines.append("")
            lines.extend(emit_method(dispatch))
        lines.append("}")
        lines.append("")
        self.quirks.extend(ctx.quirks)
        lines.extend(self.entity_lines(name, []))
        lines.append("")
        return "\n".join(lines)

    # leaf ------------------------------------------------------------------------------------

    def _generate_leaf(self, name: str) -> str:
        info = self.info(name)
        lines = self._file_header(info)
        lines.extend(self.entity_lines(name, self._handler_methods(info, self.file_context(name))))
        lines.append("")
        return "\n".join(lines)

    def _on_load(self, loaded: Load, ctx: FileContext, plan) -> Method:
        body: list[Stmt] = []
        resources = _resources(self, loaded)
        for res in resources:
            body.append(Line(f"Precache({string_literal(res)})"))
        for _, method, delay in plan.timers:
            body.append(Line(f"CallEventDelayed({_delay_code(delay, ctx)}, {string_literal(method)})"))
        for event, delay in plan.auto_run:
            body.append(Line(f"CallEventDelayed({_delay_code(delay, ctx)}, {string_literal(event)})"))
        return Method("OnLoad", [], "void", body,
                      comments=["Load time: resources the .script parser precaches, and timers it starts"],
                      qualifiers="override")

# ----------------------------------------------------------------------------------------------

def _comment_text(text: str) -> str:
    """Scripts are read as Latin-1, but some comments were saved as UTF-8. String constants are
    plain ASCII by now, so any other character is comment text: lines whose bytes are valid
    UTF-8 are shown as that."""
    if text.isascii():
        return text
    lines = text.split("\n")
    for i, line in enumerate(lines):
        if not line.isascii():
            try:
                lines[i] = line.encode("latin-1").decode("utf-8")
            except UnicodeError:
                pass
    return "\n".join(lines)


def _delay_code(token: str, ctx: FileContext) -> str:
    expr = parse_token(token)
    if isinstance(expr, Number):
        return number_code(expr.text, FLOAT)
    if token in ctx.fields:
        return convert(TExpr(names.variable(token), ctx.fields[token]), FLOAT).code
    return f"Float(Eval({string_literal(token)}))"


def _all_commands(cmds: CmdList):
    for cmd in cmds.cmds:
        yield cmd
        if cmd.if_list:
            yield from _all_commands(cmd.if_list)
        for e in cmd.else_lists:
            yield from _all_commands(e)


def _locals_of(cmds: CmdList) -> set[str]:
    return {c.args[0].text for c in _all_commands(cmds) if c.name.lower() == "local" and c.args}


def _called_events(cmd: Cmd) -> list[str]:
    lower = cmd.name.lower()
    out = []
    args = [parse_token(t.text, t.quoted) for t in cmd.args]
    if lower == "callevent" and args:
        target = args[1] if isinstance(args[0], Number) and len(args) > 1 else args[0]
        if isinstance(target, Name) and not isinstance(args[0], Number):
            out.append(target.text)
    elif lower == "calleventloop" and len(args) >= 2 and isinstance(args[1], Name):
        out.append(args[1].text)
    for a in args:
        for e in walk(a):
            if isinstance(e, Call) and e.name.lower() == "$func" and e.args and isinstance(e.args[0], Name):
                out.append(e.args[0].text)
    return [e for e in out if names.is_identifier(e.replace(".", "_").replace("-", "_").replace("+", "_"))
            and not param_index(e) and not e.lower().startswith(("game.", "ent_", "const."))]


def _has_runtime(event: Event) -> bool:
    return bool(event.commands.cmds)


def _resources(project: Project, loaded: Load) -> list[str]:
    out: list[str] = []
    for le in loaded.events:
        for op in le.event.load_ops:
            if op.kind != "precache":
                continue
            tokens = op.value.split()
            if op.name in ("setmodel", "setviewmodel", "setworldmodel", "setpmodel", "setshield", "attachsprite",
                           "svsound.play3d"):
                tokens = tokens[:1]
            elif op.name in ("svplaysound", "svplayrandomsound"):
                tokens = tokens[1:]
            for token in tokens:
                const = loaded.consts.get(token)
                value = const.value if const else token
                if op.name == "say":
                    value = value.split("[", 1)[0]
                    if value and value != "*" and "RND_SAY" not in value:
                        value = f"npc/{value}.wav"
                if value.lower().endswith((".wav", ".mdl", ".spr")) and value != "none":
                    if op.name == "precache" and value.lower().endswith(".wav"):
                        continue   # `precache` does not precache sounds
                    if value not in out:
                        out.append(value)
    return out
