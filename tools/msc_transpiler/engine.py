"""What the MS-Script interpreter knows: command and $function tables per entity kind.

Loaded from data/engine_tables.json (refresh with extract_engine_tables.py).
"""

from __future__ import annotations

import json
from functools import cache
from pathlib import Path

DATA = Path(__file__).parent / "data" / "engine_tables.json"

# Entity kinds whose IScripted::Script_ParseLine adds commands to the global set
MONSTER = "monster"   # CMSMonster and CBasePlayer (npcscript.cpp)
ITEM = "item"         # CGenericItem (genericitem.cpp)
WORLD = "world"       # world/global scripts and other entities without their own commands
KINDS = (MONSTER, ITEM, WORLD)


@cache
def tables() -> dict:
    return json.loads(DATA.read_text(encoding="utf-8"))


@cache
def global_commands() -> dict[str, bool]:
    return {name: info["conditional"] for name, info in tables()["global_commands"].items()}


@cache
def entity_commands(kind: str) -> dict[str, bool]:
    if kind == MONSTER:
        return {name.lower(): cond for name, cond in tables()["monster_commands"].items()}
    if kind == ITEM:
        return {name.lower(): cond for name, cond in tables()["item_commands"].items()}
    return {}


def entity_lookup(kind: str):
    commands = entity_commands(kind)

    def lookup(name: str) -> tuple[bool, bool]:
        key = name.lower()
        return (True, commands[key]) if key in commands else (False, False)

    return lookup


def is_known_command(name: str, kind: str) -> bool:
    return name in global_commands() or name.lower() in entity_commands(kind)


@cache
def functions() -> dict[str, str]:
    return tables()["functions"]
