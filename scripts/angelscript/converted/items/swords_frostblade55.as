#pragma context server

// Converted from items/swords_frostblade55.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_twohanded.as"

[script "items/swords_frostblade55"]
class SwordsFrostblade55 : SwordsBaseTwohandedScript
{
	// Constants
	bool MELEE_OVERRIDE = true;
	int SPECIAL_OVERRIDE = 1;
	bool CUSTOM_REGISTER_CHARGE1 = true;
	string SOUND_CHARGE = "magic/ice_powerup.wav";
	string SOUND_SHOOT = "magic/ice_strike2.wav";
	string RANGED_HOLD_MINMAX = "1.1;1.3";
	string RANGED_ATK_DURATION = "0.3";
	string RANGED_PROJECTILE = "proj_icelance";
	Vector3 RANGED_AIMANGLE = Vector3();
	Vector3 RANGED_STARTPOS = Vector3();
	float RANGED_PULLTIME = 0.8f;
	int RANGED_MP = 15;
	int CIRCLE_DRAIN = 40;
	string ANIM_LUNGE = "3";
	int ANIM_PARRY1 = 4;
	int ANIM_PARRY1_RETRACT = 5;
	int ANIM_PARRY_DEBUG = 4;
	int ANIM_UNPARRY_DEBUG = 5;
	string MELEE_NEW_PARRY_CHANCE = "50";

	// Variables (an unset .script variable reads as its own name)
	bool PARRY_ON = false;
	float NEXT_DELAY_MSG = 0.0f;
	float ATTACK_DELAY = 0.0f;
	bool ATTACK_ON = false;

	// Variables declared by included files, with the value they start with in this script
	SwordsFrostblade55()
	{
		SOUND_PARRY = "weapons/parry.wav";
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		ATTACK_ANIMS = 1;
		ANIM_UNSHEATH = 6;
		ANIM_SHEATH = 7;
		MODEL_VIEW = "viewmodels/v_2hswords.mdl";
		MODEL_VIEW_IDX = 5;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		SOUND_DRAW = "weapons/swords/sworddraw.wav";
		BASE_LEVEL_REQ = "20";
		MODEL_BODY_OFS = "4";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.3f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 350;
		MELEE_DMG_RANGE = 75;
		MELEE_DMG_TYPE = "cold";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "3,10";
		MELEE_ALIGN_TIP = "0,-10";
		MELEE_PARRY_CHANCE = "60%";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "sword_double_swing";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SwordsBaseTwohanded_OnWeaponSpawn(); // items/swords_base_twohanded

		SetName("Hoarfrost Shard");
		SetDescription("A gigantic blade of pure elemental ice");
		SetWeight(75);
		SetValue(4000);
		SetHudSprite("trade", "124");

		SetHand("both");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee
		SwordsBaseTwohanded_OnRegisterCharge1(); // items/swords_base_twohanded

		SetLocal("reg.attack.mpdrain", RANGED_MP);
		SetLocal("reg.attack.ammodrain", 0);

		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.hold_min&max", "1;1");
		SetLocal("reg.attack.dmg.type", "cold");
		SetLocal("reg.attack.range", 500);
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", "swordsmanship");
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.projectile", "proj_icelance");
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", "RANGED_DMG_DELAY");
		SetLocal("reg.attack.delay.end", RANGED_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", RANGED_STARTPOS);
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.noise", "RANGED_NOISE");

		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "ice_shard");
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 22);
		RegisterAttack();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		AxesBaseOnehanded_OnMeleeStart(); // items/axes_base_onehanded
		int swingAnim = 0;

