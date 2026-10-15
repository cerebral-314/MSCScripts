#pragma context server

// Converted from items/blunt_maul.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntMaul
{
	// Constants
	string BASE_LEVEL_REQ = "12";
	string MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
	int MODEL_VIEW_IDX = 0;
	string MODEL_BODY_OFS = "71";
	string ANIM_PREFIX = "maul";
	string MELEE_RANGE = "80";
	float MELEE_DMG_DELAY = 0.8f;
	float MELEE_ATK_DURATION = 1.3f;
	float MELEE_ENERGY = 2.0f;
	int MELEE_DMG = 220;
	int MELEE_DMG_RANGE = 20;
	string MELEE_ACCURACY = "65%";
	string MELEE_PARRY_AUGMENT = "10%";

	// weapon_spawn
	void BluntMaul_OnWeaponSpawn()
	{
		SetName("Maul");
		SetDescription("A heavy two-handed maul");
		SetWeight(80);
		SetValue(270);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "maul");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded
		BluntMaul_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool BluntMaul_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_maul"]
shared class BluntMaulScript : BluntBaseTwohandedScript, BluntMaul
{
	// Variables declared by included files, with the value they start with in this script
	BluntMaulScript()
	{
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_BODY_OFS = "71";
		ANIM_PREFIX = "maul";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.8f;
		MELEE_ATK_DURATION = 1.3f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 220;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "65%";
		MELEE_PARRY_AUGMENT = "10%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntMaul_DispatchEvent(name, params)
			|| BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
