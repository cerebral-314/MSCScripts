"""How events reach their handlers in the generated classes.

Every handler of a .script file is a method <Class>_On<Event>. What runs for an event is
those handlers across the include closure, in the engine's parse order, and the class's
On<Event> method runs them.

A library's mixin declares On<Event> as it runs in a script that includes the library. A
class gets each On<Event> from, in order: its own body, the first of its mixins that
declares it (AngelScript keeps the first mixin's method, and a mixin's method overrides an
inherited one), then its base class. A class declares On<Event> only where what it would
get that way differs from what the event runs in this script.

Dispatch by .script name ("game_spawn", timers) is shared the same way: each library's mixin
has <Class>_DispatchEvent for the events it handles, and a class's DispatchEvent lists its own
events, asks each of its mixins' dispatchers, then its base class.
"""

from __future__ import annotations

from collections import defaultdict
from dataclasses import dataclass

from . import mapping
from .corpus import normalize
from .infer import BOOL, ENTITY, FLOAT, INT, PLAYER, STRING, VECTOR
from .ir import If, Line, Method, Return, Stmt, TExpr
from .values import convert, missing_param, string_literal


@dataclass
class EventPlan:
    """A file's events once its includes are loaded (as a leaf, or a library on its own)."""
    handlers: dict[str, list[tuple[str, str]]]   # event -> [(file, handler method)] in run order
    called: set[str]                              # events called from code (callevent, $func)
    first_think: list[str]                        # unnamed blocks run on the first think
    timers: list[tuple[str, str, str]]            # (file, method, delay token) of unnamed repeatdelay blocks
    auto_run: list[tuple[str, str]]               # (event, delay token) of named events that start themselves


