#pragma context server

// Converted from items/blunt_mace.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntMace
{
	// Constants
	string BASE_LEVEL_REQ = "6";
	string MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
	int MODEL_VIEW_IDX = 0;
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string MODEL_BODY_OFS = "68";
	string ANIM_PREFIX = "mace";
	string MELEE_RANGE = "60";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.2f;
	float MELEE_ENERGY = 0.6f;
	int MELEE_DMG = 150;
	int MELEE_DMG_RANGE = 20;
	string MELEE_DMG_TYPE = "blunt";
	string MELEE_ACCURACY = "70%";
	string MELEE_STAT = "bluntarms";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_AUGMENT = "5%";

	// weapon_spawn
	void BluntMace_OnWeaponSpawn()
	{
		SetName("Mace");
		SetDescription("A one-handed mace");
		SetWeight(30);
		SetValue(45);
		SetHudSprite("hand", "mace");
		SetHudSprite("trade", "mace");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntMace_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool BluntMace_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_mace"]
shared class BluntMaceScript : BluntBaseOnehandedScript, BluntMace
{
	// Variables declared by included files, with the value they start with in this script
	BluntMaceScript()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_BODY_OFS = "68";
		ANIM_PREFIX = "mace";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.2f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "70%";
		MELEE_PARRY_AUGMENT = "5%";
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
		return BluntMace_DispatchEvent(name, params)
			|| BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
