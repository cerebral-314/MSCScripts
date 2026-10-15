#pragma context server

// Converted from bloodrose/protect_me.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "bloodrose/protect_me"]
class ProtectMe : ScriptEntity
{
	// game_damaged
	string ProtectMe_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// dbg sending alert game_damaged
		CallExternal("all", "npcatk_ally_alert", @EntityOf(ENT_LASTSTRUCK), self, "crystal_hit");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(4000);
		SetRoam(false);
		SetRace("undead");
		SetName("Crystal Shield");
		SetBlood("none");
		SetSkillLevel(0);
		SetModel("null.mdl");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// dbg sending alert game_struck
		CallExternal("all", "npcatk_ally_alert", @EntityOf(ENT_LASTSTRUCK), self, "crystal_hit");
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return ProtectMe_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

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
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		return false;
	}
}
