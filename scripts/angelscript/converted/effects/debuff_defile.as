#pragma context server

// Converted from effects/debuff_defile.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff.as"

[script "effects/debuff_defile"]
class DebuffDefile : BaseDebuffScript
{
	// Variables declared by included files, with the value they start with in this script
	DebuffDefile()
	{
		EFFECT_ID = "debuff_defile";
	}

	// game_damaged_other
	string DebuffDefile_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!DEBUFF_STARTED)
			return result;
		result = AppendResult(result, "0.5");
		return result;
	}

	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return DebuffDefile_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		return BaseDebuffScript::DispatchEvent(name, params);
	}
}
