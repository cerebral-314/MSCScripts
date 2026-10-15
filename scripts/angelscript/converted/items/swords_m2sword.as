#pragma context server

// Converted from items/swords_m2sword.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

[script "items/swords_m2sword"]
class SwordsM2sword : BaseWeaponScript
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	bool ANIM_LIFT = false;
	string ANIM_ATTACK1 = "2";
	string ANIM_ATTACK2 = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	int ANIM_UNSHEATH = 6;
	int ANIM_SHEATH = 7;
	string MODEL_BLOCK = "armor/shields/p_shields.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hit1.wav";
	string SOUND_DRAW = "weapons/swords/sworddraw.wav";
	string SOUND_SHOUT = "SOUND_SHOUT";
	float SWING_DELAY = 1.1f;
	float SWING_ENERGY = 1.5f;
	string SWING_ACCURACY = "80%";
	int SWING_DAMAGE = 300;
	int SWING_DAMAGE_RANGE = 180;
	string ITEM_NAME = "longsword";
	string MODEL_BODY_OFS = "4";
	string ANIM_PREFIX = "highsword";

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_TYPE = "strike-land";
	string ATTACK_DAMAGE_TYPE = "slash";
	string ATTACK_KEYS = "+back+attack1";
	bool ATTACK_PRIORITY = true;
	float ATTACK_DURATION = 1.3f;
	float ATTACK_LAND_DELAY = 0.3f;
	string ATTACK_EVENT = "swingoverhead";
	string ATTACK_LAND_EVENT = "swingoverhead_land";
	string ATTACK_DONE_EVENT = "0";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	int ATTACK_DAMAGE_RANGE = 0;
	float ATTACK_ENERGY = 0.0f;
	string ATTACK_ACCURACYSTAT = "swordsmanship";
	string ATTACK_ACCURACYDEFAULT = "ATTACK_ACCURACYDEFAULT";
	string ATTACK_ALIGN_BASE = "3,10";
	string ATTACK_ALIGN_TIP = "0,-10";
	float ATTACK_RANGE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SwordsM2sword()
	{
		ANIM_IDLE1 = "1";
		MODEL_VIEW = "weapons/swords/highsword_rview.mdl";
		MODEL_HANDS = "weapons/swords/p_swords.mdl";
		MODEL_WORLD = "weapons/swords/p_swords.mdl";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		SetName("Mithril Sword");
		SetDescription("A heavy, two-handed Mithril sword");
		SetWeight(110);
		SetValue(1000);
		SetWorldModel(MODEL_WORLD);
		SetPlayerModel(MODEL_HANDS);
		SetViewModel(MODEL_VIEW);
		SetHudSprite("hand", "sword");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("both");

		OnRegisterattackSwingside();
		OnRegisterattackSwingoverhead();
		OnRegisterattackParryside();
	}

	// registerattack_swingoverhead
	// Attacking
	// Overhead swing
	void OnRegisterattackSwingoverhead()
	{
		ATTACK_TYPE = "strike-land";
		ATTACK_DAMAGE_TYPE = "slash";
		ATTACK_KEYS = "+back+attack1";
		ATTACK_PRIORITY = true;
		ATTACK_DURATION = 1.3f;
		ATTACK_LAND_DELAY = 0.3f;
		ATTACK_EVENT = "swingoverhead";
		ATTACK_LAND_EVENT = "swingoverhead_land";
		ATTACK_DONE_EVENT = "0";

		// default values
		ATTACK_RANGE = 80.0f;
		ATTACK_DAMAGE = SWING_DAMAGE;
		ATTACK_DAMAGE_RANGE = SWING_DAMAGE_RANGE;
		ATTACK_ENERGY = SWING_ENERGY;
		ATTACK_ACCURACYSTAT = "swordsmanship";
		ATTACK_ACCURACYDEFAULT = SWING_ACCURACY; // % chance of hitting
		ATTACK_ALIGN_BASE = "3,10";
		ATTACK_ALIGN_TIP = "0,-10";

		RegisterAttack();
	}

	// swingoverhead
	void OnSwingoverhead()
	{
		PlayViewAnim(Int(ANIM_ATTACK2));
		PlayOwnerAnim("once", "longsword_swipe", "squatwalk1", 3);

		LegacyCommand("callownerevent", "commenceattack");
	}

	// swingoverhead_land
	void OnSwingoverheadLand()
	{
		LegacyCommand("callownerevent", "attackstrike");
	}

	// registerattack_swingside
	// Swing from side
	void OnRegisterattackSwingside()
	{
		ATTACK_TYPE = "strike-land";
		ATTACK_DAMAGE_TYPE = "slash";
		ATTACK_KEYS = "+attack1";
		ATTACK_PRIORITY = false;
		ATTACK_DURATION = 1.3f;
		ATTACK_LAND_DELAY = 0.3f;
		ATTACK_EVENT = "swingside";
		ATTACK_LAND_EVENT = "swingside_land";
		ATTACK_DONE_EVENT = "0";

		// default values
		ATTACK_RANGE = 70.0f;
		ATTACK_DAMAGE = SWING_DAMAGE;
		ATTACK_DAMAGE_RANGE = SWING_DAMAGE_RANGE;
		ATTACK_ENERGY = SWING_ENERGY;
		ATTACK_ACCURACYSTAT = "swordsmanship";
		ATTACK_ACCURACYDEFAULT = SWING_ACCURACY; // % chance of hitting
		ATTACK_ALIGN_BASE = "-20,-3";
		ATTACK_ALIGN_TIP = "20,-3";

		RegisterAttack();
	}

	// swingside
	void OnSwingside()
	{
		PlayViewAnim(Int(ANIM_ATTACK1));
		PlayOwnerAnim("once", "longsword_swipe", "squatwalk1", 3);
		SetVolume(10);
		LegacyCommand("playrandomsoundcl", 0, 10, SOUND_SWIPE);
		LegacyCommand("callownerevent", "commenceattack");
	}

	// swingside_land
	void OnSwingsideLand()
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
		ATTACK_ACCURACYDEFAULT = "65%"; // chance of automatically blocking

		RegisterAttack();
	}

	// parryside_retract
	void OnParrysideRetract()
	{
		PlayViewAnim(ANIM_PARRY1_RETRACT);
		PlayOwnerAnim("break");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/swords/p_swords.mdl");
		Precache("weapons/swords/highsword_rview.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "parryside_retract") { OnParrysideRetract(); return true; }
		if (name == "registerattack_parryside") { OnRegisterattackParryside(); return true; }
		if (name == "registerattack_swingoverhead") { OnRegisterattackSwingoverhead(); return true; }
		if (name == "registerattack_swingside") { OnRegisterattackSwingside(); return true; }
		if (name == "swingoverhead") { OnSwingoverhead(); return true; }
		if (name == "swingoverhead_land") { OnSwingoverheadLand(); return true; }
		if (name == "swingside") { OnSwingside(); return true; }
		if (name == "swingside_land") { OnSwingsideLand(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseWeaponScript::DispatchEvent(name, params);
	}
}
