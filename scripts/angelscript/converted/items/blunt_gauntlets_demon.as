#pragma context server

// Converted from items/blunt_gauntlets_demon.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"
#include "converted/items/base_kick.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BluntGauntletsDemon
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	float DEMON_STRIKE_RATIO = 3.0f;
	bool NO_IDLE = true;
	int ANIM_HANDS_DOWN = 9;
	int ANIM_LIFT1 = 1;
	string ANIM_LOWER = "0";
	string ANIM_IDLE1 = "0";
	int ANIM_IDLE_TOTAL = 1;
	string ANIM_ATTACK1 = "5";
	string ANIM_ATTACK2 = "6";
	string ANIM_ATTACK3 = "7";
	int ANIM_ATTACK4 = 8;
	int ANIM_SPEC_ATTACK = 3;
	int ANIM_SHEATH = 5;
	string MODEL_VIEW = "viewmodels/v_martialarts_claws.mdl";
	string MODEL_HANDS = "weapons/p_weapons2.mdl";
	string MODEL_WORLD = "weapons/p_weapons2.mdl";
	string MODEL_BODY_OFS = "116";
	int MELEE_DMG = 180;
	int MELEE_DMG_RANGE = 0;
	string MELEE_DMG_TYPE = "slash";
	string MELEE_ACCURACY = "85%";
	float MELEE_DMG_DELAY = 0.3f;
	float MELEE_ATK_DURATION = 0.9f;
	float DEMON_MELEE_DMG_DELAY = 0.1f;
	float DEMON_MELEE_ATK_DURATION = 0.3f;
	string SOUND_SWIPE = "zombie/claw_miss1.wav";
	string SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
	string SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	string SOUND_SWING = "zombie/claw_miss2.wav";
	string SOUND_DEPLOY = "weapons/swords/sworddraw.wav";
	string SOUND_LUNGE = "zombie/claw_miss1.wav";
	string ANIM_PREFIX = "gauntlets";
	bool NO_WORLD_MODEL = true;
	string MELEE_RANGE = "50";
	int REACH_MELEE_RANGE = 100;
	float MELEE_ENERGY = 1.0f;
	string MELEE_STAT = "martialarts";
	string MELEE_VIEWANIM_ATK = "MELEE_VIEWANIM_ATK";
	string MELEE_SOUND = "MELEE_SOUND";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "5%";
	string PLAYERANIM_AIM = "axe_onehand";

	// Variables (an unset .script variable reads as its own name)
	bool DEMON_MODE = false;
	int PUNCH_ATTACK = 0;
	float FISTS_LAST_ATTACK = 0.0f;
	bool DEBUG_ATTACK = false;
	float ATTACK_DELAY = 0.0f;

	// weapon_spawn
	void BluntGauntletsDemon_OnWeaponSpawn()
	{
		SetName("Demon Claws");
		SetDescription("These infernal claws can inflict massive wounds");
		SetWeight(3);
		SetValue(3000);
		SetHand("both");
		SetHudSprite("hand", "119");
		SetHudSprite("trade", "119");

		if (CUSTOM_CLAWS)
			return;
		OnRegisterDemonToggle();
		DEMON_MODE = false;
	}

	// weapon_deploy
	void BluntGauntletsDemon_OnWeaponDeploy()
	{
		PlayViewAnim(ANIM_LIFT1);
		PlaySound(0, 10, SOUND_DEPLOY);
	}

	// melee_start
	void BluntGauntletsDemon_OnMeleeStart()
	{
		string punchAnim = "l.punch_anim";

		PlayRandomSound(Int(Eval("const.sound.item")), 10, SOUND_SWING, SOUND_SWIPE);

		int rndAttack = RandomInt(1, 4);
		if (rndAttack == 1)
			PlayViewAnim(Int(ANIM_ATTACK1));
		if (rndAttack == 2)
			PlayViewAnim(Int(ANIM_ATTACK2));
		if (rndAttack == 3)
			PlayViewAnim(Int(ANIM_ATTACK3));
		if (rndAttack == 4)
			PlayViewAnim(ANIM_ATTACK4);

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

		FISTS_LAST_ATTACK = GameTime();
		OnPunch1Done(); // Lower fists in 5 seconds
	}

	// punch1_done
	void BluntGauntletsDemon_OnPunch1Done()
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
	void BluntGauntletsDemon_OnHitwall()
	{
		PlayRandomSound(2, 10, SOUND_HITWALL1, SOUND_HITWALL2);
	}

	// register_demon_toggle
	void BluntGauntletsDemon_OnRegisterDemonToggle()
	{
		SetLocal("reg.attack.type", "strike-land");
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.range", REACH_MELEE_RANGE);
		SetLocal("reg.attack.dmg", 0);
		SetLocal("reg.attack.dmg.range", 0);
		SetLocal("reg.attack.dmg.type", "magic");
		SetLocal("reg.attack.energydrain", 2);
		SetLocal("reg.attack.stat", "martialarts");
		SetLocal("reg.attack.hitchance", "90%");
		SetLocal("reg.attack.priority", 2);
		SetLocal("reg.attack.delay.strike", 0.2f);
		SetLocal("reg.attack.delay.end", 0.9f);
		SetLocal("reg.attack.ofs.startpos", "MELEE_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", "MELEE_AIMANGLE");
		SetLocal("reg.attack.callback", "demon");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.chargeamt", "200%");
		SetLocal("reg.attack.reqskill", 15);
		RegisterAttack();
	}

	// demon_start
	void BluntGauntletsDemon_OnDemonStart()
	{
		bool exitSub = false;

		// playsound 0 10 SOUND_RAWR
		if (ManaOf(ENT_OWNER) < 10.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Demon Claws: Insufficient mana for soul drain.");
			exitSub = true;
		}

		// local OWNER_TARG $get(ent_owner,target)
		// if ( !$get(OWNER_TARG,isalive) )
		// {
		// dplayermessage ent_owner Demon Claws: No target.
		// local EXIT_SUB 1
		// }
		if (exitSub)
			return;

		PlayItemViewAnim(ENT_ME, ANIM_SPEC_ATTACK);

		PlaySound(0, 10, SOUND_LUNGE);
		DEBUG_ATTACK = true;
	}

	// demon_strike
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void BluntGauntletsDemon_OnDemonStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		bool exitSub = false;

		if (!IsAlive(hitEntity))
			return;

		if ((IsPvp() ? 1 : 0) == 0 && IsPlayer(hitEntity))
			exitSub = true;
		if (exitSub)
			return;

		CBaseEntity@ ownerTarg = TargetOf(ENT_OWNER);
		float ownerMp = ManaOf(ENT_OWNER) * 0.5f;
		float negOwnerMp = -ownerMp;
		PlaySound(0, 10, "magic/eraticlightfail.wav");
		GiveMana(negOwnerMp);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback
		ownerMp *= DEMON_STRIKE_RATIO;
		DoDamageEx(@ownerTarg, REACH_MELEE_RANGE, ownerMp, "100%", ENT_OWNER, ENT_ME, "martialarts", "magic");
		// callexternal ent_owner ext_dodamage OWNER_TARG direct OWNER_MP 100% $get(ent_owner,id) magic
		Effect("screenfade", ENT_OWNER, 0.25f, 3, Vector3(0, 0, 255), 96, "fadeout");
		DEBUG_ATTACK = false;
	}

	// game_+attack2
	void BluntGauntletsDemon_OnGamePressAttack2()
	{
		bool doAttack;
		string punchAnim = "l.punch_anim";

		// if $get(ent_owner,canattack)
		if (int(ATTACK_DELAY) != 0)
			return;
		ATTACK_DELAY = 1.0f;
		CallEventDelayed(0.25f, "attack_delay_reset");

		doAttack = true;
		if (ManaOf(ENT_OWNER) <= 10.0f)
			doAttack = false;
		if (!doAttack)
			PlayerMessageDark(ENT_OWNER, "Demon Claws: Insufficient mana for speed attack.");
		if (!CanAttack(ENT_OWNER))
		{
			PlayerMessageDark(ENT_OWNER, "Can't attack now...");
			doAttack = false;
		}
		if (doAttack)
		{
			int rndAttack = RandomInt(1, 4);
			if (rndAttack == 1)
				PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK1));
			if (rndAttack == 2)
				PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK2));
			if (rndAttack == 3)
				PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK3));
			if (rndAttack == 4)
				PlayItemViewAnim(ENT_ME, ANIM_ATTACK4);
		}

		if (!doAttack)
			return;

		PlayRandomSound(Int(Eval("const.sound.item")), 10, SOUND_SWING, SOUND_SWIPE);

		GiveMana(-10);
		CallExternal(ENT_OWNER, "mana_drain"); // update mana on player hud readout, if using hud feedback

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

		FISTS_LAST_ATTACK = GameTime();
		OnPunch1Done(); // Lower fists in 5 seconds

		float dmgSet = SkillOf(ENT_OWNER, "martialarts.ratio") * MELEE_DMG * 2.0f;
		CBaseEntity@ ownerTarg = TargetOf(ENT_OWNER);
		Vector3 ownerPos = OriginOf(ENT_OWNER);
		Vector3 targPos = OriginOf(ownerTarg);
		// dbg specatk $get(OWNER_TARG,name) dmg DMG_SET rng $get(OWNER_TARG,range) dist $dist(TARG_POS,OWNER_POS) vs MELEE_RANGE
		// local OWNER_POS $get(ent_owner,origin)
		// if $get(OWNER_TARG,range) < MELE_RANGE
		// callexternal ent_owner ext_dodamage OWNER_TARG MELEE_RANGE DMG_SET 90% $get(ent_owner,id) magic
		DoDamageEx(@ownerTarg, MELEE_RANGE, dmgSet, "90%", @EntityOf(ENT_OWNER), @EntityOf(ENT_OWNER), "martialarts", "magic");
	}

	// attack_delay_reset
	void BluntGauntletsDemon_OnAttackDelayReset()
	{
		ATTACK_DELAY = 0.0f;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntGauntletsDemon_OnWeaponSpawn();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		BluntGauntletsDemon_OnMeleeStart();
	}

	// hitwall
	void OnHitwall()
	{
		BaseMelee_OnHitwall(); // items/base_melee
		BluntGauntletsDemon_OnHitwall();
	}

	void OnRegisterCharge1() { BaseKick_OnRegisterCharge1(); } // register_charge1
	void OnWeaponDeploy() { BluntGauntletsDemon_OnWeaponDeploy(); } // weapon_deploy
	void OnPunch1Done() { BluntGauntletsDemon_OnPunch1Done(); } // punch1_done
	void OnRegisterDemonToggle() { BluntGauntletsDemon_OnRegisterDemonToggle(); } // register_demon_toggle
	void OnDemonStart() { BluntGauntletsDemon_OnDemonStart(); } // demon_start
	void OnDemonStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { BluntGauntletsDemon_OnDemonStrike(hitType, endPos, hitEntity, hit); } // demon_strike
	void OnGamePressAttack2() { BluntGauntletsDemon_OnGamePressAttack2(); } // game_+attack2
	void OnAttackDelayReset() { BluntGauntletsDemon_OnAttackDelayReset(); } // attack_delay_reset

	// This file's events and timers by their .script names
	bool BluntGauntletsDemon_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_delay_reset") { OnAttackDelayReset(); return true; }
		if (name == "demon_start") { OnDemonStart(); return true; }
		if (name == "demon_strike") { OnDemonStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "punch1_done") { OnPunch1Done(); return true; }
		if (name == "register_demon_toggle") { OnRegisterDemonToggle(); return true; }
		if (name == "weapon_deploy") { OnWeaponDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/blunt_gauntlets_demon"]
shared class BluntGauntletsDemonScript : BaseMeleeScript, BluntGauntletsDemon, BaseKick
{
	// Variables every script that includes this file declares
	bool CUSTOM_CLAWS = false;
	int FIRE_WAVE_MP = 0;
	Vector3 FIRE_WAVE_SCAN_POS = Vector3();
	Vector3 FIRE_WAVE_START_POS = Vector3();
	string FIRE_WAVE_TARGS = "FIRE_WAVE_TARGS";
	float FIRE_WAVE_YAW = 0.0f;
	int GAME_PVP = 0;
	int MODEL_VIEW_IDX = 0;
	Vector3 OWNER_ANG = Vector3();
	string OWNER_ORG = "OWNER_ORG";

	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsDemonScript()
	{
		ANIM_LIFT1 = 1;
		MODEL_VIEW = "viewmodels/v_martialarts_claws.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "116";
		ANIM_PREFIX = "gauntlets";
		PLAYERANIM_AIM = "axe_onehand";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_martialarts_claws.mdl");
		Precache("weapons/martialarts/foot.mdl");
		CallEventDelayed(1.0f, "punch1_done");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BluntGauntletsDemon_DispatchEvent(name, params)
			|| BaseKick_DispatchEvent(name, params)
			|| BaseMeleeScript::DispatchEvent(name, params);
	}
}
