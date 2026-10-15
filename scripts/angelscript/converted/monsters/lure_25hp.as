#pragma context server

// Converted from monsters/lure_25hp.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/lure.as"

[script "monsters/lure_25hp"]
class Lure25hp : OtherLureScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OtherLure_OnGameSpawn(playerRace, playerGender); // other/lure
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc

		SetHealth(25);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return OtherLureScript::DispatchEvent(name, params);
	}
}
