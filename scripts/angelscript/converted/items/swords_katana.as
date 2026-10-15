#pragma context server

// Converted from items/swords_katana.script by msc_transpiler.
// Elven Short Sword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_katana"]
class SwordsKatana : SwordsBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "6";
	int ANIM_ATTACK4 = 11;
	int ANIM_ATTACK5 = 12;
	int MODEL_VIEW_IDX = 4;
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables declared by included files, with the value they start with in this script
	SwordsKatana()
	{
		ANIM_LIFT1 = 6;
		ANIM_IDLE1 = "7";
		ANIM_ATTACK1 = "8";
		ANIM_ATTACK2 = "9";
		ANIM_ATTACK3 = "10";
		ANIM_SHEATH = 13;
		ATTACK_ANIMS = 5;
		MODEL_VIEW = "viewmodels/v_1hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "0";
		ANIM_PREFIX = "dragonsword";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.0f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 160;
		MELEE_DMG_RANGE = 10;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "65%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Elven Shortsword");
		SetDescription("A smooth, balanced Elven shortsword");
		SetWeight(35);
		SetValue(50);
		SetHudSprite("trade", "dragonsword");
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
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
