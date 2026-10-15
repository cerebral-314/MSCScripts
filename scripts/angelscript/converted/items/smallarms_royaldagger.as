#pragma context server

// Converted from items/smallarms_royaldagger.script by msc_transpiler.
// Royal Dagger

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_royaldagger"]
class SmallarmsRoyaldagger : SmallarmsBaseScript
{
	// Constants
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsRoyaldagger()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 7;
		ANIM_LIFT1 = 0;
		ANIM_IDLE1 = "1";
		ANIM_WIELD = 2;
		ANIM_UNWIELD = 3;
		ANIM_WIELDEDIDLE1 = 4;
		ANIM_ATTACK1 = "5";
		ANIM_ATTACK2 = "6";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 189;
		MELEE_DMG_RANGE = 90;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_CHANCE = "30%";
		MODEL_BODY_OFS = "16";
		ANIM_PREFIX = "craftedknife";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Royal Dagger");
		SetDescription("A Royal Dagger");
		SetWeight(3);
		SetValue(50);
		SetHudSprite("hand", "170");
		SetHudSprite("trade", "170");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
