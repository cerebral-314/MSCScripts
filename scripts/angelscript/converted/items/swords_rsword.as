#pragma context server

// Converted from items/swords_rsword.script by msc_transpiler.
// Rusty shortsword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_rsword"]
class SwordsRsword : SwordsBaseOnehandedScript
{
	// Constants
	int MODEL_VIEW_IDX = 1;

	// Variables declared by included files, with the value they start with in this script
	SwordsRsword()
	{
		ANIM_IDLE_DELAY_LOW = 1;
		ANIM_IDLE_DELAY_HIGH = 3;
		MODEL_VIEW = "viewmodels/v_1hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "24";
		ANIM_PREFIX = "shortsword";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 90;
		MELEE_DMG_RANGE = 50;
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

		SetName("Rusty Short Sword");
		SetDescription("The rusted metal is light and easy to swing, but lessens the impact");
		SetWeight(10);
		SetValue(3);
		SetHudSprite("hand", "sword");
		SetHudSprite("trade", "168");
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
