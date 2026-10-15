#pragma context server

// Converted from items/blunt_hammer1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntHammer1
{
	// Constants
	string MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
	int MODEL_VIEW_IDX = 1;
	string MODEL_BODY_OFS = "77";
	string ANIM_PREFIX = "hammer";
	string MELEE_RANGE = "60";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.2f;
	float MELEE_ENERGY = 0.3f;
	int MELEE_DMG = 100;
	int MELEE_DMG_RANGE = 20;
	string MELEE_DMG_TYPE = "blunt";
	string MELEE_ACCURACY = "70%";
	string MELEE_PARRY_CHANCE = "5%";

	// weapon_spawn
	void BluntHammer1_OnWeaponSpawn()
	{
		SetName("Training Hammer");
		SetDescription("Rusted metal makes this hammer light and easy to swing");
		SetWeight(10);
		SetValue(3);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "rustyhammer");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntHammer1_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool BluntHammer1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_hammer1"]
shared class BluntHammer1Script : BluntBaseOnehandedScript, BluntHammer1
{
	// Variables declared by included files, with the value they start with in this script
	BluntHammer1Script()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_BODY_OFS = "77";
		ANIM_PREFIX = "hammer";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.2f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 100;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "70%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntHammer1_DispatchEvent(name, params)
			|| BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
