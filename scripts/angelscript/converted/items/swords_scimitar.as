#pragma context server

// Converted from items/swords_scimitar.script by msc_transpiler.
// Thothie - what happened to our scimitar model?
// Skullblade

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_scimitar"]
class SwordsScimitar : SwordsBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "6";
	int MODEL_VIEW_IDX = 2;
	string MODEL_BLOCK = "none";
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables declared by included files, with the value they start with in this script
	SwordsScimitar()
	{
		MODEL_VIEW = "viewmodels/v_1hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "8";
		ANIM_PREFIX = "machete";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 130;
		MELEE_DMG_RANGE = 70;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "70%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "15%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Scimitar");
		SetDescription("A heavy one-handed Scimitar");
		SetWeight(30);
		SetValue(45);
		SetHudSprite("trade", "machete");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
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
