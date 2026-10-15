#pragma context server

// Converted from items/gauntlets_normal.script by msc_transpiler.
// Note: This item name breaks convention - though it might not be a bad idea to have gauntets have their own item prefix, likely too late now.
// Gauntlet's by Thothie, from fists_bare
// Model/Concept by Jester
// - Jester also discoverd that game_hitwall does not work - just use hitwall
// - Thothie wonders how many other script functions are busted due to that break in convention

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"
#include "converted/items/base_kick.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GauntletsNormal
{
	// Constants
	bool NO_IDLE = true;
	bool MELEE_OVERRIDE = true;
	int ANIM_HANDS_DOWN = 3;
	int ANIM_LIFT1 = 2;
	string ANIM_LOWER = "3";
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "4";
	int ANIM_SHEATH = 3;
	string MODEL_VIEW = "viewmodels/v_martialarts.mdl";
	int MODEL_VIEW_IDX = 2;
	string MODEL_BODY_OFS = "54";
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/axemetal1.wav";
	string SOUND_HITWALL2 = "weapons/axemetal2.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string ANIM_PREFIX = "gauntlets";
	bool NO_WORLD_MODEL = true;
	string MELEE_RANGE = "50";
	float MELEE_DMG_DELAY = 0.3f;
	float MELEE_ATK_DURATION = 0.9f;
	float MELEE_ENERGY = 1.0f;
	int MELEE_DMG = 80;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "blunt";
	string MELEE_ACCURACY = "75%";
	string MELEE_STAT = "martialarts";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "5%";
	string PLAYERANIM_AIM = "fists";

	// Variables (an unset .script variable reads as its own name)
	int PUNCH_ATTACK = 0;
	float FISTS_LAST_ATTACK = 0.0f;

	// weapon_spawn
	void GauntletsNormal_OnWeaponSpawn()
	{
		SetName("a set of|Gauntlets");
		SetDescription("Strong metal gauntlets for otherwise unarmed combat");
		SetWeight(3);
		SetValue(200);
		SetHand("both");
		SetHudSprite("hand", "gauntlets");
		SetHudSprite("trade", "gauntlets");
	}

	// weapon_deploy
	void GauntletsNormal_OnWeaponDeploy()
	{
		PlayViewAnim(ANIM_HANDS_DOWN);
	}

	// melee_start
	void GauntletsNormal_OnMeleeStart()
	{
		string punchAnim = "l.punch_anim";

		PlayViewAnim(Int(ANIM_ATTACK1));

		if (PUNCH_ATTACK == 0)
		{
			punchAnim = "stance_normal_lowjab_r1";
			PUNCH_ATTACK = 1;
		}
		else if (PUNCH_ATTACK == 1)
		{
			punchAnim = "stance_normal_lowjab_r2";
			PUNCH_ATTACK = 0;
		}

		PlayOwnerAnim("once", punchAnim, "global.anim.combatwalk", 3);

		PlaySound(Int(Eval("const.sound.item")), 5, SOUND_SWING);
		FISTS_LAST_ATTACK = GameTime();
		OnPunch1Done(); // Lower fists in 5 seconds
	}

	// punch1_done
	void GauntletsNormal_OnPunch1Done()
	{
		CallEventDelayed(1.0f, "punch1_done");

		if (int(FISTS_LAST_ATTACK) == 0)
			return;
		float elapsedtime = GameTime() - FISTS_LAST_ATTACK;

		if (!(elapsedtime > 5.0f))
			return;

		PlayViewAnim(Int(ANIM_LOWER));
		FISTS_LAST_ATTACK = 0.0f;
	}

	// hitwall
	void GauntletsNormal_OnHitwall()
	{
		// //dbg hitwall fired
		PlayRandomSound(2, 10, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		GauntletsNormal_OnWeaponSpawn();
	}

	// hitwall
	void OnHitwall()
	{
		BaseMelee_OnHitwall(); // items/base_melee
		GauntletsNormal_OnHitwall();
	}

	void OnRegisterCharge1() { BaseKick_OnRegisterCharge1(); } // register_charge1
	void OnWeaponDeploy() { GauntletsNormal_OnWeaponDeploy(); } // weapon_deploy
	void OnMeleeStart() { GauntletsNormal_OnMeleeStart(); } // melee_start
	void OnPunch1Done() { GauntletsNormal_OnPunch1Done(); } // punch1_done

	// This file's events and timers by their .script names
	bool GauntletsNormal_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "punch1_done") { OnPunch1Done(); return true; }
		if (name == "weapon_deploy") { OnWeaponDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/gauntlets_normal"]
shared class GauntletsNormalScript : BaseMeleeScript, GauntletsNormal, BaseKick
{
	// Variables declared by included files, with the value they start with in this script
	GauntletsNormalScript()
	{
		ANIM_LIFT1 = 2;
		ANIM_IDLE1 = "1";
		MODEL_VIEW = "viewmodels/v_martialarts.mdl";
		MODEL_BODY_OFS = "54";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		ANIM_PREFIX = "gauntlets";
		PLAYERANIM_AIM = "fists";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_martialarts.mdl");
		Precache("weapons/martialarts/foot.mdl");
		CallEventDelayed(1.0f, "punch1_done");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GauntletsNormal_DispatchEvent(name, params)
			|| BaseKick_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
