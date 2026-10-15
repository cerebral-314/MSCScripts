#pragma context server

// Converted from items/swords_skullblade.script by msc_transpiler.
// Skullblade

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"
#include "converted/items/base_varied_attacks.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SwordsSkullblade
{
	// Constants
	string BASE_LEVEL_REQ = "6";
	int ANIM_LIFT1 = 0;
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	int ANIM_IDLE_DELAY_LOW = 1;
	int ANIM_IDLE_DELAY_HIGH = 3;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_ATTACK4 = 5;
	int ANIM_ATTACK5 = 6;
	int ANIM_SHEATH = 7;
	string MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
	int MODEL_VIEW_IDX = 0;
	string MODEL_HANDS = "weapons/p_weapons1.mdl";
	string MODEL_WORLD = "weapons/p_weapons1.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_SHOUT = "SOUND_SHOUT";
	string MODEL_BODY_OFS = "32";
	string ANIM_PREFIX = "skullblade";
	string MELEE_RANGE = "64";
	float MELEE_DMG_DELAY = 0.6f;
	float MELEE_ATK_DURATION = 1.5f;
	float MELEE_ENERGY = 2.0f;
	int MELEE_DMG = 200;
	int MELEE_DMG_RANGE = 10;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "60%";
	string MELEE_STAT = "swordsmanship";
	string MELEE_ALIGN_BASE = "4,-6";
	string MELEE_ALIGN_TIP = "0,6";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "5%";

	// Variables (an unset .script variable reads as its own name)
	int SWING_ANIM = 0;

	// weapon_spawn
	void SwordsSkullblade_OnWeaponSpawn()
	{
		SetName("Skullblade");
		SetDescription("This sword relies more on its weight than its sharp edge.");
		SetWeight(80);
		SetValue(200);
		SetHudSprite("trade", "skullblade");
	}

	// melee_start
	void SwordsSkullblade_OnMeleeStart()
	{
		// local SWING $rand(1,ATTACK_ANIMS)
		// local SWING_ANIM ANIM_ATTACK1
		// if( SWING == 2 ) setvard SWING_ANIM ANIM_ATTACK2
		// else if( SWING == 3 ) setvard SWING_ANIM ANIM_ATTACK3
		// else if( SWING == 4 ) setvard SWING_ANIM ANIM_ATTACK4
		// else if( SWING == 5 ) setvard SWING_ANIM ANIM_ATTACK5
		PlaySound(1, 10, SOUND_SWIPE);

		PlayOwnerAnim("once", "sword_swing"); // global.anim.combatwalk 3
		OnCheckAttackAnim();
		SWING_ANIM = CUR_ATTACK_ANIM;
		PlayItemViewAnim(ENT_ME, SWING_ANIM);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsSkullblade_OnWeaponSpawn();
	}

	void OnMeleeStart() { SwordsSkullblade_OnMeleeStart(); } // melee_start

	// This file's events and timers by their .script names
	bool SwordsSkullblade_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/swords_skullblade"]
shared class SwordsSkullbladeScript : SwordsBaseOnehandedScript, SwordsSkullblade, BaseVariedAttacks
{
	// Variables declared by included files, with the value they start with in this script
	SwordsSkullbladeScript()
	{
		ANIM_IDLE_DELAY_LOW = 1;
		ANIM_IDLE_DELAY_HIGH = 3;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "32";
		ANIM_PREFIX = "skullblade";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 200;
		MELEE_DMG_RANGE = 10;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "60%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hswordssb.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SwordsSkullblade_DispatchEvent(name, params)
			|| BaseVariedAttacks_DispatchEvent(name, params)
			|| SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
