#pragma context server

// Converted from other/make_mons_dumb.script by msc_transpiler.
// Thothis - this script is used to prevent BD monsters when too many monsters that block each other's vision appear in one place
// - this has the following effects:
// - less lag reduction - once monsters cycle to 0.1 - they never revert
// - monsters will not go to last spotted location when player goes out of sight
// - monsters will not initiate advanced searches, at all
// - monsters will not change FOV when struck
// - monsters will not change FOV when spotting a player
// -
// - basically, aside from the STUCK checking, monster behavior will be the same as the January SC.DLL

#include "runtime/ScriptEntity.as"

[script "other/make_mons_dumb"]
class MakeMonsDumb : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// dbg Setting monsters to Stupid
		SetGlobal("NO_ADVANCED_SEARCHES", 1);
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
