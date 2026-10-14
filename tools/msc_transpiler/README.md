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
python -m msc_transpiler runtime                            # regenerate runtime/LegacyApi.txt
python -m unittest discover -s msc_transpiler/tests -t .    # tests
```

Output goes to `scripts/angelscript/converted/<same path>.as` (override with `--out`). The engine only
uses a converted file when the server runs with `as_entity_scripts 1` in an `MSR_ANGELSCRIPT=ON` build.

## Checking the output compiles

`utils/as_check` (MasterSwordRebirth) compiles scripts against the engine's real interface without
starting a server:

```bash
python -m msc_transpiler convert --all
python -m msc_transpiler check --as-check <MasterSwordRebirth>/utils/build/as_check/Release/as_check.exe \
         --config <MasterSwordRebirth>/utils/as_check/config/as_config_server.txt --jobs 12
```

Every converted file has a `[script "…"]` class, so the check compiles all of them. `check` passes
`runtime/LegacyApi.txt` to as_check (`--api`), and keeps the modules of one process alive, as the game
does, so the shared classes are compiled once.

## What the output looks like

| .script | AngelScript |
|---|---|
| A file other scripts `#include` | `mixin class BaseNpc { … }` — its variables and handlers (`BaseNpc_OnGameSpawn()`) — and `[script "monsters/base_npc"] shared class BaseNpcScript : ScriptEntity, BaseNpc, …` |
| A file nothing includes | `[script "monsters/orc_flayer"] class OrcFlayer : OrcBaseScript, …` |
| `{ game_spawn … }` | `void OnGameSpawn()` calling every included file's handler in the engine's order, then its own body |
| `const X 5` / `setvard X 1` | field `int X = 5;` / `X = 1;` — names stay as in .script |
| `setvard STEP 359` then `divide STEP N` | `STEP = Divide(359.0f, N);` — step-by-step updates folded into one expression |
| `add COUNT 1` on a name nothing else sets | field `COUNT`, `COUNT += 1.0f;` (math commands store a script variable) |
| blank lines between commands | kept, so the source's grouping survives |
| a local used as a count, then as a message | two locals: `int nNpcs` for the tests and `string nNpcsText` for the message |
| a variable only ever read as a number | a number (`int handpref = Int(GetProp(item, "handpref"))`), whatever text it is assigned |
| `local L_ITEM PARAM2` | parameter or local `item` (camelCase, `L_` dropped) |
| `if ( A equals B )` / `else if` | `if (A == B)` / `else if` |
| `if X` (no parentheses) | early `return` at the top of a handler, otherwise wraps the rest of its block |
| `callevent 1.0 ev` / `callevent ev a b` | `CallEventDelayed(1.0f, "ev")` / `OnEv(a, b)` |
| `calleventloop $get_token_amt(L) ev` | `int count = GetTokenCount(L); for (int i = 0; i < count; i++) { loopIteration = i; OnEv(); }` |
| `$get(ent,hp)`, `$rand(1,5)` | `HealthOf(ent)`, `RandomInt(1, 5)` |
| an entity the engine passes (`game_damaged`'s attacker, a menu item's player) | `CBaseEntity@ attacker`, `CBasePlayer@ player` |
| `$get(ent_me,id)` / `$get(PARAM1,id)` / `if ( PARAM1 equals $get(ent_me,id) )` | `self` / `attacker` / `if (attacker is self)` |
| commands | `SetName("Bertold")`, `SetHealth(400)`, `Effect("glow", ENT_ME, Vector3(0, 255, 0), 96, 1, 1)`, or `LegacyCommand("cmd", a, b)` |

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

### Entities and players

An entity is text in `.script`: its id, `PentP(idx,addr)`. Where the value is certainly an entity, the
output uses a handle instead:

* Parameters the engine fills with an entity: the entity parameters of `mapping.ENGINE_EVENTS`
  (`CBaseEntity@ attacker`), and players where the engine only ever passes one (`game_playerused`,
  `game_menu_getoptions`, … : `CBasePlayer@ player`).
* Menu item callbacks (`local reg.mitem.callback confirm_forget_spell`): the engine passes the player
  and the item's data, so `void OnConfirmForgetSpell(CBasePlayer@ player, int spellIndex)` takes the
  type of what the menu stores in `reg.mitem.data`.