		int swing = RandomInt(1, 3);
		if (swing == 1)
			swingAnim = Int(ANIM_ATTACK1);
		if (swing == 2)
			swingAnim = Int(ANIM_ATTACK2);
		if (swing == 3)
			swingAnim = Int(ANIM_ATTACK3);
		PlayOwnerAnim("once", "sword_double_swing");
		PlayViewAnim(swingAnim);
		PlaySound(1, 10, SOUND_SWIPE);
	}

	// parryanim
	void OnParryanim()
	{
		SwordsBaseTwohanded_OnParryanim(); // items/swords_base_twohanded

		// WTF WON'T THIS PLAY!??! - Thothie (frustrated)
		PlayViewAnim(ANIM_PARRY1);
		// playviewanim critical parry1
		// playowneranim once sword_swing
		PlaySound(0, 10, SOUND_PARRY);
		CallEventDelayed(0.75f, "unparryanim");
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		SwordsBaseTwohanded_OnGamePressAttack2(); // items/swords_base_twohanded

		if (GameTime() > NEXT_DELAY_MSG && int(ATTACK_DELAY) != 0)
		{
			PlayerMessageDark(ENT_OWNER, "Hoarfrost Shard: Needs time to recharge.");
			NEXT_DELAY_MSG = GameTime() + 0.5f;
		}

		if (int(ATTACK_DELAY) != 0)
			return;
		ATTACK_DELAY = 1.0f;
		CallEventDelayed(10.0f, "attack_delay_reset");
		ATTACK_ON = true;
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		SwordsBaseTwohanded_OnGameReleaseAttack2(); // items/swords_base_twohanded
		bool doAttack;

		if (!ATTACK_ON)
			return;
		ATTACK_ON = false;

		doAttack = true;
		if (ManaOf(ENT_OWNER) <= CIRCLE_DRAIN)
			doAttack = false;
		if (!doAttack)
			PlayerMessageDark(ENT_OWNER, "Hoarfrost Shard: Insufficient mana.");
		if (!CanAttack(ENT_OWNER))
		{
			PlayerMessageDark(ENT_OWNER, "Can't attack now...");
			doAttack = false;
		}

		// playviewanim must be client side
		// I can't figure a way to make the server-side DO_ATTACK var stop this from playing

		if (!doAttack)
			return;

		// playrandomsound const.sound.item 10 SOUND_SWING SOUND_CHARGE
		GiveMana(-CIRCLE_DRAIN);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

		PlayOwnerAnim("once", "throw_fireball", "global.anim.combatwalk", 3);

		float cfrostDamage = SkillOf(ENT_OWNER, "swordsmanship") * 1.25f;
		CreateNpc("monsters/summon/circle_of_ice_player", OriginOf(ENT_OWNER), @EntityOf(ENT_OWNER), 15, 5, cfrostDamage, "swordsmanship");
	}

	// melee_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnMeleeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (RandomInt(1, 5) != 1)
			return;
		if (!IsAlive(hitEntity))
			return;
		if (RelationshipOf(hitEntity, ENT_OWNER) != "enemy")
			return;
		if (IsPlayer(hitEntity))
		{
			bool pvpSet = IsPvp();
			if ((pvpSet ? 1 : 0) == 0)
				exitSub = true;
		}
		if (exitSub)
			return;
		ApplyEffect(hitEntity, "effects/dot_cold", 5, @EntityOf(ENT_OWNER), Random(5, 15), "swordsmanship");
	}

	// ice_shard_start
	void OnIceShardStart()
	{
		PlayViewAnim(Int(ANIM_LUNGE));
		PlayOwnerAnim("once", "axe_twohand_swing");
		if (!(ManaOf(ENT_OWNER) > RANGED_MP))
			return;
		PlaySound(Int(Eval("const.snd.weapon")), Eval("const.snd.maxvol"), SOUND_SHOOT);
	}

	// ice_shard_toss
	void OnIceShardToss()
	{
		CallExternal(ENT_LASTPROJECTILE, "ext_dot_stat", "swordsmanship"); // lance dot trains swordsmanship, not ice
	}

	// blockmode_start
	void OnBlockmodeStart()
	{
		PlayViewAnim(ANIM_PARRY1);
		PlayOwnerAnim("once", "sword_swing");
		PARRY_ON = true;
	}

	// blockmode_end
	void OnBlockmodeEnd()
	{
		PlayViewAnim(ANIM_PARRY1_RETRACT);
		PARRY_ON = false;
	}

	// unparryanim
	void OnUnparryanim()
	{
		PlayViewAnim(ANIM_PARRY1_RETRACT);
	}

	// attack_delay_reset
	void OnAttackDelayReset()
	{
		ATTACK_DELAY = 0.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2hswords.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_delay_reset") { OnAttackDelayReset(); return true; }
		if (name == "blockmode_end") { OnBlockmodeEnd(); return true; }
		if (name == "blockmode_start") { OnBlockmodeStart(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "ice_shard_start") { OnIceShardStart(); return true; }
		if (name == "ice_shard_toss") { OnIceShardToss(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "melee_strike") { OnMeleeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "parryanim") { OnParryanim(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "unparryanim") { OnUnparryanim(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseTwohandedScript::DispatchEvent(name, params);
	}
}
