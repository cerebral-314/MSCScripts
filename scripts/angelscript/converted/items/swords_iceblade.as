#pragma context server

// Converted from items/swords_iceblade.script by msc_transpiler.
// Iceblade by Thothie (from Skull Blade)

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"
#include "converted/items/base_varied_attacks.as"

[script "items/swords_iceblade"]
class SwordsIceblade : SwordsBaseOnehandedScript, BaseVariedAttacks
{
	// Constants
	string BASE_LEVEL_REQ = "12";
	string FREEZE_CHANCE = "75";
	int ANIM_ATTACK4 = 5;
	int ANIM_ATTACK5 = 6;
	string ANIM_LUNGE = "6";
	int MODEL_VIEW_IDX = 2;
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables (an unset .script variable reads as its own name)
	int SWING_ANIM = 0;
	int SPEC_ATTACK = 0;
	int GAME_PVP = 0;

	// Variables declared by included files, with the value they start with in this script
	SwordsIceblade()
	{
		ANIM_IDLE_DELAY_LOW = 1;
		ANIM_IDLE_DELAY_HIGH = 3;
		ATTACK_ANIMS = 4;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "8";
		ANIM_PREFIX = "iceblade";
		MELEE_RANGE = "64";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.4f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 315;
		MELEE_DMG_RANGE = 10;
		MELEE_DMG_TYPE = "cold";
		MELEE_ACCURACY = "70%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
		SOUND_HITWALL1 = "debris/glass1.wav";
		SOUND_HITWALL2 = "debris/glass2.wav";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SwordsIceblade_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			SPEC_ATTACK = 0;

		if (!hit)
			return result;

		CBaseEntity@ enemyHit = target;

		if (IsPlayer(enemyHit) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		if (SPEC_ATTACK == 1)
		{
			int freezeRoll = RandomInt(1, 100);

			// dbg Rolled FREEZE_ROLL Need FREEZE_CHANCE or less
			if (freezeRoll > Float(FREEZE_CHANCE))
			{
				OwnerMessage("Freeze attack failed.");
				PlaySound(2, Eval("const.snd.fullvol"), "debris/zap1.wav");
			}

			if (freezeRoll <= Float(FREEZE_CHANCE))
			{
				float nmeMaxhp = HealthOf(target);
				if (nmeMaxhp > 1000.0f)
				{
					PlaySound(2, Eval("const.snd.fullvol"), "debris/zap1.wav");
					OwnerMessage("This enemy is too strong to be affected by your sword's magic!");
				}
				if (nmeMaxhp < 1000.0f)
				{
					ApplyEffect(enemyHit, "effects/dot_cold", 5, @EntityOf(ENT_OWNER), 10, "swordsmanship");
					OwnerMessage("The Ice Blade's magic has frozen your enemy!");
					PlaySound(2, Eval("const.snd.fullvol"), "debris/beamstart14.wav");
				}
			}
		}

		SPEC_ATTACK = 0;
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

		SetName("Ice Blade");
		SetDescription("A blade of enchanted cold steel");
		SetWeight(80);
		SetValue(1000);
		SetHudSprite("trade", "10");
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

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SwordsIceblade_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVariedAttacks_DispatchEvent(name, params)
			|| SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
