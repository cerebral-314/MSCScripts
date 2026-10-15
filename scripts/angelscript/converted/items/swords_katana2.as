#pragma context server

// Converted from items/swords_katana2.script by msc_transpiler.
// Thothie - Giving these seperate name so you have some idea if you've gotten the same one 50 times
// - I'll keep the name *somewhat* mysterious, so you still have to experiment to figure which is best
// Elven Short Sword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_katana2"]
class SwordsKatana2 : SwordsBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "9";
	int ANIM_ATTACK4 = 11;
	int ANIM_ATTACK5 = 12;
	int MODEL_VIEW_IDX = 4;
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables declared by included files, with the value they start with in this script
	SwordsKatana2()
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
		SOUND_HITWALL2 = "weapons/cbar_hit1.wav";
		MODEL_BODY_OFS = "0";
		ANIM_PREFIX = "dragonsword";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.5f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.5f;
		MELEE_DMG = 160;
		MELEE_DMG_RANGE = 70;
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

		SetName("Sylvian Blade");
		SetDescription("A balanced blade made by the Sylvian Elves");
		SetWeight(35);
		SetValue(200);
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