class EventWiring:
    def __init__(self, project):
        self.project = project
        self._plans: dict[str, EventPlan] = {}
        self._mixin: dict[str, dict[str, list[str]]] = {}
        self._class: dict[str, dict[str, list[str]]] = {}
        self._resolved: dict[str, dict[str, list[str]]] = {}

    def plan(self, name: str) -> EventPlan:
        key = normalize(name).lower()
        if key in self._plans:
            return self._plans[key]
        p = self.project
        loaded = p.load(name)
        handlers: dict[str, list[tuple[str, str]]] = defaultdict(list)
        first_think: list[str] = []
        timers: list[tuple[str, str, str]] = []
        auto_run: list[tuple[str, str]] = []
        for le in loaded.events:
            ev = le.event
            info = p.info(le.file)
            if ev.name:
                handlers[ev.name].append((le.file, info.handler_names[id(ev)]))
                if ev.repeat_delay is not None and _auto_runs(ev):
                    auto_run.append((ev.name, ev.repeat_delay))
            elif id(ev) in info.block_names:
                method = info.block_names[id(ev)]
                if ev.repeat_delay is not None:
                    timers.append((le.file, method, ev.repeat_delay))
                else:
                    first_think.append(method)
        called: set[str] = set()
        for f in loaded.files:
            called |= p.info(f).called_events
        plan = EventPlan(dict(handlers), called, first_think, timers, auto_run)
        self._plans[key] = plan
        return plan

    def _runs(self, name: str, event: str) -> list[str]:
        return [m for _, m in self.plan(name).handlers.get(event, [])]

    def _events(self, name: str, providers: list[dict[str, list[str]]]) -> list[str]:
        """Every event the class may get a method for, handled or called ones first."""
        plan = self.plan(name)
        events = list(plan.handlers) + sorted(plan.called - plan.handlers.keys())
        seen = set(events)
        for provider in providers:
            for event in provider:
                if event not in seen:
                    seen.add(event)
                    events.append(event)
        return events

    def mixin_declared(self, name: str) -> dict[str, list[str]]:
        """The On<Event> methods a library's mixin declares: event -> the handlers it runs. They are
        what the event runs when the library is included with nothing that changes it."""
        key = normalize(name).lower()
        if key in self._mixin:
            return self._mixin[key]
        # an include cycle sees this file as declaring nothing yet, so its partner declares more
        self._mixin[key] = {}
        p = self.project
        own = p.info(name).name.lower()
        providers = [self.mixin_declared(m) for m in p.load(name).files[1:]]
        result: dict[str, list[str]] = {}
        for event in self._events(name, providers):
            hs = self.plan(name).handlers.get(event, [])
            runs = [m for _, m in hs]
            if not any(f.lower() == own for f, _ in hs):
                provided = next((d[event] for d in providers if event in d), None)
                if provided == runs:
                    continue
            result[event] = runs
        self._mixin[key] = result
        return result

    def class_declared(self, name: str) -> dict[str, list[str]]:
        """The On<Event> methods declared in the body of the file's [script] class."""
        key = normalize(name).lower()
        if key in self._class:
            return self._class[key]
        p = self.project
        own = p.info(name).name.lower()
        is_library = p.is_library(name)
        base = p.base_of(name)
        mixins = [self.mixin_declared(m) for m in p.class_mixins(name)]
        inherited = self.class_resolved(base) if base else {}
        result: dict[str, list[str]] = {}
        for event in self._events(name, mixins + [inherited]):
            hs = self.plan(name).handlers.get(event, [])
            runs = [m for _, m in hs]
            if is_library or not any(f.lower() == own for f, _ in hs):
                provided = next((d[event] for d in mixins if event in d), inherited.get(event))
                if provided == runs:
                    continue
            result[event] = runs
        self._class[key] = result
        return result

    def class_resolved(self, name: str) -> dict[str, list[str]]:
        """Every On<Event> of the file's [script] class, wherever it comes from: event -> handlers."""
        key = normalize(name).lower()
        if key in self._resolved:
            return self._resolved[key]
        p = self.project
        base = p.base_of(name)
        result = dict(self.class_resolved(base)) if base else {}
        for m in reversed(p.class_mixins(name)):
            result.update(self.mixin_declared(m))
        result.update(self.class_declared(name))
        self._resolved[key] = result
        return result

    def dispatched(self, name: str) -> tuple[list[str], list[str]]:
        """The events and timers a library's mixin dispatcher lists: the ones it has handlers for."""
        plan = self.plan(name)
        own = self.project.info(name).name.lower()
        events = sorted(e for e, hs in plan.handlers.items() if any(f.lower() == own for f, _ in hs))
        timers = [m for f, m, _ in plan.timers if f.lower() == own]
        return events, timers

    # -- methods -----------------------------------------------------------------------------

    def event_method(self, event: str, owner: str, runs: list[str], inline: Method | None = None) -> Method:
        """On<Event> running `runs`, then `inline`'s body (the file's own last handler, written into
        the event method itself)."""
        p = self.project
        sig = p.signatures.get(event)
        args = ", ".join(n for _, n in sig.params)
        files = {m: f for f, m in self.plan(owner).handlers.get(event, [])}
        owner_name = p.info(owner).name.lower()
        calls = runs[:-1] if inline is not None else runs
        body: list[Stmt]
        if sig.returns == "string":
            if not calls:
                body = [Return('""')]
            elif len(calls) == 1:
                body = [Return(f"{calls[0]}({args})")]
            else:
                body = [Line('string result = ""')]
                body += [Line(f"result = AppendResult(result, {m}({args}))") for m in calls]
                body.append(Return("result"))
        else:
            body = [Line(f"{m}({args})", trailing=_origin(files.get(m, ""), owner_name)) for m in calls]
        method = Method(sig.method, list(sig.params), sig.returns, body)
        if sig.params:
            method.defaults = {n: missing_param(t, i + 1) for i, (t, n) in enumerate(sig.params)}
        spec = mapping.ENGINE_EVENTS.get(event)
        method.comments = [event + (f" - {spec.doc}" if spec and spec.doc else "")]
        if inline is not None:
            method.body = body + inline.body
            method.comments += inline.comments[1:]
        elif len(calls) <= 1:
            method.compact = True
            method.comments = [event]
            for stmt in body:
                stmt.trailing = ""
        return method

    def mixin_dispatch(self, name: str) -> Method | None:
        events, timers = self.dispatched(name)
        if not events and not timers:
            return None
        body = self._dispatch_lines(events, timers)
        body.append(Return("false"))
        return Method(f"{self.project.class_of(name)}_DispatchEvent",
                      [("const string &in", "name"), ("const array<string> &in", "params")], "bool", body,
                      comments=["This file's events and timers by their .script names"])

    def entity_dispatch(self, name: str) -> Method | None:
        """DispatchEvent of the file's [script] class: its own events, its mixins' dispatchers, then
        its base class's. None when the inherited one already does exactly that."""
        p = self.project
        plan = self.plan(name)
        own = p.info(name).name.lower()
        is_library = p.is_library(name)
        base = p.base_of(name)
        chained = [m for m in p.class_mixins(name) if any(self.dispatched(m))]
        covered_events: set[str] = set()
        covered_timers: set[str] = set()
        for f in p.load(name).files:
            if p.is_library(f):
                events, timers = self.dispatched(f)
                covered_events |= set(events)
                covered_timers |= set(timers)
        events = sorted(e for e, hs in plan.handlers.items()
                        if e not in covered_events or (not is_library and any(f.lower() == own for f, _ in hs)))
        timers = [m for _, m, _ in plan.timers if m not in covered_timers]
        if not events and not timers and not chained:
            return None     # the inherited one already does exactly this
        body = self._dispatch_lines(events, timers)
        calls = [f"{p.class_of(m)}_DispatchEvent(name, params)" for m in chained]
        if base:
            calls.append(f"{p.entity_class_of(base)}::DispatchEvent(name, params)")
        body.append(Return("\n\t\t\t|| ".join(calls) if calls else "false"))
        return Method("DispatchEvent", [("const string &in", "name"), ("const array<string> &in", "params")], "bool", body,
                      comments=["Events and timers by their .script names (engine, callexternal, timers):",
                                "this script's own, then each included file's.",
                                "Variables are reached by their .script names directly (the fields keep those names)."],
                      qualifiers="override")

    def _dispatch_lines(self, events: list[str], timers: list[str]) -> list[Stmt]:
        body: list[Stmt] = []
        for event in events:
            sig = self.project.signatures.get(event)
            args = ", ".join(_param_from_array(t, i) for i, (t, _) in enumerate(sig.params))
            call = f"{sig.method}({args})"
            then: list[Stmt] = [Line(f"Return({call})") if sig.returns == "string" else Line(call), Return("true")]
            body.append(If(TExpr(f"name == {string_literal(event)}", BOOL, 5), then, compact=True))
        for method in timers:
            body.append(If(TExpr(f"name == {string_literal(method)}", BOOL, 5), [Line(f"{method}()"), Return("true")],
                           compact=True))
        return body


def _origin(file: str, owner: str) -> str:
    return file if file and file.lower() != owner else ""


def _param_from_array(t: str, i: int) -> str:
    if t == ENTITY:
        return f"EntityParam(params, {i})"
    if t == PLAYER:
        return f"PlayerParam(params, {i})"
    raw = f"Param(params, {i})"
    return raw if t == STRING else convert(TExpr(raw, STRING), t).code


def _auto_runs(event) -> bool:
    """A named event runs on its own when its repeatdelay comes after its eventname."""
    last = None
    for op in event.load_ops:
        if op.kind in ("eventname", "repeatdelay"):
            last = op.kind
    return last == "repeatdelay"
