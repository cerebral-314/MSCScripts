#pragma context server

// Converted from slithar/teleport.script by msc_transpiler.
// is that he would get to half health - then jump across that bridge thingie thats visible from outside, and teleport up onto a platform.

#include "runtime/ScriptEntity.as"

[script "slithar/teleport"]
class Teleport : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("slithar_lure");

		SetModel("null.mdl");
		SetInvincible(true);
		SetRace("beloved");
		SetFly(true);
		LegacyCommand("float", 1);
		SetGravity(0);
		CallEventDelayed(0.1f, "lure_slithar");
	}

	// lure_slithar
	void OnLureSlithar()
	{
		// dbg spawned, sending command to slithar
		CBaseEntity@ slitharId = FindByName("snake_lord");
		CallExternal(slitharId, "slithar_escape");
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
		if (name == "lure_slithar") { OnLureSlithar(); return true; }
		return false;
	}
}
