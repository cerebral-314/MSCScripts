#pragma context server

// Converted from slithar/lure_tele.script by msc_transpiler.
// is that he would get to half health - then jump across that bridge thingie thats visible from outside, and teleport up onto a platform.

#include "runtime/ScriptEntity.as"

[script "slithar/lure_tele"]
class LureTele : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool MADE_IT = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("null.mdl");
		SetSolid("none");
		SetInvincible(true);
		SetRace("beloved");
		// dbg spawned, starting loop
		CallEventDelayed(0.1f, "slithar_run_loop");
		CallEventDelayed(10.0f, "slithar_cant_make_it");
	}

	// slithar_run_loop
	void OnSlitharRunLoop()
	{
		if (MADE_IT)
			return;

		CallEventDelayed(0.5f, "slithar_run_loop");

		// //dbg spawned, sending command to slithar
		CBaseEntity@ slitharId = FindByName("snake_lord");
		float slitharRange = RangeTo(slitharId);
		Vector3 myPos = MyOrigin();
		CBaseEntity@ myId = self;

		if (MADE_IT)
			return;

		CallExternal(slitharId, "slithar_to_me", myPos, slitharRange, @myId);
	}

	// slithar_made_it
	void OnSlitharMadeIt()
	{
		MADE_IT = true;
		SetAlive(false);
		DeleteEntity(ENT_ME);
	}

	// slithar_cant_make_it
	void OnSlitharCantMakeIt()
	{
		// createnpc slithar/teleport $relpos(0,0,0) - no idear why this no work (crashes)
		// callevent 0.1 slithar_made_it
		if (MADE_IT)
			return;
		MADE_IT = true;
		OnTeleSlithar();
	}

	// tele_slithar
	void OnTeleSlithar()
	{
		SetUniqueName("slithar_lure");
		CBaseEntity@ slitharName = FindByName("snake_lord");
		CBaseEntity@ slitharId = slitharName;
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
		if (name == "slithar_cant_make_it") { OnSlitharCantMakeIt(); return true; }
		if (name == "slithar_made_it") { OnSlitharMadeIt(); return true; }
		if (name == "slithar_run_loop") { OnSlitharRunLoop(); return true; }
		if (name == "tele_slithar") { OnTeleSlithar(); return true; }
		return false;
	}
}
