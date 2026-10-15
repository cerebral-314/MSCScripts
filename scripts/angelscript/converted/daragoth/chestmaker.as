#pragma context server

// Converted from daragoth/chestmaker.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "daragoth/chestmaker"]
class DaragothChestmaker : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		int rand = RandomInt(0, 5);
		if (rand == 0)
			CreateNpc("daragoth/chest_great", OriginOf(ENT_ME));
		if (rand != 0)
			CreateNpc("daragoth/chest_good", OriginOf(ENT_ME));

		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
