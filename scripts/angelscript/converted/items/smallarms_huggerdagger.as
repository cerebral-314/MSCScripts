#pragma context server

// Converted from items/smallarms_huggerdagger.script by msc_transpiler.
// Hugger dagger

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SmallarmsHuggerdagger
{
	// Constants
	string BASE_LEVEL_REQ = "9";
	string MODEL_VIEW = "viewmodels/v_smallarms.mdl";
	int MODEL_VIEW_IDX = 3;
	int ANIM_LIFT1 = 18;
	string ANIM_IDLE1 = "19";
	int ANIM_IDLE_TOTAL = 1;
	int ANIM_WIELD = 20;
	int ANIM_UNWIELD = 21;
	int ANIM_WIELDEDIDLE1 = 22;
	string ANIM_ATTACK1 = "23";
	string ANIM_ATTACK2 = "24";
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string MELEE_RANGE = "22";
	float MELEE_DMG_DELAY = 0.2f;
	float MELEE_ATK_DURATION = 0.65f;
	float MELEE_ENERGY = 1.0f;
	int MELEE_DMG = 170;
	int MELEE_DMG_RANGE = 90;
	string MELEE_ACCURACY = "80%";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";
	string MELEE_PARRY_CHANCE = "30%";
	string MODEL_BODY_OFS = "24";
	string ANIM_PREFIX = "thiefdagger";

	// weapon_spawn
	void SmallarmsHuggerdagger_OnWeaponSpawn()
	{
		SetName("Hugger Dagger");
		SetDescription("A dagger only useful if you're close enough to give the enemy a big warm hug");
		SetWeight(1);
		SetValue(50);
		SetHudSprite("hand", "171");
		SetHudSprite("trade", "171");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsHuggerdagger_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool SmallarmsHuggerdagger_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/smallarms_huggerdagger"]
shared class SmallarmsHuggerdaggerScript : SmallarmsBaseScript, SmallarmsHuggerdagger
{
	// Variables declared by included files, with the value they start with in this script
	SmallarmsHuggerdaggerScript()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 3;
		ANIM_LIFT1 = 18;
		ANIM_IDLE1 = "19";
		ANIM_WIELD = 20;
		ANIM_UNWIELD = 21;
		ANIM_WIELDEDIDLE1 = 22;
		ANIM_ATTACK1 = "23";
		ANIM_ATTACK2 = "24";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "22";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.65f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 170;
		MELEE_DMG_RANGE = 90;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_CHANCE = "30%";
		MODEL_BODY_OFS = "24";
		ANIM_PREFIX = "thiefdagger";
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
		return SmallarmsHuggerdagger_DispatchEvent(name, params)
			|| SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
