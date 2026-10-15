#pragma context server

// Converted from items/blunt_gauntlets_fire.script by msc_transpiler.
// Gauntlet's of Fire by Thothie (from Gauntlets_Normal)
// Model/Concept by Jester
// - Jester also discoverd that game_hitwall does not work - just use hitwall
// - Thothie wonders how many other script functions are busted due to that break in convention

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"
#include "converted/items/base_kick.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntGauntletsFire
{
	// Constants
	bool MELEE_OVERRIDE = true;
	bool SPECIAL1_OVERRIDE = true;
	string MELEE_CALLBACK = "gaunt";
	string DOT_EFFECT = "effects/dot_fire";
	string BASE_LEVEL_REQ = "15";
	int ANIM_HANDS_DOWN = 3;
	int ANIM_LIFT1 = 2;
	string ANIM_LOWER = "3";
	string ANIM_IDLE1 = "1";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "4";
	int ANIM_SHEATH = 3;
	string MODEL_VIEW = "viewmodels/v_martialarts.mdl";
	int MODEL_VIEW_IDX = 3;
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_HITWALL1 = "weapons/axemetal1.wav";
	string SOUND_HITWALL2 = "ambience/steamburst1.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string MODEL_BODY_OFS = "56";
	bool NO_WORLD_MODEL = true;
	string ANIM_PREFIX = "gauntlets";
	string MELEE_RANGE = "40";
	float MELEE_DMG_DELAY = 0.3f;
	float MELEE_ATK_DURATION = 0.9f;
	float MELEE_ENERGY = 1.0f;
	int MELEE_DMG = 100;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "fire";
	string MELEE_ACCURACY = "75%";
	string MELEE_STAT = "martialarts";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "10%";
	string PLAYERANIM_AIM = "fists";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	int PUNCH_ATTACK = 0;
	float FISTS_LAST_ATTACK = 0.0f;
	float BWEAPON_CHARGE_PERCENT = 0.0f;

	// weapon_spawn
	void BluntGauntletsFire_OnWeaponSpawn()
	{
		SetName("Gauntlets of Fire");
		SetDescription("These magical gauntlets are infused with elemental fire");
		SetWeight(3);
		SetValue(2500);
		SetHand("both");
		SetHudSprite("hand", "97");
		SetHudSprite("trade", "97");
	}

	// weapon_deploy
	void BluntGauntletsFire_OnWeaponDeploy()
	{
		GAME_PVP = (IsPvp() ? 1 : 0);
		PlayViewAnim(ANIM_HANDS_DOWN);
	}

	// gaunt_start
	void BluntGauntletsFire_OnGauntStart()
	{
		string punchAnim = "l.punch_anim";

		// dbg melee_start
		PlayViewAnim(Int(MELEE_VIEWANIM_ATK));

		// infomsg ent_owner ATTACK_ANIM MELEE_VIEWANIM_ATK
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
	void BluntGauntletsFire_OnPunch1Done()
	{
		// repeatdelay 1
		if (int(FISTS_LAST_ATTACK) == 0)
			return;
		float elapsedtime = GameTime() - FISTS_LAST_ATTACK;

		if (!(elapsedtime > 5.0f))
			return;

		PlayViewAnim(Int(ANIM_LOWER));
		FISTS_LAST_ATTACK = 0.0f;
	}

	// hitwall
	void BluntGauntletsFire_OnHitwall()
	{
		// //dbg hitwall fired
		PlayRandomSound(2, 10, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// item_idle
	void BluntGauntletsFire_OnItemIdle()
	{
	}

	// gaunt_damaged_other
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string BluntGauntletsFire_OnGauntDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool exitSub = false;
		string result = "";

		if (RandomInt(1, 2) != 1)
			return result;

		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		float burnDamage = Divide(SkillOf(ENT_OWNER, "spellcasting.fire"), 1.5f) + Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;

		ApplyEffect(target, DOT_EFFECT, 5, @EntityOf(ENT_OWNER), burnDamage, "martialarts");
		return result;
	}

	// gaunt_damaged_other
	string BluntGauntletsFire_OnGauntDamagedOther_2(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (BWEAPON_CHARGE_PERCENT > 0.25f)
		{
			BWEAPON_CHARGE_PERCENT -= 0.25f;

			float chargeRatio = Ratio(BWEAPON_CHARGE_PERCENT, 1.25f, BWEAPON_DBL_CHARGE_ADJ);

			float newDmg = damage * chargeRatio;
			SetDamageInfo("dmg", newDmg);
			result = AppendResult(result, Text(chargeRatio));
			DebugPrint("Adjusted dmg x " + Text(chargeRatio));
			BWEAPON_CHARGE_PERCENT = 0.0f;

			float curDrain = MELEE_ENERGY * BWEAPON_CHARGE_PERCENT;
			LegacyCommand("drainstamina", ENT_OWNER, curDrain);
		}
		return result;
	}

	// gaunt_playsound
	void BluntGauntletsFire_OnGauntPlaysound()
	{
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SOUND_SWIPE);
	}

	// special_01_start
	void BluntGauntletsFire_OnSpecial01Start()
	{
		OnGauntStart();
		ServerPlaySound(1, 10, SPECIAL01_SND);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntGauntletsFire_OnWeaponSpawn();
	}

	// special_01_start
	void OnSpecial01Start()
	{
		BaseMelee_OnSpecial01Start(); // items/base_melee
		BluntGauntletsFire_OnSpecial01Start();
	}

	// hitwall
	void OnHitwall()
	{
		BaseMelee_OnHitwall(); // items/base_melee
		BluntGauntletsFire_OnHitwall();
	}

	void OnRegisterCharge1() { BaseKick_OnRegisterCharge1(); } // register_charge1
	void OnWeaponDeploy() { BluntGauntletsFire_OnWeaponDeploy(); } // weapon_deploy
	void OnGauntStart() { BluntGauntletsFire_OnGauntStart(); } // gaunt_start
	void OnPunch1Done() { BluntGauntletsFire_OnPunch1Done(); } // punch1_done
	void OnItemIdle() { BluntGauntletsFire_OnItemIdle(); } // item_idle

	// gaunt_damaged_other
	string OnGauntDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BluntGauntletsFire_OnGauntDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BluntGauntletsFire_OnGauntDamagedOther_2(target, damage, damageType, damageEvent));
		return result;
	}

	void OnGauntPlaysound() { BluntGauntletsFire_OnGauntPlaysound(); } // gaunt_playsound

	// This file's events and timers by their .script names
	bool BluntGauntletsFire_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "gaunt_damaged_other") { Return(OnGauntDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "gaunt_playsound") { OnGauntPlaysound(); return true; }
		if (name == "gaunt_start") { OnGauntStart(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "item_idle") { OnItemIdle(); return true; }
		if (name == "punch1_done") { OnPunch1Done(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_deploy") { OnWeaponDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_gauntlets_fire"]
shared class BluntGauntletsFireScript : BaseMeleeScript, BluntGauntletsFire, BaseKick
{
	// Variables every script that includes this file declares
	string SOUND_BITE = "SOUND_BITE";

	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsFireScript()
	{
		MELEE_CALLBACK = "gaunt";
		ANIM_LIFT1 = 2;
		ANIM_IDLE1 = "1";
		MODEL_VIEW = "viewmodels/v_martialarts.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "56";
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
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntGauntletsFire_DispatchEvent(name, params)
			|| BaseKick_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
