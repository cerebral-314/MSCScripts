#pragma context server

// Converted from items/crossbow_heavy.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

[script "items/crossbow_heavy"]
class CrossbowHeavy : BaseWeaponScript
{
	// Constants
	int ANIM_STRETCH = 8;
	string ANIM_FIRE = "7";
	string MODEL_WEAR = "weapons/bows/crossbow_back.mdl";
	string SOUND_SHOOT = "weapons/bow/crossbow.wav";
	string ITEM_NAME = "xbow";

	// Variables (an unset .script variable reads as its own name)
	string ATTACK_TYPE = "charge-throw-projectile";
	string ATTACK_DAMAGE_TYPE = "none";
	string ATTACK_KEYS = "+attack1";
	bool ATTACK_PRIORITY = false;
	string ATTACK_EVENT = "shoot";
	string ATTACK_LAND_EVENT = "shoot_fire";
	string ATTACK_DONE_EVENT = "shoot_done";
	float ATTACK_ENERGY = 0.1f;
	float ATTACK_PROJMINHOLD = 2.0f;
	float ATTACK_PROJMAXHOLD = 2.0f;
	float ATTACK_DURATION = 0.001f;
	string ATTACK_ACCURACYSTAT = "archery";
	string ATTACK_ACCURACYDEFAULT = "0.01";
	string ATTACK_ALIGN_BASE = "0,0";
	string ATTACK_ALIGN_TIP = "0,0";
	string ATTACK_PROJECTILE = "bolt";
	float ATTACK_RANGE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	CrossbowHeavy()
	{
		ANIM_LIFT1 = 4;
		MODEL_VIEW = "weapons/bows/v_crossbow.mdl";
		MODEL_HANDS = "weapons/bows/p_crossbow.mdl";
		MODEL_WORLD = "weapons/bows/w_crossbow.mdl";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		SetName("Heavy Crossbow");
		SetDescription("A heavier crossbow that allows bolts to fly further");
		SetWeight(95);
		SetValue(3000);
		SetWearable(1, "bow");
		SetAnimExtension("bow");
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);
		SetPlayerModel(MODEL_HANDS);
		SetHand("both");
		SetHudSprite("hand", "bow");
		SetHudSprite("trade", ITEM_NAME);
		OnRegisterShoot();
		SetModelBody(0, 1); // For Jesters upcoming model
	}

	// deploy
	void OnDeploy()
	{
		SetViewModel(MODEL_VIEW);

		LegacyCommand("setholdmodel", ITEM_NAME);
		SetModelBody(0, 1);
	}

	// pickup
	void OnPickup()
	{
		PlayViewAnim(ANIM_LIFT1);
	}

	// switchhands
	void OnSwitchhands()
	{
		PlayViewAnim(Int(ANIM_IDLE1));
	}

	// wear
	void OnWear()
	{
		SetViewModel("none");
		SetModel(MODEL_WEAR);
		OwnerMessage("You sling a crossbow onto your back.");
	}

	// removefromowner
	void OnRemovefromowner()
	{
		SetModelBody(0, 0);
		LegacyCommand("callownerevent", "drop_orcbow");
	}

	// register_shoot
	// Normal attack
	void OnRegisterShoot()
	{
		ATTACK_TYPE = "charge-throw-projectile";
		ATTACK_DAMAGE_TYPE = "none";
		ATTACK_KEYS = "+attack1";
		ATTACK_PRIORITY = false;
		ATTACK_EVENT = "shoot";
		ATTACK_LAND_EVENT = "shoot_fire";
		ATTACK_DONE_EVENT = "shoot_done";

		// default values
		ATTACK_RANGE = 1900.0f;
		ATTACK_ENERGY = 0.1f;
		ATTACK_PROJMINHOLD = 2.0f;
		ATTACK_PROJMAXHOLD = 2.0f;
		ATTACK_DURATION = 0.001f;
		ATTACK_ACCURACYSTAT = "archery";
		ATTACK_ACCURACYDEFAULT = "0.01"; // degree spread... higher = more inaccurate
		ATTACK_ALIGN_BASE = "0,0";
		ATTACK_ALIGN_TIP = "0,0"; // angle offset
		ATTACK_PROJECTILE = "bolt";

		RegisterAttack();
	}

	// shoot
	void OnShoot()
	{
		PlayViewAnim(ANIM_STRETCH);
		PlayOwnerAnim("break");
		PlayOwnerAnim("hold", "bow_fire");
		LegacyCommand("callownerevent", "commenceattack");
	}

	// shoot_fire
	void OnShootFire()
	{
		SetVolume(10);
		PlaySound(1, 10, SOUND_SHOOT);
		PlayViewAnim(Int(ANIM_FIRE));
		LegacyCommand("callownerevent", "attackstrike");
	}

	// shoot_done
	void OnShootDone()
	{
		PlayViewAnim(ANIM_LIFT1);
		PlayOwnerAnim("critical", "aim_bow", "aim_bow", 1.2f);
		CallEventDelayed(0.0f, "1");
	}

	// shoot_returnstanding
	void OnShootReturnstanding()
	{
		PlayOwnerAnim("once", "bow_aim_to_stand");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/w_crossbow.mdl");
		Precache("weapons/bows/p_crossbow.mdl");
		Precache("weapons/bows/v_crossbow.mdl");
		Precache("weapons/bows/crossbow_back.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "deploy") { OnDeploy(); return true; }
		if (name == "pickup") { OnPickup(); return true; }
		if (name == "register_shoot") { OnRegisterShoot(); return true; }
		if (name == "removefromowner") { OnRemovefromowner(); return true; }
		if (name == "shoot") { OnShoot(); return true; }
		if (name == "shoot_done") { OnShootDone(); return true; }
		if (name == "shoot_fire") { OnShootFire(); return true; }
		if (name == "shoot_returnstanding") { OnShootReturnstanding(); return true; }
		if (name == "switchhands") { OnSwitchhands(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		if (name == "wear") { OnWear(); return true; }
		return BaseWeaponScript::DispatchEvent(name, params);
	}
}
