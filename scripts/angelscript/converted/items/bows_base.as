#pragma context server

// Converted from items/bows_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_ranged.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BowsBase
{
	// Constants
	string ANIM_IDLE1 = "0";
	string ANIM_DEPLOY = "1";
	int ANIM_STRETCH = 2;
	string ANIM_FIRE = "3";
	string ANIM_PREFIX = "bow";
	string RANGED_HOLD_MINMAX = "1.1;1.3";
	string RANGED_ATK_DURATION = "RANGED_POSTFIRE_DELAY";
	string RANGED_DMG_TYPE = "pierce";
	string RANGED_STAT = "archery";
	string RANGED_PROJECTILE = "arrow";
	Vector3 RANGED_AIMANGLE = Vector3();
	float RANGED_PULLTIME = 0.8f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_BOW = true;
	bool STRETCHED = false;

	// unnamed block (first think)
	void BowsBase_FirstThink()
	{
		STRETCHED = false;

		IS_BOW = true;
	}

	// weapon_spawn
	void BowsBase_OnWeaponSpawn()
	{
		if (!Truthy(GetVar("NOT_WEARABLE")))
			SetWearable(1, "bow");
		SetAnimExtension("bow");
		SetHand("both");
		SetHudSprite("hand", "bow");
		SetHudSprite("trade", ITEM_NAME);
		RegisterAttack();
		OnBowSpawn();
	}

	// ranged_start
	// Call from dll
	void BowsBase_OnRangedStart()
	{
		STRETCHED = false;
		PlayViewAnim(ANIM_STRETCH);
		PlayOwnerAnim("critical", "bow_pull", "global.anim.combatwalk");
		CallEventDelayed(RANGED_PULLTIME, "ranged_stretchbow");
	}

	// ranged_stretchbow
	void BowsBase_OnRangedStretchbow()
	{
		STRETCHED = true;
		PlayOwnerAnim("critical", "bow_hold", "global.anim.combatwalk");
		OnBasebowStretchbow();
	}

	// unnamed block (timer)
	// Stretched animation loop
	void BowsBase_Timer()
	{
		CallEventDelayed(3.35f, "BowsBase_Timer");

		if ((STRETCHED ? 1 : 0) != 1)
			return;
		PlayOwnerAnim("critical", "bow_hold", "global.anim.combatwalk");
	}

	// ranged_toss
	// Called from dll
	void BowsBase_OnRangedToss()
	{
		PlaySound(Int(Eval("game.sound.weapon")), Eval("game.sound.maxvol"), SOUND_SHOOT);
		PlayViewAnim(Int(ANIM_FIRE));
		// playowneranim break
		PlayOwnerAnim("critical", "bow_release", "global.anim.combatwalk");
		STRETCHED = false;
		CallEventDelayed(0.4f, "shoot_returnstanding");
	}

	// ranged_end
	// Called from dll
	void BowsBase_OnRangedEnd()
	{
		PlayViewAnim(Int(ANIM_IDLE1));
	}

	// shoot_returnstanding
	void BowsBase_OnShootReturnstanding()
	{
		if (Truthy(Eval("game.item.attacking")))
			return;
		PlayOwnerAnim("critical", "bow_aim_to_stand", "global.anim.combatwalk");
	}

	// game_wear
	void BowsBase_OnGameWear(string race = "", string gender = "", string source = "")
	{
		SetModel(MODEL_WEAR);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 3.0f;
		// add		L_SUBMODEL 1 //for new p_body
		SetModelBody(0, int(submodel));
	}

	// game_show
	void BowsBase_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		SetModel(MODEL_WEAR);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 3.0f;
		SetModelBody(0, int(submodel));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BowsBase_OnGameWear(race, gender, source);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseRanged_OnWeaponSpawn(); // items/base_ranged
		BowsBase_OnWeaponSpawn();
	}

	void OnRangedStart() { BowsBase_OnRangedStart(); } // ranged_start
	void OnRangedStretchbow() { BowsBase_OnRangedStretchbow(); } // ranged_stretchbow
	void OnRangedToss() { BowsBase_OnRangedToss(); } // ranged_toss
	void OnRangedEnd() { BowsBase_OnRangedEnd(); } // ranged_end
	void OnShootReturnstanding() { BowsBase_OnShootReturnstanding(); } // shoot_returnstanding
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { BowsBase_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnRangedPulltime() {} // RANGED_PULLTIME
	void OnBasebowStretchbow() {} // basebow_stretchbow
	void OnBowSpawn() {} // bow_spawn

	// This file's events and timers by their .script names
	bool BowsBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "ranged_end") { OnRangedEnd(); return true; }
		if (name == "ranged_start") { OnRangedStart(); return true; }
		if (name == "ranged_stretchbow") { OnRangedStretchbow(); return true; }
		if (name == "ranged_toss") { OnRangedToss(); return true; }
		if (name == "shoot_returnstanding") { OnShootReturnstanding(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		if (name == "BowsBase_Timer") { BowsBase_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/bows_base"]
shared class BowsBaseScript : BaseRangedScript, BowsBase
{
	// Variables declared by included files, with the value they start with in this script
	BowsBaseScript()
	{
		IS_BOW = true;
		ANIM_DEPLOY = "1";
		ANIM_STRETCH = 2;
		ANIM_FIRE = "3";
		ANIM_PREFIX = "bow";
		RANGED_HOLD_MINMAX = "1.1;1.3";
		RANGED_ATK_DURATION = "RANGED_POSTFIRE_DELAY";
		RANGED_STAT = "archery";
		RANGED_PROJECTILE = "arrow";
		RANGED_PULLTIME = 0.8f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BowsBase_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BowsBase_DispatchEvent(name, params)
			|| BaseRangedScript::DispatchEvent(name, params);
	}
}
