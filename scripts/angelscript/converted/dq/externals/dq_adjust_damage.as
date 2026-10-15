#pragma context server

// Converted from dq/externals/dq_adjust_damage.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This kinda acts as an include to shove into enemies via applyeffect
// This effect limits the max amount of damage that can happen to a player

#include "runtime/ScriptEntity.as"

[script "dq/externals/dq_adjust_damage"]
class DqAdjustDamage : ScriptEntity
{
	// Constants
	float DAMAGE_MULTIPLIER = 0.5f;
	string DQ_WHERE_IS_THE_CREATOR = "DQ_WHERE_IS_THE_CREATOR";
	string MAX_DMG = "MAX_DMG";

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type	For max damage	Thanks Thothie!
	string DqAdjustDamage_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (MAX_DMG != "MAX_DMG") // This var can only exist if a quest taker does.
		{
			CBaseEntity@ targetValue = target;
			float dmg = damage;
			string dmgType = damageType;

			if (IsPlayer(targetValue))
				if (dmg > Float(MAX_DMG)) {}
		}
		return result;
	}

	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return DqAdjustDamage_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		return false;
	}
}
