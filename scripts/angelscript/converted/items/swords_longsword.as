#pragma context server

// Converted from items/swords_longsword.script by msc_transpiler.
// Thothie - Fixed mislabel
// - Changeing parry system
// Longsword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

[script "items/swords_longsword"]
class SwordsLongsword : SwordsBaseTwohandedScript
{
	// Constants
	bool SWORD_MANUAL_PARRY = true;
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	int ANIM_PARRY_DEBUG = 4;
	int ANIM_UNPARRY_DEBUG = 5;
	string MELEE_NEW_PARRY_CHANCE = "30";

	// Variables (an unset .script variable reads as its own name)
	int SWING_ANIM = 0;
	bool PARRY_ON = false;

	// Variables declared by included files, with the value they start with in this script
	SwordsLongsword()
	{
		BASE_LEVEL_REQ = "9";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		MODEL_BODY_OFS = "16";
		ANIM_PREFIX = "longsword";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 160;
		MELEE_DMG_RANGE = 80;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "65%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "30%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Longsword");
		SetDescription("A normal looking two-handed longsword");
		SetWeight(50);
		SetValue(135);
		SetHudSprite("trade", "longsword");

		SetHand("both");
	}

	// parryanim
	void OnParryanim()
	{
		SwordsBaseTwohanded_OnParryanim(); // items/swords_base_twohanded

		// WTF WON'T THIS PLAY!??! - Thothie (frustrated)
		PlayViewAnim(ANIM_PARRY1);
		// playviewanim critical parry1
		PlayOwnerAnim("once", "sword_swing");
		CallEventDelayed(0.75f, "unparryanim");
	}

	// melee_start
	void OnMeleeStart()
	{
		int swing = RandomInt(1, 3);
		if (swing == 1)
			SWING_ANIM = Int(ANIM_ATTACK1);
		if (swing == 2)
			SWING_ANIM = Int(ANIM_ATTACK2);
		if (swing == 3)
			SWING_ANIM = Int(ANIM_ATTACK3);
		PlayOwnerAnim("once", "sword_double_swing");
		PlayViewAnim(SWING_ANIM);
		SetVolume(10);
		PlaySound(1, 10, SOUND_SWIPE);
	}

	// special_01_start
	void OnSpecial01Start()
	{
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	// blockmode_start
	void OnBlockmodeStart()
	{
		PlayViewAnim(ANIM_PARRY1);
		// playviewanim critical parry1
		PlayOwnerAnim("once", "sword_swing");
		PARRY_ON = true;
	}

	// blockmode_end
	void OnBlockmodeEnd()
	{
		PlayViewAnim(ANIM_PARRY1_RETRACT);
		// playviewanim critical parry1_retract
		PARRY_ON = false;
	}

	// unparryanim
	void OnUnparryanim()
	{
		PlayViewAnim(ANIM_PARRY1_RETRACT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "blockmode_end") { OnBlockmodeEnd(); return true; }
		if (name == "blockmode_start") { OnBlockmodeStart(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "parryanim") { OnParryanim(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "unparryanim") { OnUnparryanim(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
