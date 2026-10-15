#pragma context server

// Converted from items/smallarms_rknife.script by msc_transpiler.
// Dull knife

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_rknife"]
class SmallarmsRknife : SmallarmsBaseScript
{
	// Constants
	string MELEE_NEW_PARRY_CHANCE = "20";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsRknife()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 1;
		ANIM_LIFT1 = 27;
		ANIM_IDLE1 = "28";
		ANIM_ATTACK1 = "29";
		ANIM_ATTACK2 = "30";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "40";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 70;
		MELEE_DMG_RANGE = 50;
		MELEE_ACCURACY = "75%";
		MELEE_PARRY_CHANCE = "20%";
		MODEL_BODY_OFS = "12";
		ANIM_PREFIX = "rdagger";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Dull Knife");
		SetDescription("This knife has seen better days");
		SetWeight(2);
		SetValue(3);
		SetHudSprite("hand", "merldagger");
		SetHudSprite("trade", "rdagger");
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
