#pragma context server

// Converted from helena/structure.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "helena/structure"]
class Structure : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(300);
		SetInvincible(true);
		SetRoam(false);
		SetName("Stone Wall");
		SetDamageTaken("siege", 1);
		SetBlood("none");
		SetSkillLevel(0);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DeleteMe();
		Effect("tempent", "gibs", "cindergibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1, 5, 15, 20, 5);
	}

	// hit_by_siege
	void OnHitBySiege()
	{
		SetInvincible(false);
		DeleteMe();
		Effect("tempent", "gibs", "cindergibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1, 5, 15, 20, 5);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("cindergibs.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "hit_by_siege") { OnHitBySiege(); return true; }
		return false;
	}
}
