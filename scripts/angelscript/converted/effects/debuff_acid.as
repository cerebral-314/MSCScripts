#pragma context server

// Converted from effects/debuff_acid.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff.as"

[script "effects/debuff_acid"]
class DebuffAcid : BaseDebuffScript
{
	// Variables declared by included files, with the value they start with in this script
	DebuffAcid()
	{
		EFFECT_ID = "debuff_acid";
	}

	// game_damaged
	string DebuffAcid_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!DEBUFF_STARTED)
			return result;
		// take 150% damage while under this effect
		result = AppendResult(result, "1.5");
		return result;
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return DebuffAcid_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		return BaseDebuffScript::DispatchEvent(name, params);
	}
}