* `$get(x,id)`, `$get(x,owner)`, `$get(x,target)`, `$get_by_name(...)`; `$get(ent_me,id)` is `self`.
* Parameters, locals and fields that only ever hold such entities and are never compared with text
  (an event's parameter only when every caller passes an entity), and fields set only from parameters
  take those parameters' type (`SPELL_TO_FORGET_IDX = spellIndex` is an `int`).

A handle is assigned with `@x = y` and compared with `is` (`attacker is self`, `target !is null`: "0" is
what the engine gives for no entity). Where text is needed it is `EntityId(x)`, the same id `.script`
had (`"0"` for none); text becomes an entity with `FindEntity(text)` (an id or a name such as
`ent_lastseen`, looked up then). The engine's entity parameters come as handles (`NameOf(player)`); a
handle passed where any value goes is written `@x`, so a null one passes as none. `ENT_LASTSEEN` and the
other `ent_*` names stay names: the engine resolves them when they are used, as in `.script`.

### Commands and $functions

`runtime_gen.py` writes `runtime/LegacyApi.txt`: one line per command, `$function`, `$get` property and
`game.*` value, each a declaration and the legacy handler it runs:

    void PlaySound(int channel, const ?&in ...) | command playsound {1} {...}
    float HealthOf(const ?&in entity) | function get {1} hp

The engine registers every line as a global function that converted scripts call directly. It passes
one argument per `.script` token to the same C++ handler the interpreter uses, written as `.script`
text, so numbers, vectors and entities go in as they are (`Effect("glow", ENT_ME, Vector3(0, 255, 0), 96,
1, 1)` runs `effect glow ent_me (0,255,0) 96 1 1`). `const ?&in` takes a value of any type; `...` takes
any number of them. Commands whose handler joins its trailing words itself (`name`, `desc`, the message
commands) take that text as one string; every other command gets each token separately, as
in `.script`.

`calleventloop` becomes a `for` loop over a local index. Each run sees its index as `loopIteration`
(`game.script.iteration`); the count is taken once, before the first run; a loop inside another one puts
the outer index back afterwards, and `breakloop` (`breakLoop = true`) stops the loop that runs it — all as
the engine does.

Text keeps its bytes: scripts are Latin-1, and string constants write anything outside printable
ASCII as `\xHH`, which AngelScript stores as that exact byte.

## How it works

| Module | Role |
|---|---|
| `source.py`, `parser.py`, `syntax.py` | Port of `CScript::ParseScriptFile`/`ParseLine`, quirks included |
| `loader.py` | Port of `CScript::Spawn` for one script: include order, `#scope` leaks, `[override]`, first-wins `const` |
| `infer.py` | Picks a type per variable (int/float/bool/string/Vector3/entity) from how the whole corpus uses it |
| `lower.py`, `ir.py`, `emit.py` | One handler → one method, with `Script_ExecuteCmds` control flow and readable output |
| `updates.py` | Commands that set a variable (assignments, math, text, vector, token) |
| `calls.py` | Events calling events: `callevent`, `calleventloop`, `callexternal`, `$func`, `return` |
| `split.py` | Locals used as a number and as text: split into the number and its text |
| `values.py`, `context.py` | Typed values and the interpreter's implicit conversions; per-file context and event signatures |
| `generate.py` | Files → mixins, fields, handlers, load-time work |
| `entity.py` | Each file's `[script]` class: its base class, mixins, inherited fields and constructor |
| `wiring.py` | Which event methods each class declares, what they run, dispatch by `.script` name |
| `mapping.py` | Commands, `$functions`, `$get` properties, engine events → AngelScript (single source of truth) |
| `runtime_gen.py` | Writes `runtime/LegacyApi.txt` (the engine API table) from `mapping.py` |
| `extract_engine_tables.py` | Refreshes `data/engine_tables.json` (which commands each entity type accepts) from the C++ |

The runtime the output relies on lives in `scripts/angelscript/runtime/`: `ScriptEntity.as` (base class),
`Legacy.as` (text/number conversions and token lists that behave like the interpreter), both `shared`
because the libraries' shared classes call them, and the generated `LegacyApi.txt`.

## Making the output more readable

* Add a command, `$function` or `$get` property to `mapping.py`, run `runtime`, then `convert` again.
  Unmapped ones stay correct as `LegacyCommand("name", ...)` / `LegacyFunction("name", ...)`.
  A command's trailing `text` parameter is joined into one string (only for commands whose handler
  joins its words); `...` passes each remaining token as its own argument.
* Add an engine event to `mapping.ENGINE_EVENTS` to give its parameters names and types.
* Every other event's parameter names are in `data/param_names.json` (`{"gold_spew": {"1": "goldPerBag", …}}`).
  They were written by a language model from each parameter's comments, the lines that use it and the
  calls that pass it, then reviewed for names that contradicted those uses. Edit the file by hand to
  rename a parameter; a name missing there falls back to the `local L_NAME PARAMn` copies or the
  event's header comment (`{ give_item //PARAM1 = PlayerID PARAM2 = ItemID`).
* A parameter the caller did not pass reads as its own name in .script (`"PARAM4"`), which scripts
  test with `if ( X equals 'PARAM4' )` or `if ( X startswith PARAM )`. Converted parameters default to
  `""` instead, and those tests become `if (x.isEmpty())`.

## Legacy quirks

Faithful conversion keeps what the old scripts actually did, including mistakes. `report` lists them
(for example `return **clear**` adding text instead of clearing, conditions on variables nothing ever
sets, unknown commands the engine silently dropped) so someone can decide whether to fix the behaviour.
