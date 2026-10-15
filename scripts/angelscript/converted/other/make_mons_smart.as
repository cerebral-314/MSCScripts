#pragma context server

// Converted from other/make_mons_smart.script by msc_transpiler.
// Thothis - this script is used to revert from the effects of make_mons_dumb
// - Can be used if you have a monster flooded area, you know the players will leave

#include "runtime/ScriptEntity.as"

[script "other/make_mons_smart"]
class MakeMonsSmart : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// dbg Settings monsters to Smart
		SetGlobal("NO_ADVANCED_SEARCHES", 0);
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
