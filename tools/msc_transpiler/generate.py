"""Turning parsed scripts into AngelScript files.

Layout of the output (scripts/angelscript/converted/<same path>.as):

* A file that other scripts #include ("library") becomes a `mixin class` holding its
  variables and event handlers. Handlers are named <Class>_On<Event> because several
  included files usually handle the same event and every one of them must run.
* A file nothing includes ("leaf") becomes a class tagged [script "<path>"] that mixes in
  everything it includes, in the engine's parse order. Its own handlers are written as the
  event methods themselves (On<Event>), calling the included files' handlers in the order
  the .script engine runs them. A generated section at the end connects the class to the
  engine: load-time values, first-think blocks, timers, event dispatch by .script name and
  variable access by .script name.
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass, field

from . import engine, mapping, names
from .corpus import Corpus, normalize
from .emit import emit_block, emit_method
from .expr import Call, Name, Number, Literal, parse_token, param_index, walk
from .infer import BOOL, FLOAT, INT, STRING, VECTOR, Inference
from .ir import Comment, If, Line, Method, Return, Stmt, TExpr
from .loader import Load, classify_kind, load
from .lower import FileContext, HandlerLowerer, Quirk, SignatureTable, convert, number_code, string_literal
from .syntax import Cmd, CmdList, Event, Include, ParsedFile, ScopeDirective

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


class Project:
    def __init__(self, corpus: Corpus):
        self.corpus = corpus
        self.all_names = corpus.names()
        self.class_names = names.unique_class_names(self.all_names)
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
        for item in parsed.items:
            if isinstance(item, ScopeDirective):
                scope = item.scope
            elif isinstance(item, Include):
                scope = "shared"
            elif isinstance(item, Event):
                if (item.explicit_scope or scope) == "client":
                    continue
                local_names = _locals_of(item.commands)
                for op in item.load_ops:
                    if op.kind in ("const", "setvar") and names.is_identifier(op.name) and not param_index(op.name):
                        if op.name not in info.declared:
                            info.declared[op.name] = op.value if op.kind == "const" or op.name not in info.declared else ""
                        if op.kind == "const":
                            info.declared_const.add(op.name)
                for cmd in _all_commands(item.commands):
                    lower = cmd.name.lower()
                    if lower == "setvar" and cmd.args:
                        target = cmd.args[0].text
                        if names.is_identifier(target) and not param_index(target) and target not in local_names:
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
        if self.is_library(name):
            return self._generate_library(name)
        return self._generate_leaf(name)

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
        if raw == "":
            return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, string_literal(var))
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

    def _handler_methods(self, info: FileInfo, ctx: FileContext, prefix: str) -> tuple[list[Method], dict]:
        """Every event handler of the file as its own method. Returns (methods, index) where index maps
        (event name or None, order) -> method name."""
        methods: list[Method] = []
        index: dict[int, str] = {}
        counts: dict[str, int] = defaultdict(int)
        first_think = 0
        timer = 0
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
                if not _has_runtime(item):
                    continue
                if item.repeat_delay is not None:
                    timer += 1
                    method_name = f"{prefix}Timer{'' if timer == 1 else timer}"
                else:
                    first_think += 1
                    method_name = f"{prefix}FirstThink{'' if first_think == 1 else first_think}"
                item.name = None
                lowerer = HandlerLowerer(ctx, item, None, method_name)
                lowerer.event_name = method_name
            method = lowerer.lower()
            if item.leading_comments:
                method.comments = list(item.leading_comments) + method.comments
            label = item.name or ("timer" if item.repeat_delay is not None else "first think")
            method.comments.insert(0, f"{label}" if item.name else f"unnamed block ({label})")
            methods.append(method)
            index[id(item)] = method_name
        return methods, index

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
        methods, _ = self._handler_methods(info, ctx, f"{class_name}_")
        for method in methods:
            lines.append("")
            lines.extend(emit_method(method))
        lines.append("}")
        lines.append("")
        self.quirks.extend(ctx.quirks)
        return "\n".join(lines)

    # leaf ------------------------------------------------------------------------------------

    def _generate_leaf(self, name: str) -> str:
        info = self.info(name)
        loaded = self.load(name)
        closure = loaded.files
        ctx = self.context(name, closure)
        class_name = self.class_of(name)
        mixins = [self.class_of(f) for f in closure[1:]]

        lines = self._file_header(info)
        lines.append(f'[script "{info.name}"]')
        lines.append(f"class {class_name} : ScriptEntity{''.join(', ' + m for m in mixins)}")
        lines.append("{")

        # fields: this file's own, plus corrections where include order decides a different value
        own_fields = self._field_lines(info, ctx)
        lines.extend(own_fields)
        corrections = self._const_corrections(loaded, info, ctx)
        if corrections:
            if own_fields:
                lines.append("")
            lines.append("\t// Constants defined by included files, with the value that wins for this script")
            lines.extend(corrections)

        own_methods, own_index = self._handler_methods(info, ctx, f"{class_name}_")
        own_by_name = {m.name: m for m in own_methods}

        composed, wiring_methods = self._compose_events(loaded, info, ctx, own_index, own_by_name)
        for method in composed:
            lines.append("")
            lines.extend(emit_method(method))

        lines.append("")
        lines.append("\t// ---- Engine wiring (generated) ----")
        for method in wiring_methods:
            lines.append("")
            lines.extend(emit_method(method))
        lines.append("}")
        lines.append("")
        self.quirks.extend(ctx.quirks)
        return "\n".join(lines)

    def _const_corrections(self, loaded: Load, info: FileInfo, ctx: FileContext) -> list[str]:
        """The class's own field wins over mixins, and earlier mixins win over later ones. Where the
        engine's first-definition-wins order picks another value, declare the winner here."""
        out = []
        mixin_files = loaded.files[1:]
        for const, winner in loaded.consts.items():
            if const in info.declared or not names.is_identifier(const):
                continue
            first = next((f for f in mixin_files if const in self.info(f).declared), None)
            if first is None:
                continue
            first_value = self.info(first).declared.get(const, "")
            if first.lower() == winner.file.lower() and first_value == winner.value:
                continue
            t = self.inference.field_type(const)
            init = self._initializer(const, t, winner.value, winner.quoted, ctx)
            out.append(f"\t{t} {names.variable(const)} = {init}; // from {winner.file}")
        return out

    def _compose_events(self, loaded: Load, info: FileInfo, ctx: FileContext,
                        own_index: dict, own_by_name: dict[str, Method]) -> tuple[list[Method], list[Method]]:
        handlers: dict[str, list[tuple[str, str]]] = defaultdict(list)   # event -> [(file, method)]
        first_think: list[str] = []
        timers: list[tuple[str, str]] = []           # (method, delay token)
        auto_run: list[tuple[str, str]] = []
        file_counters: dict[tuple[str, str], int] = defaultdict(int)
        anon_counters: dict[tuple[str, str], int] = defaultdict(int)
        for le in loaded.events:
            ev = le.event
            cls = self.class_of(le.file)
            if ev.name:
                method = self.info(le.file).handler_names[id(ev)]
                handlers[ev.name].append((le.file, method))
                if ev.repeat_delay is not None and _auto_runs(ev):
                    auto_run.append((ev.name, ev.repeat_delay))
            elif _has_runtime(ev):
                kind = "Timer" if ev.repeat_delay is not None else "FirstThink"
                anon_counters[(le.file, kind)] += 1
                n = anon_counters[(le.file, kind)]
                method = f"{cls}_{kind}{'' if n == 1 else n}"
                if kind == "Timer":
                    timers.append((method, ev.repeat_delay))
                else:
                    first_think.append(method)

        called: set[str] = set()
        for f in loaded.files:
            called |= self.info(f).called_events
        for event in called:
            handlers.setdefault(event, [])

        composed: list[Method] = []
        wiring: list[Method] = []
        own_name = info.name.lower()
        for event, hs in handlers.items():
            sig = self.signatures.get(event)
            args = ", ".join(n for _, n in sig.params)
            own = [m for f, m in hs if f.lower() == own_name]
            body: list[Stmt] = []
            inline_method = None
            if len(own) == 1 and hs and hs[-1][1] == own[0] and sig.returns == "void":
                inline_method = own_by_name.get(own[0])
            calls = hs[:-1] if inline_method else hs
            if sig.returns == "string":
                if len(calls) == 1:
                    body = [Return(f"{calls[0][1]}({args})")]
                else:
                    body = [Line('string result = ""')]
                    body += [Line(f"result = AppendResult(result, {m}({args}))") for _, m in calls]
                    body.append(Return("result"))
            else:
                body = [Line(f"{m}({args})", trailing=_origin_comment(f, info)) for f, m in calls]
            method = Method(sig.method, list(sig.params), sig.returns, body)
            if sig.params:
                method.defaults = {n: _default(t) for t, n in sig.params}
            spec = mapping.ENGINE_EVENTS.get(event)
            method.comments = [event + (f" - {spec.doc}" if spec and spec.doc else "")]
            if inline_method is not None:
                method.body = body + inline_method.body
                method.comments += [c for c in inline_method.comments[1:]]
                composed.append(method)
                own_by_name.pop(inline_method.name, None)
            else:
                wiring.append(method)

        # own handlers that were not inlined stay as methods of the class
        own_rest = [m for m in own_by_name.values()]
        composed = own_rest + composed

        on_load = self._on_load(loaded, ctx, timers, auto_run)
        if on_load.body:
            wiring.append(on_load)
        if first_think:
            wiring.append(Method("OnFirstThink", [], "void", [Line(f"{m}()") for m in first_think],
                                 comments=["Unnamed .script blocks: run on the first think after spawn"],
                                 qualifiers="override"))
        if handlers or timers:
            wiring.append(self._dispatch(handlers, [m for m, _ in timers]))
        get_var, set_var = self._var_access(loaded)
        if len(get_var.body) > 1:
            wiring.append(get_var)
            wiring.append(set_var)
        return composed, wiring

    def _on_load(self, loaded: Load, ctx: FileContext, timers, auto_run) -> Method:
        body: list[Stmt] = []
        resources = _resources(self, loaded)
        for res in resources:
            body.append(Line(f"Precache({string_literal(res)})"))
        for method, delay in timers:
            body.append(Line(f"CallEventDelayed({_delay_code(delay, ctx)}, {string_literal(method)})"))
        for event, delay in auto_run:
            body.append(Line(f"CallEventDelayed({_delay_code(delay, ctx)}, {string_literal(event)})"))
        return Method("OnLoad", [], "void", body,
                      comments=["Load time: resources the .script parser precaches, and timers it starts"],
                      qualifiers="override")

    def _dispatch(self, handlers: dict[str, list], timer_methods: list[str]) -> Method:
        body: list[Stmt] = []
        for event in sorted(handlers):
            sig = self.signatures.get(event)
            args = ", ".join(_param_from_array(t, i) for i, (t, _) in enumerate(sig.params))
            call = f"{sig.method}({args})"
            then: list[Stmt] = [Line(f"Return({call})") if sig.returns == "string" else Line(call), Return("true")]
            body.append(If(TExpr(f"name == {string_literal(event)}", BOOL, 5), then, compact=True))
        for method in timer_methods:
            body.append(If(TExpr(f"name == {string_literal(method)}", BOOL, 5), [Line(f"{method}()"), Return("true")],
                           compact=True))
        body.append(Return("false"))
        return Method("DispatchEvent", [("string", "name"), ("const array<string> &in", "params")], "bool", body,
                      comments=["Events by their .script names (engine, callexternal, timers)"], qualifiers="override")

    def _var_access(self, loaded: Load) -> tuple[Method, Method]:
        get_body: list[Stmt] = []
        set_body: list[Stmt] = []
        seen: set[str] = set()
        for f in loaded.files:
            for var in self.info(f).declared:
                if var in seen:
                    continue
                seen.add(var)
                t = self.inference.field_type(var)
                ident = names.variable(var)
                to_text = ident if t == STRING else f"Text({ident})"
                get_body.append(If(TExpr(f"name == {string_literal(var)}", BOOL, 5),
                                   [Line(f"value = {to_text}"), Return("true")], compact=True))
                from_text = convert(TExpr("value", STRING), t).code
                set_body.append(If(TExpr(f"name == {string_literal(var)}", BOOL, 5),
                                   [Line(f"{ident} = {from_text}"), Return("true")], compact=True))
        get_body.append(Return("false"))
        set_body.append(Return("false"))
        get = Method("GetLegacyVar", [("string", "name"), ("string &out", "value")], "bool", get_body,
                     comments=["Variables by their .script names ($get(x,scriptvar,'NAME'), engine reads)"],
                     qualifiers="override")
        set_ = Method("SetLegacyVar", [("string", "name"), ("string", "value")], "bool", set_body, qualifiers="override")
        return get, set_


# ----------------------------------------------------------------------------------------------

def _origin_comment(file: str, info: FileInfo) -> str:
    return file if file.lower() != info.name.lower() else ""


def _default(t: str) -> str:
    return {INT: "0", FLOAT: "0.0f", BOOL: "false", VECTOR: "Vector3()"}.get(t, '""')


def _param_from_array(t: str, i: int) -> str:
    raw = f"Param(params, {i})"
    return raw if t == STRING else convert(TExpr(raw, STRING), t).code


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


def _auto_runs(event: Event) -> bool:
    """A named event runs on its own when its repeatdelay comes after its eventname."""
    last = None
    for op in event.load_ops:
        if op.kind in ("eventname", "repeatdelay"):
            last = op.kind
    return last == "repeatdelay"


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
