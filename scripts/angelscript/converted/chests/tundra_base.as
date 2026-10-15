#pragma context server

// Converted from chests/tundra_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TundraBase
{

	// game_spawn
	void TundraBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// name Treasure Chest
		LegacyCommand("add", "G_GAVE_ARTI1", 1);

		OnTcAddArtifact("blunt_staff_i", Float(GetVar("G_GAVE_ARTI1")) * 1.0f);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		TundraBase_OnGameSpawn(playerRace, playerGender);
	}

	// This file's events and timers by their .script names
	bool TundraBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/tundra_base"]
shared class TundraBaseScript : BaseTreasurechestScript, TundraBase
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return TundraBase_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
