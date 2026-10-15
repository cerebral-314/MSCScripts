#pragma context server

// Converted from ms_soccer/goal_blue_ref.script by msc_transpiler.
// lets NPC's know where the blue goal is

#include "runtime/ScriptEntity.as"

[script "ms_soccer/goal_blue_ref"]
class GoalBlueRef : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("null.mdl");
		SetWidth(3);
		SetHeight(3);
		SetGravity(0);
		SetNoPush(true);
		SetInvincible(true);
		SetUniqueName("blue_goal_ref");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
