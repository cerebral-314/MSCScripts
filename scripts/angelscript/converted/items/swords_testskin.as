#pragma context server

// Converted from items/swords_testskin.script by msc_transpiler.
// Shortsword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_testskin"]
class SwordsTestskin : SwordsBaseOnehandedScript
{
	// Constants
	string MODEL_BLOCK = "armor/shields/p_shields.mdl";
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables declared by included files, with the value they start with in this script
	SwordsTestskin()
	{
		MODEL_VIEW = "weapons/swords/smallswords_skins_rview.mdl";
		MODEL_HANDS = "weapons/swords/p_swords.mdl";
		MODEL_WORLD = "weapons/swords/p_swords.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "shortsword";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 140;
		MELEE_DMG_RANGE = 110;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "70%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Shortsword Skintest");
		SetDescription("A short one-handed Sword");
		SetWeight(30);
		SetValue(15);
		SetHudSprite("trade", "shortsword");
		LegacyCommand("setmodelskin", 2);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/swords/p_swords.mdl");
		Precache("weapons/swords/smallswords_skins_rview.mdl");
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
