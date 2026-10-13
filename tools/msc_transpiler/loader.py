"""Replaying CScript::Spawn for one top-level script.

A script's behaviour is its whole include closure, merged in parse order:
#include splices the included file in at that line (each file only once),
#scope leaks across includes, events of the other side are dropped, and
`const` keeps its first definition. This module computes that merged view
("the load") for a leaf script, keeping track of which file each piece came
from so the output can still be organised per file.
"""

from __future__ import annotations

from dataclasses import dataclass, field

from . import engine
from .corpus import Corpus, normalize
from .syntax import Event, Include, LoadOp, ParsedFile, ScopeDirective

SIDE = "server"   # converted scripts currently run on the server only


@dataclass
class LoadedEvent:
    event: Event
    file: str           # the file that defines it
    scope: str          # effective scope after #scope and modifiers
    order: int          # position in the merged event list


@dataclass
class ConstValue:
    name: str
    value: str
    quoted: bool
    file: str
    line: int


@dataclass
class Load:
    leaf: str
    kind: str
    files: list[str] = field(default_factory=list)          # parse order, each once
    includes: dict[str, list[str]] = field(default_factory=dict)  # file -> files it actually pulled in
    events: list[LoadedEvent] = field(default_factory=list)  # kept events (server side), parse order
    consts: dict[str, ConstValue] = field(default_factory=dict)   # winning definitions
    shadowed_consts: list[ConstValue] = field(default_factory=list)  # later definitions that had no effect
    missing_includes: list[tuple[str, str, int]] = field(default_factory=list)  # (includer, target, line)
    overridden: list[LoadedEvent] = field(default_factory=list)   # handlers removed by [override]

    def events_named(self, name: str) -> list[LoadedEvent]:
        return [e for e in self.events if e.event.name == name]


def classify_kind(leaf: str, closure: list[str]) -> str:
    """Which entity type runs this script, which decides the commands it may use."""
    lower = leaf.lower()
    if lower in ("world", "global"):
        return engine.WORLD
    if lower.startswith("items/") or any(f.lower().startswith("items/base_") for f in closure):
        return engine.ITEM
    return engine.MONSTER


def _closure_names(corpus: Corpus, leaf: str) -> list[str]:
    """Include closure using a kind-independent parse (includes don't depend on the kind)."""
    seen: list[str] = []

    def visit(name: str) -> None:
        parsed = corpus.parse(name, engine.WORLD)
        if parsed is None or parsed.name.lower() in (s.lower() for s in seen):
            return
        seen.append(parsed.name)
        for item in parsed.items:
            if isinstance(item, Include) and not item.client_only:
                visit(item.path)

    visit(leaf)
    return seen


def load(corpus: Corpus, leaf: str, kind: str | None = None, kind_for=None) -> Load:
    """kind_for(name) -> kind lets the caller parse every file with one consistent kind
    (the transpiler shares included files between scripts, so it parses each file once)."""
    leaf = normalize(leaf)
    if kind is None:
        kind = classify_kind(leaf, _closure_names(corpus, leaf))
    result = Load(leaf, kind)
    dependencies: list[str] = []
    state = {"scope": "shared"}

    def spawn(name: str, allow_duplicate: bool, includer: str | None) -> bool:
        parsed: ParsedFile | None = corpus.parse(name, kind_for(name) if kind_for else kind)
        if parsed is None:
            return False
        if not allow_duplicate and any(d.lower() == parsed.name.lower() for d in dependencies):
            return True
        dependencies.append(parsed.name)
        if parsed.name not in result.files:
            result.files.append(parsed.name)
        result.includes.setdefault(parsed.name, [])
        if includer is not None and parsed.name not in result.includes[includer]:
            result.includes[includer].append(parsed.name)

        state["scope"] = "shared"   # CScript::Spawn resets DefaultScope; it is not restored afterwards
        for item in parsed.items:
            if isinstance(item, ScopeDirective):
                state["scope"] = item.scope
            elif isinstance(item, Include):
                if item.client_only and SIDE == "server":
                    continue
                if item.server_only and SIDE != "server":
                    continue
                target = _resolve_include_name(item.path, result)
                if not spawn(target, item.allow_duplicate, parsed.name) and not item.casual:
                    result.missing_includes.append((parsed.name, item.path, item.line))
            elif isinstance(item, Event):
                scope = item.explicit_scope or state["scope"]
                if scope == "client" and SIDE == "server":
                    continue
                _apply_load_ops(result, item, parsed.name)
                if item.override and item.name:
                    # [override] erases every earlier event with this name (ParseLine)
                    result.overridden.extend(e for e in result.events if e.event.name == item.name)
                    result.events = [e for e in result.events if e.event.name != item.name]
                result.events.append(LoadedEvent(item, parsed.name, scope, len(result.events)))
        return True

    if not spawn(leaf, False, None):
        raise FileNotFoundError(leaf)
    return result


def _resolve_include_name(path: str, result: Load) -> str:
    """#include paths are const-substituted; a const used as a path is resolved with the current table."""
    const = result.consts.get(path)
    return normalize(const.value if const else path)


def _apply_load_ops(result: Load, event: Event, file: str) -> None:
    for op in event.load_ops:
        if op.kind == "const":
            value = ConstValue(op.name, op.value, op.quoted, file, op.line)
            if op.name in result.consts:
                result.shadowed_consts.append(value)
            else:
                result.consts[op.name] = value
        elif op.kind == "removeconst":
            result.consts.pop(op.name, None)
