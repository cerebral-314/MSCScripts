"""Naming conventions for generated AngelScript.

- Script variables and constants keep their .script names (MODEL_WORLD, NPC_FRIENDLY): they
  are the names other scripts and the engine use to reach them, and readers know them.
- Locals and parameters become camelCase without the L_ prefix (L_SUBMODEL -> submodel).
- Events become methods named On<Event> (game_spawn -> OnGameSpawn); a library file's own
  handler for an event is prefixed with the file's class name (BaseNpc_OnGameSpawn).
- Each file becomes a class named after the file (monsters/base_npc -> BaseNpc).
"""

from __future__ import annotations

import re

AS_KEYWORDS = {
    "and", "abstract", "auto", "bool", "break", "case", "cast", "catch", "class", "const", "continue",
    "default", "do", "double", "else", "enum", "explicit", "external", "false", "final", "float", "for",
    "from", "funcdef", "function", "get", "if", "import", "in", "inout", "int", "interface", "int8",
    "int16", "int32", "int64", "is", "mixin", "namespace", "not", "null", "or", "out", "override",
    "private", "property", "protected", "return", "set", "shared", "super", "switch", "this", "true",
    "try", "typedef", "uint", "uint8", "uint16", "uint32", "uint64", "void", "while", "xor", "string",
    "array", "dictionary", "self", "host",
}

# Methods ScriptEntity already defines; event methods must not collide with them
RESERVED_METHODS = {"OnLoad", "OnFirstThink", "Attach", "DispatchEvent", "CallEvent", "CallEventDelayed", "CallExternal", "Return", "LegacyCommand", "LegacyFunction"}

_WORD = re.compile(r"[A-Za-z0-9]+")


def words(name: str) -> list[str]:
    return _WORD.findall(name)


def pascal(name: str) -> str:
    result = "".join(w[:1].upper() + w[1:].lower() if w.isupper() or w.islower() else w[:1].upper() + w[1:]
                     for w in words(name))
    if not result:
        result = "Unnamed"
    if result[0].isdigit():
        result = "_" + result
    return result


def camel(name: str) -> str:
    p = pascal(name)
    result = p[:1].lower() + p[1:]
    return result + "_" if result in AS_KEYWORDS else result


def is_identifier(name: str) -> bool:
    return re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", name) is not None


def variable(name: str) -> str:
    """A script variable / constant: keeps its .script name when it is a valid identifier."""
    if is_identifier(name) and name not in AS_KEYWORDS:
        return name
    cleaned = re.sub(r"[^A-Za-z0-9_]", "_", name)
    if not cleaned or cleaned[0].isdigit():
        cleaned = "_" + cleaned
    return cleaned + ("_" if cleaned in AS_KEYWORDS else "")


def local(name: str) -> str:
    """L_ITEM_NAME -> itemName, OUT_MSG -> outMsg."""
    stripped = re.sub(r"^(l|local)[_.]", "", name, flags=re.I)
    return camel(stripped or name)


def event_method(event: str) -> str:
    # game_+attack2 / game_-attack2 are the press and release of +attack2
    event = re.sub(r"\+(?=\w)", "press_", event)
    event = re.sub(r"(?<=[_\W])-(?=\w)|^-(?=\w)", "release_", event)
    method = "On" + pascal(event)
    return method + "Event" if method in RESERVED_METHODS else method


def class_name(script: str) -> str:
    """monsters/orc_flayer -> OrcFlayer."""
    return pascal(script.replace("\\", "/").split("/")[-1])


def unique_class_names(scripts: list[str], reserved: set[str] = frozenset()) -> dict[str, str]:
    """File stems are not unique across folders (edana/fletcher, helena/fletcher), and some are
    the names of engine functions (chests/quest and Quest()): prefix the folder for those so every
    file gets one stable class name."""
    by_stem: dict[str, list[str]] = {}
    for script in scripts:
        by_stem.setdefault(class_name(script).lower(), []).append(script)
    names = {}
    for script in scripts:
        base = class_name(script)
        if len(by_stem[base.lower()]) > 1 or base in reserved:
            parts = script.replace("\\", "/").split("/")
            base = "".join(pascal(p) for p in parts)
        names[script.lower()] = base
    return names
