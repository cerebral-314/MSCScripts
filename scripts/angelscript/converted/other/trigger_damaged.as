#pragma context server

// Converted from other/trigger_damaged.script by msc_transpiler.
// This no workie

#include "runtime/ScriptEntity.as"

[script "other/trigger_damaged"]
class TriggerDamaged : ScriptEntity
{
	// game_damaged
	string TriggerDamaged_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		DebugPrint("game_damaged " + EntityId(attacker) + " " + Text(damage) + " " + damageType + " " + Text(accuracyRoll));
		return result;
	}

	// game_takedamage
	string TriggerDamaged_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		DebugPrint("game_takedamage " + EntityId(attacker) + " " + EntityId(inflictor) + " " + Text(damage) + " " + damageType);
		return result;
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return TriggerDamaged_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return TriggerDamaged_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DebugPrint("game_struck " + Text(damage) + " " + extraValue2 + " " + extraValue3 + " " + extraValue4);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DebugPrint("game_death " + attacker + " " + extraValue2 + " " + extraValue3 + " " + extraValue4);
	}

	// ext_test
	void OnExtTest(string value = "", string value2 = "", string value3 = "", string value4 = "")
	{
		DebugPrint("ext_test " + value + " " + value2 + " " + value3 + " " + value4);
	}

	// ext_report
	void OnExtReport()
	{
		DebugPrint(Text(MyOrigin()));
	}

	// ext_follow
	void OnExtFollow(string target = "")
	{
		LegacyCommand("setfollow", target, "align_bottom");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_follow") { OnExtFollow(Param(params, 0)); return true; }
		if (name == "ext_report") { OnExtReport(); return true; }
		if (name == "ext_test") { OnExtTest(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		return false;
	}
}
