#pragma context server

// Converted from developer/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/helena/game_master.as"
#include "converted/old_helena/game_master.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DeveloperGameMaster
{
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "developer/game_master"]
shared class DeveloperGameMasterScript : HelenaGameMasterScript, DeveloperGameMaster, OldHelenaGameMaster
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OldHelenaGameMaster_DispatchEvent(name, params)
			|| HelenaGameMasterScript::DispatchEvent(name, params);
	}
}
