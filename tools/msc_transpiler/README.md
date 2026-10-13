# msc_transpiler — MS-Script → AngelScript

Converts `.script` files into readable AngelScript that runs on the engine's AngelScript entity host
(`CASEntityScript`, see `MasterSwordRebirth/docs/ANGELSCRIPT_ENTITY_SCRIPTS.md`). Converted scripts and
unconverted ones keep working together: events, `callexternal` and `$get(x,scriptvar,…)` still go by
`.script` names, and every command runs through the engine's own handler.

Requires Python 3.10+ (standard library only). Run from `MSCScripts/tools`:

```bash
python -m msc_transpiler convert items/base_ticket          # one script and the files it includes
python -m msc_transpiler convert --family monsters/base_npc # every script that includes base_npc
python -m msc_transpiler convert --all                      # the whole scripts folder
python -m msc_transpiler report --all > quirks.txt          # legacy quirks found while converting
python -m msc_transpiler runtime                            # regenerate runtime/Commands.as, Functions.as
python -m unittest discover -s msc_transpiler/tests -t .    # tests
```

Output goes to `scripts/angelscript/converted/<same path>.as` (override with `--out`). The engine only
uses a converted file when the server runs with `as_entity_scripts 1` in an `MSR_ANGELSCRIPT=ON` build.

## Checking the output compiles

`utils/as_check` (MasterSwordRebirth) compiles scripts against the engine's real interface without
starting a server:

```bash
python -m msc_transpiler convert --all --list converted.txt
as_check --config <MasterSwordRebirth>/utils/as_check/config/as_config_server.txt \
         --root ../scripts/angelscript --quiet --list converted.txt
```

Every converted file has a `[script "…"]` class, so the check compiles all of them. `check` keeps the
modules of one process alive, as the game does, so the shared classes are compiled once.

## What the output looks like

| .script | AngelScript |
|---|---|
| A file other scripts `#include` | `mixin class BaseNpc { … }` — its variables and handlers (`BaseNpc_OnGameSpawn()`) — and `[script "monsters/base_npc"] shared class BaseNpcScript : ScriptEntity, BaseNpc, …` |
| A file nothing includes | `[script "monsters/orc_flayer"] class OrcFlayer : OrcBaseScript, …` |
| `{ game_spawn … }` | `void OnGameSpawn()` calling every included file's handler in the engine's order, then its own body |
| `const X 5` / `setvard X 1` | field `int X = 5;` / `X = 1;` — names stay as in .script |
| `local L_ITEM PARAM2` | parameter or local `item` (camelCase, `L_` dropped) |
| `if ( A equals B )` / `else if` | `if (A == B)` / `else if` |
| `if X` (no parentheses) | early `return` at the top of a handler, otherwise wraps the rest of its block |
| `callevent 1.0 ev` / `callevent ev a b` | `CallEventDelayed(1.0f, "ev")` / `OnEv(a, b)` |
| `$get(ent,hp)`, `$rand(1,5)` | `HealthOf(ent)`, `RandomInt(1, 5)` |
| commands | typed wrappers (`SetName("Bertold")`, `PlaySound(…)`) or `LegacyCommand("cmd", {…})` |

### Classes

Every file has a `[script "…"]` class: what the engine creates when that script spawns.

* A library's is `shared`, so AngelScript compiles it once and every script module uses that copy.
  It is what spawns when the library itself is spawned (`monsters/orc_base` is both spawned and
  included), and it is the base class of the scripts that include the library.
* A class derives from the shared class of its biggest include whose own includes are all part of
  this script's, and mixes in the rest of its files. Library code is therefore compiled once per
  server instead of once per script: a monster that shares its include stack with others compiles in
  about a third of the time it took with mixins alone.
* Fields it inherits are not declared again. Where this script's include order gives one a different
  starting value (a constant this script defines first, for example), the constructor sets it.

### Engine wiring

Each class ends with a generated section that connects it to the engine:

* A library's mixin declares each event method as it runs in a script that includes the library
  (`void OnGameSpawn() { BaseNpc_OnGameSpawn(); }`) and a `BaseNpc_DispatchEvent` for its own events.
* A class gets each event method from its own body, else the first of its mixins that declares it
  (AngelScript keeps the first mixin's method, and a mixin's method overrides an inherited one), else
  its base class. It declares one only where that would run something else in this script.
* `OnLoad` (precaching, timers), `OnFirstThink` (unnamed blocks) and `DispatchEvent` (its own events
  by `.script` name, then each mixin's dispatcher, then the base class's) appear where they differ from
  what the class inherits.

Variables need no generated code: the engine reads and writes fields by name, and the fields keep
their `.script` names.

Text keeps its bytes: scripts are Latin-1, and string constants write anything outside printable
ASCII as `\xHH`, which AngelScript stores as that exact byte.

## How it works

| Module | Role |
|---|---|
| `source.py`, `parser.py`, `syntax.py` | Port of `CScript::ParseScriptFile`/`ParseLine`, quirks included |
| `loader.py` | Port of `CScript::Spawn` for one script: include order, `#scope` leaks, `[override]`, first-wins `const` |
| `infer.py` | Picks a type per variable (int/float/bool/string/Vector3) from how the whole corpus uses it |
| `lower.py`, `ir.py`, `emit.py` | One handler → one method, with `Script_ExecuteCmds` control flow and readable output |
| `values.py`, `context.py` | Typed values and the interpreter's implicit conversions; per-file context and event signatures |
| `generate.py` | Files → mixins, fields, handlers, load-time work |
| `entity.py` | Each file's `[script]` class: its base class, mixins, inherited fields and constructor |
| `wiring.py` | Which event methods each class declares, what they run, dispatch by `.script` name |
| `mapping.py` | Commands, `$functions`, `$get` properties, engine events → AngelScript (single source of truth) |
| `runtime_gen.py` | Writes `runtime/Commands.as` and `runtime/Functions.as` from `mapping.py` |
| `extract_engine_tables.py` | Refreshes `data/engine_tables.json` (which commands each entity type accepts) from the C++ |

The runtime the output relies on lives in `scripts/angelscript/runtime/`: `ScriptEntity.as` (base class),
`Legacy.as` (text/number conversions and token lists that behave like the interpreter), and the two
generated wrapper files. All of it is `shared`, because the libraries' shared classes call it.

## Making the output more readable

* Add a command, `$function` or `$get` property to `mapping.py`, run `runtime`, then `convert` again.
  Unmapped ones stay correct as `LegacyCommand(...)` / `LegacyFunction(...)`.
* Add an engine event to `mapping.ENGINE_EVENTS` to give its parameters names and types.
* Parameter names otherwise come from `local L_NAME PARAMn` lines or from event header comments
  (`{ give_item //PARAM1 = PlayerID PARAM2 = ItemID`).

## Legacy quirks

Faithful conversion keeps what the old scripts actually did, including mistakes. `report` lists them
(for example `return **clear**` adding text instead of clearing, conditions on variables nothing ever
sets, unknown commands the engine silently dropped) so someone can decide whether to fix the behaviour.
