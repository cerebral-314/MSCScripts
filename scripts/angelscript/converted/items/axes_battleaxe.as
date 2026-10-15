#pragma context server

// Converted from items/axes_battleaxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AxesBattleaxe
{
	// Constants
	string BASE_LEVEL_REQ = "12";
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string MODEL_VIEW = "viewmodels/v_2haxes.mdl";
	int MODEL_VIEW_IDX = 2;
	string MODEL_HANDS = "weapons/p_weapons1.mdl";
	string MODEL_WORLD = "weapons/p_weapons1.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string MODEL_BODY_OFS = "86";
	string ANIM_PREFIX = "axe";
	string MELEE_RANGE = "80";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.2f;
	float MELEE_ENERGY = 2.0f;
	int MELEE_DMG = 220;
	int MELEE_DMG_RANGE = 100;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "65%";
	string MELEE_STAT = "axehandling";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "10%";
	string PLAYERANIM_AIM = "battleaxe";

	// weapon_spawn
	void AxesBattleaxe_OnWeaponSpawn()
	{
		SetName("Battleaxe");
		SetDescription("A large two-handed Battleaxe, for skull-splitting action");
		SetWeight(80);
		SetValue(270);
		SetHudSprite("hand", "battleaxe");
		SetHudSprite("trade", "battleaxe");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesBattleaxe_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool AxesBattleaxe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/axes_battleaxe"]
shared class AxesBattleaxeScript : AxesBaseTwohandedScript, AxesBattleaxe
{
	// Variables declared by included files, with the value they start with in this script
	AxesBattleaxeScript()
	{
		BASE_LEVEL_REQ = "12";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxes.mdl";
		MODEL_VIEW_IDX = 2;
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "86";
		ANIM_PREFIX = "axe";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.2f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 220;
		MELEE_DMG_RANGE = 100;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "65%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "10%";
		PLAYERANIM_AIM = "battleaxe";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2haxes.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AxesBattleaxe_DispatchEvent(name, params)
			|| AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
