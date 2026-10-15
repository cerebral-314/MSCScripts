#pragma context server

// Converted from items/swords_wolvesbane.script by msc_transpiler.
// Shortsword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_wolvesbane"]
class SwordsWolvesbane : SwordsBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "3";
	int MODEL_VIEW_IDX = 0;
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables (an unset .script variable reads as its own name)
	bool SPECIAL_WEAPON = false;
	string SPECIAL_WEAPON_TYPE = "SPECIAL_WEAPON_TYPE";

	// Variables declared by included files, with the value they start with in this script
	SwordsWolvesbane()
	{
		MODEL_VIEW = "viewmodels/v_1hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "shortsword";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.0f;
		MELEE_ENERGY = 0.4f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 60;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "15%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Wolve's Bane");
		SetDescription("A light two-handed sword laced with wolve's bane");
		SetWeight(30);
		SetValue(15);
		SetHudSprite("trade", "shortsword");

		SPECIAL_WEAPON = true;
		SPECIAL_WEAPON_TYPE = "wolf";
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
