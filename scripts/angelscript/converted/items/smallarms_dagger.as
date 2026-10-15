#pragma context server

// Converted from items/smallarms_dagger.script by msc_transpiler.
// Dagger

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_dagger"]
class SmallarmsDagger : SmallarmsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "6";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsDagger()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		ANIM_LIFT1 = 18;
		ANIM_IDLE1 = "19";
		ANIM_WIELD = 20;
		ANIM_UNWIELD = 21;
		ANIM_WIELDEDIDLE1 = 22;
		ANIM_ATTACK1 = "23";
		ANIM_ATTACK2 = "24";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "40";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 100;
		MELEE_DMG_RANGE = 70;
		MELEE_ACCURACY = "75%";
		MELEE_PARRY_CHANCE = "25%";
		MODEL_BODY_OFS = "4";
		ANIM_PREFIX = "dagger";
	}

	// weapon_spawn
	// Called whenever the dagger spawns
	// Setup the basic info specific to this weapon
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Small Dagger");
		SetDescription("A small dagger");
		SetWeight(3);
		SetValue(45);
		SetHudSprite("hand", "169");
		SetHudSprite("trade", "169");
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
