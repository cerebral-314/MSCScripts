#pragma context server

// Converted from items/smallarms_crel.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_cre.as"

[script "items/smallarms_crel"]
class SmallarmsCrel : SmallarmsCreScript
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsCrel()
	{
		BWEAPON_NAME = "Electrified Crescent Blade";
		BWEAPON_INV_SPRITE_IDX = 242;
		ATK1_DMG_TYPE = "lightning";
		CRE_TYPE = "lightning";
		CRE_EFFECT_SCRIPT = "effects/dot_lightning";
		CRE_EFFECT_DURATION = 5.0f;
		CRE_EFFECT_NAME = "DOT_lightning";
		CRE_EFFECT_SKILL = "skill.spellcasting.lightning";
		CRE_EFFECT_RATIO = 0.4f;
		VMODEL_IDX = 19;
		PMODEL_IDX_FLOOR = 76;
		PMODEL_IDX_HANDS = 78;
	}

	// atk1_damaged_other
	string SmallarmsCrel_OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
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

		DebugPrint("atk1_damaged_other burn " + NameOf(target) + " at " + Text(dotAmt) + " for " + Text(CRE_EFFECT_DURATION));

		ApplyEffect(target, CRE_EFFECT_SCRIPT, CRE_EFFECT_DURATION, @EntityOf(ENT_OWNER), dotAmt);
		return result;
	}

	// atk1_damaged_other
	string OnAtk1DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseWeaponNew_OnAtk1DamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SmallarmsCrel_OnAtk1DamagedOther(target, damage, damageType, damageEvent));
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
