#pragma context server

// Converted from items/smallarms_cref.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_cre.as"

[script "items/smallarms_cref"]
class SmallarmsCref : SmallarmsCreScript
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsCref()
	{
		BWEAPON_NAME = "Flaming Crescent Blade";
		BWEAPON_INV_SPRITE_IDX = 240;
		ATK1_DMG_TYPE = "fire";
		CRE_TYPE = "fire";
		CRE_EFFECT_SCRIPT = "effects/dot_fire";
		CRE_EFFECT_DURATION = 5.0f;
		CRE_EFFECT_NAME = "DOT_fire";
		CRE_EFFECT_SKILL = "skill.spellcasting.fire";
		CRE_EFFECT_RATIO = 0.5f;
		VMODEL_IDX = 17;
		PMODEL_IDX_FLOOR = 70;
		PMODEL_IDX_HANDS = 72;
	}

	// atk1_damaged_other
	string SmallarmsCref_OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool exitSub = false;
		string result = "";
		if (HasEffect(target, CRE_EFFECT_NAME))
			return result;

		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		float dotAmt = Float(GetProp(ENT_OWNER, CRE_EFFECT_SKILL));
		dotAmt *= CRE_EFFECT_RATIO;

		// dbg atk1_damaged_other burn $get(PARAM1,name) at DOT_AMT for CRE_EFFECT_DURATION
		ApplyEffect(target, CRE_EFFECT_SCRIPT, CRE_EFFECT_DURATION, @EntityOf(ENT_OWNER), dotAmt, "smallarms");
		return result;
	}

	// atk1_damaged_other
	string OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseWeaponNew_OnAtk1DamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SmallarmsCref_OnAtk1DamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "atk1_damaged_other") { Return(OnAtk1DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		return SmallarmsCreScript::DispatchEvent(name, params);
	}
}
