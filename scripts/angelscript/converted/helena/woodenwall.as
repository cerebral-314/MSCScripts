#pragma context server

// Converted from helena/woodenwall.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "helena/woodenwall"]
class Woodenwall : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(300);
		SetRoam(false);
		SetName("Wooden Wall");
		SetBlood("none");
		SetSkillLevel(0);
		SetDamageTaken("fire", 2);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DeleteMe();
		Effect("tempent", "gibs", "woodgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1, 5, 15, 20, 5);
	}

	// hit_by_siege
	void OnHitBySiege()
	{
		OnGameDeath();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("woodgibs.mdl");
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
