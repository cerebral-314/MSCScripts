#pragma context server

// Converted from items/axes_greataxe.script by msc_transpiler.
// Great Axe

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AxesGreataxe
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
	int MODEL_VIEW_IDX = 0;
	string MODEL_HANDS = "weapons/p_weapons1.mdl";
	string MODEL_WORLD = "weapons/p_weapons1.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string MODEL_BODY_OFS = "92";
	string ANIM_PREFIX = "axe";
	string MELEE_RANGE = "100";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.5f;
	float MELEE_ENERGY = 3.0f;
	int MELEE_DMG = 300;
	int MELEE_DMG_RANGE = 25;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "25%";
	string MELEE_STAT = "axehandling";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "25%";

	// weapon_spawn
	void AxesGreataxe_OnWeaponSpawn()
	{
		SetName("Great Axe");
		SetDescription("A great two-handed Axe");
		SetWeight(90);
		SetValue(900);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "greataxe");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesGreataxe_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool AxesGreataxe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/axes_greataxe"]
shared class AxesGreataxeScript : AxesBaseTwohandedScript, AxesGreataxe
{
	// Variables declared by included files, with the value they start with in this script
	AxesGreataxeScript()
	{
		BASE_LEVEL_REQ = "15";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "92";
		ANIM_PREFIX = "axe";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 3.0f;
		MELEE_DMG = 300;
		MELEE_DMG_RANGE = 25;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "25%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AxesGreataxe_DispatchEvent(name, params)
			|| AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
