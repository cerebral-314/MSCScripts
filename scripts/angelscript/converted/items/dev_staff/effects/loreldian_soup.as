#pragma context server

// Converted from items/dev_staff/effects/loreldian_soup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/dev_staff/effects/loreldian_soup"]
class LoreldianSoup : ScriptEntity
{
	// unnamed block (first think)
	// soup soup soup soup soup soup soup soup soup soup soup soup soup soup soup
	void LoreldianSoup_FirstThink()
	{
		SetLocal("reg.effect.name", "lsoup"); // soup soup soup soup soup soup soup soup
		SetVar(Eval("game.effect.id"), "lsoup"); // dumb variable is required
		SetLocal("reg.effect.flags", "nostack"); // soup soup soup soup soup soup soup soup
		SetLocal("reg.effect.script", "items/dev_staff/effects/loreldian_soup"); // soup soup soup soup soup soup
		// soup soup soup soup soup soup soup soup soup soup soup soup soup soup
		SetVar(Eval("game.effect.removeondeath"), 1); // soup soup soup soup soup soup soup
		// soup soup soup soup soup soup soup soup soup soup soup soup soup soup
		LegacyCommand("registereffect"); // soup soup soup soup soup soup soup soup soup soup soup
	}

	// game_damaged
	// soup soup soup soup soup soup soup soup soup soup soup soup soup soup soup
	string LoreldianSoup_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		return "0";
	}

	// unnamed block (timer)
	void LoreldianSoup_Timer()
	{
		CallEventDelayed(1.0f, "LoreldianSoup_Timer");
		GiveHealth(10000);
		GiveMana(10000);
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return LoreldianSoup_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ext_remove_lsoup
	void OnExtRemoveLsoup()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "LoreldianSoup_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LoreldianSoup_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_remove_lsoup") { OnExtRemoveLsoup(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "LoreldianSoup_Timer") { LoreldianSoup_Timer(); return true; }
		return false;
	}
}
