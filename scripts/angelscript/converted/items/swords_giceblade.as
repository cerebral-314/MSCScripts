#pragma context server

// Converted from items/swords_giceblade.script by msc_transpiler.
// Iceblade by Thothie (from Skull Blade)

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"
#include "converted/items/base_varied_attacks.as"

[script "items/swords_giceblade"]
class SwordsGiceblade : SwordsBaseOnehandedScript, BaseVariedAttacks
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	string FREEZE_CHANCE = "65";
	int FREEZE_MP = 5;
	int ANIM_ATTACK4 = 5;
	int ANIM_ATTACK5 = 6;
	string ANIM_LUNGE = "6";
	int MODEL_VIEW_IDX = 3;
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	int SWING_ANIM = 0;
	int SPEC_ATTACK = 0;

	// Variables declared by included files, with the value they start with in this script
	SwordsGiceblade()
	{
		ANIM_IDLE_DELAY_LOW = 1;
		ANIM_IDLE_DELAY_HIGH = 3;
		ATTACK_ANIMS = 4;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "52";
		ANIM_PREFIX = "skullblade";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.4f;
		MELEE_ENERGY = 5.0f;
		MELEE_DMG = 320;
		MELEE_DMG_RANGE = 30;
		MELEE_DMG_TYPE = "cold";
		MELEE_ACCURACY = "72%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
		SOUND_HITWALL1 = "debris/glass1.wav";
		SOUND_HITWALL2 = "debris/glass2.wav";
	}

	// special_01_damaged_other
	// PARAM1=target_hit PARAM2=dmg
	string SwordsGiceblade_OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!(ManaOf(ENT_OWNER) >= 10.0f))
			return result;
		GiveMana(ENT_OWNER, -FREEZE_MP);

		if (RandomInt(1, 100) > Float(FREEZE_CHANCE))
		{
			OwnerMessage("Freeze attack failed.");
			PlaySound(2, 10, "debris/zap1.wav");
		}
		else if (IsPlayer(target))
		{
			if (IsPvp())
				ApplyEffect(target, "effects/dot_cold_freeze", Random(5, 7), @EntityOf(ENT_OWNER));
		}
		else
		{
			float monHp = HealthOf(target);
			if (monHp > 1500.0f)
				OwnerMessage(NameOf(target) + " is too strong to be affected!");
			if (monHp <= 1500.0f)
			{
				if (DamageTakenOf(target, "cold") > 0.0f)
				{
					OwnerMessage("Your sword's magic has encased your enemy in ice!");
					// callexternal PARAM1 freeze_solid $randf(5,7) $get(ent_me,id)
					ApplyEffect(target, "effects/dot_cold_freeze", Random(5, 7), @EntityOf(ENT_OWNER));
					PlaySound(2, 10, "debris/beamstart14.wav");
				}
				else
				{
					OwnerMessage(NameOf(target) + " is immune to ice magic!");
				}
			}
		}
		return result;
	}

	// melee_damaged_other
	// PARAM1=target_hit PARAM2=dmg
	string SwordsGiceblade_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool exitSub = false;
		string result = "";

		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		int rndFreeze = RandomInt(1, 3);
		if (rndFreeze == 1)
		{
			float freezeDmg = SkillOf(ENT_OWNER, "spellcasting.ice") * 0.25f;
			ApplyEffect(target, "effects/dot_cold", 5.0f, @EntityOf(ENT_OWNER), freezeDmg, "spellcasting.ice");
		}
		return result;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee
		GAME_PVP = (IsPvp() ? 1 : 0);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Greater Ice Blade");
		SetDescription("An ancient blade of enchanted crystal");
		SetWeight(80);
		SetValue(3500);
		SetHudSprite("trade", "96");
	}

	// melee_damaged_other
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SwordsGiceblade_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// melee_start
	void OnMeleeStart()
	{
		// local SWING $rand(1,ATTACK_ANIMS)
		// local SWING_ANIM ANIM_ATTACK1
		// if( SWING == 2 ) setvard SWING_ANIM ANIM_ATTACK2
		// else if( SWING == 3 ) setvard SWING_ANIM ANIM_ATTACK3
		// else if( SWING == 4 ) setvard SWING_ANIM ANIM_ATTACK4
		// else if( SWING == 5 ) setvard SWING_ANIM ANIM_ATTACK5
		PlaySound(1, 10, SOUND_SWIPE);

		PlayOwnerAnim("once", "sword_swing"); // global.anim.combatwalk 3
		OnCheckAttackAnim();
		SWING_ANIM = CUR_ATTACK_ANIM;
		PlayItemViewAnim(ENT_ME, SWING_ANIM);
	}

	// special_01_start
	void OnSpecial01Start()
	{
		PlayOwnerAnim("once", "axe_twohand_swing");
		SPEC_ATTACK = 1;
		PlayViewAnim(Int(ANIM_LUNGE));
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SPECIAL01_SND);
	}

	string OnSpecial01DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return SwordsGiceblade_OnSpecial01DamagedOther(target, damage, damageType, damageEvent); } // special_01_damaged_other

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hswordssb.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "special_01_damaged_other") { Return(OnSpecial01DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVariedAttacks_DispatchEvent(name, params)
			|| SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
