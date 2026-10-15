#pragma context server

// Converted from items/swords_msword.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

[script "items/swords_msword"]
class SwordsMsword : BaseWeaponScript
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;
	string MODEL_BLOCK = "armor/shields/p_shields.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	float SWING_DELAY = 1.0f;
	float SWING_ENERGY = 0.4f;
	int SWING_RANGE = 60;
	int ACCURACY_NORMAL = 80;
	int SWING_DAMAGE = 290;
	int SWING_DAMAGE_RANGE = 160;
	string ITEM_NAME = "shortsword";
	string MODEL_BODY_OFS = "28";
	string ANIM_PREFIX = "shortsword";

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_TYPE = "strike-land";
	string ATTACK_DAMAGE_TYPE = "slash";
	string ATTACK_KEYS = "+attack1";
	bool ATTACK_PRIORITY = true;
	float ATTACK_DURATION = 0.0f;
	float ATTACK_LAND_DELAY = 0.6f;
	string ATTACK_EVENT = "swing1";
	string ATTACK_LAND_EVENT = "swing_land";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	int ATTACK_DAMAGE_RANGE = 0;
	float ATTACK_ENERGY = 0.0f;
	string ATTACK_ACCURACYSTAT = "swordsmanship";
	string ATTACK_ACCURACYDEFAULT = "ATTACK_ACCURACYDEFAULT";
	string ATTACK_ALIGN_BASE = "4,-6";
	string ATTACK_ALIGN_TIP = "0,6";
	float ATTACK_RANGE = 0.0f;
	string ATTACK_DONE_EVENT = "parryside_retract";

	// Variables declared by included files, with the value they start with in this script
	SwordsMsword()
	{
		ANIM_IDLE1 = "1";
		MODEL_VIEW = "weapons/swords/shortsword_rview.mdl";
		MODEL_HANDS = "weapons/swords/p_swords.mdl";
		MODEL_WORLD = "weapons/swords/p_swords.mdl";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		SetName("Mithril Shortsword");
		SetDescription("A heavy mithril shortsword");
		SetWeight(80);
		SetValue(800);
		SetWorldModel(MODEL_WORLD);
		SetPlayerModel(MODEL_HANDS);
		SetViewModel(MODEL_VIEW);
		SetHand("right");
		SetHudSprite("hand", "sword");
		SetHudSprite("trade", ITEM_NAME);

		OnRegisterattackSwing1();
		OnRegisterattackSwing2();
		OnRegisterattackSwing3();
		OnRegisterattackParryside();
	}

	// registerattack_swing1
	// Attacking
	// Normal swing attack
	void OnRegisterattackSwing1()
	{
		ATTACK_TYPE = "strike-land";
		ATTACK_DAMAGE_TYPE = "slash";
		ATTACK_KEYS = "+attack1";
		ATTACK_PRIORITY = true;
		ATTACK_DURATION = SWING_DELAY;
		ATTACK_LAND_DELAY = 0.6f;
		ATTACK_EVENT = "swing1";
		ATTACK_LAND_EVENT = "swing_land";

		// default values
		ATTACK_RANGE = SWING_RANGE;
		ATTACK_DAMAGE = SWING_DAMAGE;
		ATTACK_DAMAGE_RANGE = SWING_DAMAGE_RANGE;
		ATTACK_ENERGY = SWING_ENERGY;
		ATTACK_ACCURACYSTAT = "swordsmanship";
		ATTACK_ACCURACYDEFAULT = ACCURACY_NORMAL; // % chance of hitting
		ATTACK_ALIGN_BASE = "4,-6";
		ATTACK_ALIGN_TIP = "0,6";

		RegisterAttack();
	}

	// registerattack_swing2
	void OnRegisterattackSwing2()
	{
		ATTACK_TYPE = "strike-land";
		ATTACK_DAMAGE_TYPE = "slash";
		ATTACK_KEYS = "+attack1";
		ATTACK_PRIORITY = true;
		ATTACK_DURATION = SWING_DELAY;
		ATTACK_LAND_DELAY = 0.6f;
		ATTACK_EVENT = "swing1";
		ATTACK_LAND_EVENT = "swing_land";

		// default values
		ATTACK_RANGE = SWING_RANGE;
		ATTACK_DAMAGE = SWING_DAMAGE;
		ATTACK_DAMAGE_RANGE = SWING_DAMAGE_RANGE;
		ATTACK_ENERGY = SWING_ENERGY;
		ATTACK_ACCURACYSTAT = "swordsmanship";
		ATTACK_ACCURACYDEFAULT = ACCURACY_NORMAL; // % chance of hitting
		ATTACK_ALIGN_BASE = "4,-6";
		ATTACK_ALIGN_TIP = "0,6";

		RegisterAttack();
	}

	// registerattack_swing3
	void OnRegisterattackSwing3()
	{
		ATTACK_TYPE = "strike-land";
		ATTACK_DAMAGE_TYPE = "slash";
		ATTACK_KEYS = "+attack1";
		ATTACK_PRIORITY = true;
		ATTACK_DURATION = SWING_DELAY;
		ATTACK_LAND_DELAY = 0.6f;
		ATTACK_EVENT = "swing1";
		ATTACK_LAND_EVENT = "swing_land";

		// default values
		ATTACK_RANGE = SWING_RANGE;
		ATTACK_DAMAGE = SWING_DAMAGE;
		ATTACK_DAMAGE_RANGE = SWING_DAMAGE_RANGE;
		ATTACK_ENERGY = SWING_ENERGY;
		ATTACK_ACCURACYSTAT = "swordsmanship";
		ATTACK_ACCURACYDEFAULT = ACCURACY_NORMAL; // % chance of hitting
		ATTACK_ALIGN_BASE = "4,-6";
		ATTACK_ALIGN_TIP = "0,6";

		RegisterAttack();
	}

	// swing1
	void OnSwing1()
	{
		PlayViewAnim(Int(ANIM_ATTACK1));
		OnSwing();
	}

	// swing2
	void OnSwing2()
	{
		PlayViewAnim(Int(ANIM_ATTACK2));
		OnSwing();
	}

	// swing3
	void OnSwing3()
	{
		PlayViewAnim(Int(ANIM_ATTACK3));
		OnSwing();
	}

	// swing
	void OnSwing()
	{
		PlayOwnerAnim("once", "swordswing1", "squatwalk1", 3);
		PlaySound(1, 10, SOUND_SWIPE);
		LegacyCommand("callownerevent", "commenceattack");
	}

	// swing_land
	void OnSwingLand()
	{
		LegacyCommand("callownerevent", "attackstrike");
	}

	// registerattack_parryside
	// Parry
	void OnRegisterattackParryside()
	{
		ATTACK_TYPE = "strike-hold";
		ATTACK_DAMAGE_TYPE = "slash";
		ATTACK_PRIORITY = false;
		ATTACK_LAND_DELAY = 0.0f;
		ATTACK_EVENT = "parryside";
		ATTACK_LAND_EVENT = "parryside_block";
		ATTACK_DONE_EVENT = "parryside_retract";

		// default values
		ATTACK_RANGE = 20.0f;
		ATTACK_ENERGY = 0.5f;
		ATTACK_ACCURACYSTAT = "parry";
		ATTACK_ACCURACYDEFAULT = "45%"; // chance of automatically blocking

		RegisterAttack();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/swords/p_swords.mdl");
		Precache("weapons/swords/shortsword_rview.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "registerattack_parryside") { OnRegisterattackParryside(); return true; }
		if (name == "registerattack_swing1") { OnRegisterattackSwing1(); return true; }
		if (name == "registerattack_swing2") { OnRegisterattackSwing2(); return true; }
		if (name == "registerattack_swing3") { OnRegisterattackSwing3(); return true; }
		if (name == "swing") { OnSwing(); return true; }
		if (name == "swing1") { OnSwing1(); return true; }
		if (name == "swing2") { OnSwing2(); return true; }
		if (name == "swing3") { OnSwing3(); return true; }
		if (name == "swing_land") { OnSwingLand(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseWeaponScript::DispatchEvent(name, params);
	}
}
