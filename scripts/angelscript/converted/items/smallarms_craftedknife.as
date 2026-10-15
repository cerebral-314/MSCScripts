#pragma context server

// Converted from items/smallarms_craftedknife.script by msc_transpiler.
// Dull Finely crafted knife

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SmallarmsCraftedknife
{
	// Constants
	string MODEL_VIEW = "viewmodels/v_smallarms.mdl";
	int MODEL_VIEW_IDX = 2;
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string BASE_LEVEL_REQ = "6";
	string MELEE_RANGE = "50";
	float MELEE_DMG_DELAY = 0.2f;
	float MELEE_ATK_DURATION = 0.9f;
	float MELEE_ENERGY = 0.6f;
	int MELEE_DMG = 190;
	int MELEE_DMG_RANGE = 90;
	string MELEE_ACCURACY = "80%";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";
	string MELEE_PARRY_CHANCE = "30%";
	string MODEL_BODY_OFS = "0";
	string ANIM_PREFIX = "craftedknife";

	// weapon_spawn
	void SmallarmsCraftedknife_OnWeaponSpawn()
	{
		SetName("Dull Finely Crafted Knife");
		SetDescription("A deadly looking dagger of high craftsmanship");
		SetWeight(3);
		SetValue(50);
		SetHudSprite("hand", "merldagger");
		SetHudSprite("trade", "crafted");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsCraftedknife_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool SmallarmsCraftedknife_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/smallarms_craftedknife"]
shared class SmallarmsCraftedknifeScript : SmallarmsBaseScript, SmallarmsCraftedknife
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsCraftedknifeScript()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 2;
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 190;
		MELEE_DMG_RANGE = 90;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_CHANCE = "30%";
		MODEL_BODY_OFS = "0";
		ANIM_PREFIX = "craftedknife";
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
		return SmallarmsCraftedknife_DispatchEvent(name, params)
			|| SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
