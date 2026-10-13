"""Snapshot the MS-Script command and $function tables from the engine source.

The interpreter silently drops commands it doesn't know, and which commands it
knows depends on the entity type (monsters/players vs. items). The transpiler
needs the same view, so it reads the tables straight from the C++ source:

    python -m msc_transpiler.extract_engine_tables <MasterSwordRebirth>/src

writes msc_transpiler/data/engine_tables.json.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

GLOBAL_CMD = re.compile(r'm_GlobalCmdHash\["([^"]+)"\]\s*=\s*scriptcmdscpp_cmdfunc_t\(&CScript::(\w+)(\s*,\s*true)?')
GETTER = re.compile(r'm_GlobalGetterHash\["([^"]+)"\]\s*=\s*scriptcpp_cmdfunc_t\(&CScript::(\w+)')
ENTITY_CMD = re.compile(r'scriptcmdname_t\(\s*"([^"]+)"\s*(,\s*true)?\s*\)')


def _active_lines(text: str) -> str:
    """Drop // comments so commented-out registrations are ignored."""
    return "\n".join(line.split("//", 1)[0] for line in text.splitlines())


def _entity_commands(path: Path) -> dict[str, bool]:
    commands: dict[str, bool] = {}
    for name, conditional in ENTITY_CMD.findall(_active_lines(path.read_text(encoding="latin-1"))):
        commands[name] = bool(conditional)
    return commands


def extract(src: Path) -> dict:
    scriptcmds = _active_lines((src / "game/shared/ms/scriptcmds.cpp").read_text(encoding="latin-1"))
    script = _active_lines((src / "game/shared/ms/script.cpp").read_text(encoding="latin-1"))

    global_commands = {name: {"handler": handler, "conditional": bool(cond)}
                       for name, handler, cond in GLOBAL_CMD.findall(scriptcmds)}
    functions = {name: handler for name, handler in GETTER.findall(script)}

    return {
        "source": "extracted from game/shared/ms/scriptcmds.cpp, script.cpp, "
                  "game/server/monsters/npcscript.cpp, game/shared/weapons/genericitem.cpp",
        "global_commands": dict(sorted(global_commands.items())),
        "monster_commands": dict(sorted(_entity_commands(src / "game/server/monsters/npcscript.cpp").items())),
        "item_commands": dict(sorted(_entity_commands(src / "game/shared/weapons/genericitem.cpp").items())),
        "functions": dict(sorted(functions.items())),
    }


def main(argv: list[str]) -> int:
    if len(argv) != 1:
        print(__doc__)
        return 2
    tables = extract(Path(argv[0]))
    out = Path(__file__).parent / "data" / "engine_tables.json"
    out.parent.mkdir(exist_ok=True)
    out.write_text(json.dumps(tables, indent=1) + "\n", encoding="utf-8")
    print(f"{out}: {len(tables['global_commands'])} global, {len(tables['monster_commands'])} monster, "
          f"{len(tables['item_commands'])} item commands, {len(tables['functions'])} $functions")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
