#pragma context server

// Converted from items/swords_shortsword.script by msc_transpiler.
// Shortsword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SwordsShortsword
{
	// Constants
	string BASE_LEVEL_REQ = "3";
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	string MODEL_VIEW = "viewmodels/v_1hswords.mdl";
	int MODEL_VIEW_IDX = 0;
	string MODEL_HANDS = "weapons/p_weapons1.mdl";
	string MODEL_WORLD = "weapons/p_weapons1.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_SHOUT = "SOUND_SHOUT";
	string MODEL_BODY_OFS = "28";
	string ANIM_PREFIX = "shortsword";
	string MELEE_RANGE = "60";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.1f;
	float MELEE_ENERGY = 0.4f;
	int MELEE_DMG = 110;
	int MELEE_DMG_RANGE = 60;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "70%";
	string MELEE_STAT = "swordsmanship";
	string MELEE_ALIGN_BASE = "4,-6";
	string MELEE_ALIGN_TIP = "0,6";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "15%";

	// weapon_spawn
	void SwordsShortsword_OnWeaponSpawn()
	{
		SetName("Short Sword");
		SetDescription("A short one-handed Sword");
		SetWeight(30);
		SetValue(15);
		SetHudSprite("trade", "shortsword");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsShortsword_OnWeaponSpawn();
	}

	// This file's events and timers by their .script names
	bool SwordsShortsword_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/swords_shortsword"]
shared class SwordsShortswordScript : SwordsBaseOnehandedScript, SwordsShortsword
{
	// Variables declared by included files, with the value they start with in this script
	SwordsShortswordScript()
	{
		MODEL_VIEW = "viewmodels/v_1hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "shortsword";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.4f;
		MELEE_DMG = 110;
		MELEE_DMG_RANGE = 60;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "70%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "15%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SwordsShortsword_DispatchEvent(name, params)
			|| SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
