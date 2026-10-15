#pragma context server

// Converted from items/smallarms_knife.script by msc_transpiler.
// Sharpened knife

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_knife"]
class SmallarmsKnife : SmallarmsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "3";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsKnife()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 2;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "40";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.4f;
		MELEE_DMG = 80;
		MELEE_DMG_RANGE = 60;
		MELEE_ACCURACY = "75%";
		MELEE_PARRY_CHANCE = "20%";
		MODEL_BODY_OFS = "0";
		ANIM_PREFIX = "craftedknife";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Sharp Knife");
		SetDescription("A sharpened knife");
		SetWeight(3);
		SetValue(15);
		SetHudSprite("hand", "merldagger");
		SetHudSprite("trade", "crafted");
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
