#pragma context server

// Converted from monsters/elemental_air0.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Air elemental (summoned) from Fire Elemental

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ElementalAir0
{
	// Constants
	float FREQ_ZAP = 0.0f;
	float FREQ_FLEE = 10.0f;
	float FREQ_REPOS = 0.0f;
	float DMG_CHAIN = 0.0f;
	int BEAM_RANGE = 2048;
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,0))";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string RETALIATE_CHANGETARGET_CHANCE = "100";
	string ATTACK_HITCHANCE = "0.8";
	int SWIPE_MOVERANGE = 65;
	int SWIPE_RANGE = 100;
	int SWIPE_HITRANGE = 150;
	int FIRE_BALL_RANGE = 2000;
	string ATTACK_ACCURACY = "80%";
	string ATTACK_DAMAGE = "$rand(50,100)";
	int CIRCLE_RANGE = 256;
	int AIM_RATIO = 50;
	int ATTACK_CONE_OF_FIRE = 2;
	int ATTACK_SPEED = 500;
	string FIRE_DAMAGE = "$rand(20,50)";
	string AMB_FIRE_DAMAGE = "$rand(10,30)";
	int FIRESEAL_DAMAGE = 200;
	string FIRE_BALL_DAMAGE = "$rand(50,100)";
	int FULL_FIRE_BALL_AMMO = 3;
	string ANIM_BASEIDLE = "idle1";
	string ANIM_FLOAT = "idle1";
	string ANIM_BUGIDLE_A = "idle1";
	string ANIM_BUGIDLE_B = "idle2";
	string ANIM_BUGIDLE_C = "dunno";
	string ANIM_CHARGE = "float";
	string ANIM_FIRE_BALL = "fireball";
	string ANIM_SWIPE = "attack1";
	string ANIM_PARRY = "block";
	string ANIM_ALERT = "yes";
	string ANIM_GLOAT = "no";
	string ANIM_SEARCH = "dunno";
	string ANIM_TOCHARGE = "tocharge";
	string ANIM_CHARGEIDLE = "charging";
	string ANIM_FROMCHARGE = "fromcharge";
	string SOUND_ALERT = "agrunt/ag_alert5.wav";
	string SOUND_IDLE1 = "agrunt/ag_alert1.wav";
	string SOUND_IDLE2 = "agrunt/ag_die1.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle1.wav";
	string SOUND_SWIPE = "weapons/debris1.wav";
	string SOUND_SWIPEHIT = "ambience/steamburst1.wav";
	string SOUND_DEATH = "garg/gar_die1.wav";
	float HURT_THRESHOLD = 0.5f;
	string SOUND_PAIN0 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain1.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain4.wav";
	string SOUND_GLOAT = "x/x_laugh1.wav";
	string SOUND_FIRECHARGE = "magic/fireball_powerup.wav";
	string SOUND_FIRESHOOT = "magic/fireball_strike.wav";
	string SOUND_CIRCLE_READY = "debris/beamstart1.wav";
	string SOUND_HOVER = "fans/fan4on.wav";
	float PLAYTIME_HOVER = 3.0f;
	string PROJ_SCRIPT = "proj_fire_ball";
	bool I_AM_TURNABLE = false;
	int MOVE_FAST = 200;
	int MOVE_NORMAL = 100;

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "idle1";
	string ANIM_RUN = "idle1";
	bool IMMUNE_VAMPIRE = false;
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	bool CAN_FLY = false;
	string CAN_HEAR = "CAN_HEAR";
	bool CAN_WANDER = false;
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_DMG_REQ = 0.0f;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_DEATH = "ANIM_DEATH";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	int MONSTER_WIDTH = 0;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	float FIRE_BALL_AMMO = 0.0f;
	int I_JUST_SPAWNED = 0;
	float MY_HURT_STAGE = 0.0f;
	bool EL_FLEE_DELAY = false;
	bool USE_SWIPE_SOUND = false;
	bool ZAP_DELAY = false;
	float LIGHTNING_COUNT = 0.0f;
	bool THROWING_FIRE_BALL = false;
	int SHOCK_AMT = 0;
	string OLD_BEAM_TARG = "OLD_BEAM_TARG";
	bool ME_SHOOTING = false;
	bool BEAM_ON = false;
	float BEAM_DURATION = 0.0f;
	float NEXT_BEAM = 0.0f;
	bool DID_SHRUG = false;
	bool GLOAT_DELAY = false;
	bool DID_WARCRY = false;
	float HOVER_LOOP_DELAY = 0.0f;
	string BEAM_ID = "BEAM_ID";

	// unnamed block (first think)
	void ElementalAir0_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;

		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_FLY = false;
		CAN_HEAR = "1";
		CAN_WANDER = true;

		CAN_RETALIATE = "1";

		// Use flinch anim if available in model
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10";
		FLINCH_ANIM = "flinch";
		FLINCH_DELAY = "1";
		FLINCH_DMG_REQ = 30.0f; // minimum damage required to make flinch check, not applied
		FLEE_DISTANCE = "4096";

		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		MOVE_RANGE = "65";

		// model will need editing
		// import gelemental.mdl animations into lelemental
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_FLINCH = "flinch";
		ANIM_DEATH = "die1";

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 40;

		MONSTER_WIDTH = 32; // for anti-stuck
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL; // for basepropelled
	}

	// npc_spawn
	// nclude monsters/base_flyer_agro
	void ElementalAir0_OnNpcSpawn(string npc = "")
	{
		SetName("Summoned Air Elemental");
		SetHealth(500);
		SetWidth(72);
		SetHeight(72);
		SetRace("demon");
		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 1.5f);
		SetDamageTaken("lightning", 0);
		// ov 80
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/elementals_lesser_fly.mdl");
		SetModelBody(0, 1);
		NPC_GIVE_EXP = 150.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		FIRE_BALL_AMMO = FULL_FIRE_BALL_AMMO;
		I_JUST_SPAWNED = 1;

		SetBlood("none");

		SetFly(true);

		MY_HURT_STAGE = MaxHealthOf(ENT_ME) * HURT_THRESHOLD;

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RandomInt(200, 255));

		CallEventDelayed(0.1f, "init_beam");
	}

	// npc_struck
	// called from base_npc_attack - param1 damage taken as of 22/Aug/2006 14:50
	void ElementalAir0_OnNpcStruck(float damage = 0.0f)
	{
		if (RangeTo(ENT_LASTSTRUCK) < ATTACK_HITRANGE && !EL_FLEE_DELAY)
		{
			EL_FLEE_DELAY = true;
			CallEventDelayed(FREQ_FLEE, "reset_el_flee_delay");
			OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "1024", "5");
		}

		float myHealth = HealthOf(ENT_ME);

		if (myHealth >= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth <= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);
	}

	// reset_el_flee_delay
	void ElementalAir0_OnResetElFleeDelay()
	{
		EL_FLEE_DELAY = false;
	}

	// idle_sounds
	void ElementalAir0_OnIdleSounds()
	{
		float nextSound = Random(5, 15);

		CallEventDelayed(nextSound, "idle_sounds");

		if (HUNT_LASTTARGET != "\xEF\xBF\xBDNONE\xEF\xBF\xBD")
			return;
		int randAnim = RandomInt(1, 3);
		if (randAnim == 1) // was having some odd bug with idle anims, hence odd names
			PlayAnim("once", ANIM_BUGIDLE_A);
		if (randAnim == 2)
			PlayAnim("once", ANIM_BUGIDLE_B);
		if (randAnim == 3)
			PlayAnim("once", ANIM_BUGIDLE_C);

		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ElementalAir0_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (USE_SWIPE_SOUND)
		{
			int velF = RandomInt(10, 400);
			int velZ = RandomInt(10, 400);
			AddVelocity(target, RelativeVelocity(Vector3(0, velF, velZ)));
			if (RandomInt(1, 3) == 1)
				ApplyEffect(target, "effects/debuff_stun", 5, self);

			PlaySound(0, 10, SOUND_SWIPEHIT);
			USE_SWIPE_SOUND = false;
		}
		return result;
	}

	// npc_targetsighted
	// called each hunt cycle enemy is sighted
	void ElementalAir0_OnNpcTargetsighted(string target = "")
	{
		if (IS_FLEEING)
			return;
		if (THROWING_FIRE_BALL)
			return;
		if (ZAP_DELAY)
			return;
		ZAP_DELAY = true;
		CallEventDelayed(FREQ_ZAP, "reset_zap_delay");

		if (THROWING_FIRE_BALL)
			return;
		OnCheckFireBall();
	}

	// reset_zap_delay
	void ElementalAir0_OnResetZapDelay()
	{
		ZAP_DELAY = false;
	}

	// check_fire_ball
	void ElementalAir0_OnCheckFireBall()
	{
		if (THROWING_FIRE_BALL)
			return;

		// //dbg FirBalCheck See $cansee(enemy) rng $get(ent_lastseen,range) vs ATTACK_RANGE
		if (!CanSee("enemy"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) > ATTACK_RANGE))
			return;

		if (IsAlive(GetVar("G_SHOCKER")))
			return;
		if (!(GameTime() > Float(GetVar("G_NEXT_SHOCK"))))
			return;

		SetGlobal("G_SHOCKER", self);
		SetGlobal("G_NEXT_SHOCK", GameTime());
		LegacyCommand("add", "G_NEXT_SHOCK", 5.0f);

		SetMoveDest(ENT_LASTSEEN, FIRE_BALL_RANGE);

		PlaySound(0, 10, SOUND_FIRECHARGE);

		PlayAnim("critical", "tocharge");
		LIGHTNING_COUNT = 0.0f;
		THROWING_FIRE_BALL = true;
		OnNpcatkSuspendAi();
		SHOCK_AMT = RandomInt(15, 30);
		Effect("beam", "update", BEAM_ID, "brightness", 200);
		Effect("beam", "update", BEAM_ID, "end_target", NPCATK_TARGET, 0);
		OLD_BEAM_TARG = NPCATK_TARGET;
		CallEventDelayed(0.1f, "do_lightning");
	}

	// do_lightning
	// called from anim fireball @ frame #16
	void ElementalAir0_OnDoLightning(string endOrigin = "")
	{
		LIGHTNING_COUNT += 1.0f;
		if (LIGHTNING_COUNT < SHOCK_AMT)
		{
			SetIdleAnim("charging");
			SetMoveAnim("charging");
			ME_SHOOTING = true;
			CallEventDelayed(0.1f, "do_lightning");
		}
		if (LIGHTNING_COUNT == SHOCK_AMT)
		{
			OnNpcatkResumeAi();
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_WALK);
			ME_SHOOTING = false;
			PlayAnim("critical", "fromcharge");
			THROWING_FIRE_BALL = false;
			SetGlobal("G_SHOCKER", "unset");
			Effect("beam", "update", BEAM_ID, "brightness", 0);
		}

		if (!CanSee(NPCATK_TARGET))
			return;
		if (NPCATK_TARGET != OLD_BEAM_TARG)
		{
			Effect("beam", "update", BEAM_ID, "end_target", NPCATK_TARGET, 0);
			OLD_BEAM_TARG = NPCATK_TARGET;
		}

		Vector3 beamStart = MyOrigin();
		float myYaw = MyAngles().y;
		beamStart += Vec(FINGER_ADJ); // start fingers

		// dbg sending dmg $get(NPCATK_TARGET,name) BEAM_RANGE DMG_CHAIN 100% lightning
		DoDamage(NPCATK_TARGET, BEAM_RANGE, DMG_CHAIN, "100%", "lightning");

		if (GameTime() > NEXT_BEAM)
		{
			BEAM_ON = true;
			BEAM_DURATION = SHOCK_AMT * 0.1f;
			// effect beam end lgtning.spr 30 BEAM_START NPCATK_TARGET 0 (200,200,255) 200 30 0.5
			NEXT_BEAM = GameTime() + 0.5f;
		}

		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
	}

	// slow_down
	void ElementalAir0_OnSlowDown()
	{
		// setvard CAN_ATTACK 1
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
	}

	// ammo_up
	void ElementalAir0_OnAmmoUp()
	{
		FIRE_BALL_AMMO = FULL_FIRE_BALL_AMMO;
	}

	// moveto_last_known
	void ElementalAir0_OnMovetoLastKnown()
	{
		if (CanSee("enemy"))
			return;

		if (DID_SHRUG)
			return;
		DID_SHRUG = true;

		PlayAnim("critical", ANIM_SEARCH);
		PlaySound(0, 10, SOUND_IDLE3);
	}

	// my_target_died
	// called from base_npc_attack
	void ElementalAir0_OnMyTargetDied(string offender = "")
	{
		bool exitSub = false;

		// this goes off falsely at first spawn, ignore (thought i fixed this) :\
		if (I_JUST_SPAWNED == 1)
		{
			exitSub = true;
			I_JUST_SPAWNED = 0;
		}
		if (exitSub)
			return;

		if (!GLOAT_DELAY)
		{
			PlayAnim("critical", ANIM_GLOAT);
			PlaySound(0, 10, SOUND_GLOAT);
			GLOAT_DELAY = true;
			CallEventDelayed(10.0f, "reset_gloat");
		}

		if (!CanSee("enemy"))
		{
			DID_WARCRY = false;
			DID_SHRUG = false;
			FIRE_BALL_AMMO = FULL_FIRE_BALL_AMMO;
		}
	}

	// reset_gloat
	void ElementalAir0_OnResetGloat()
	{
		GLOAT_DELAY = false; // this prevents sploiting with icewall/pets
	}

	// cycle_up
	// called from base_npc_attack when first spotting player
	void ElementalAir0_OnCycleUp(string reason = "")
	{
		if (!IsPlayer(ENT_LASTSEEN))
			return;
		SetMoveDest(ENT_LASTSEEN, ATTACK_RANGE);
		if (DID_WARCRY)
			return;

		DID_WARCRY = true;
		PlayAnim("critical", ANIM_ALERT);
		PlaySound(0, 10, SOUND_ALERT);
	}

	// attack1_strike
	// called from anim attack1 @ frame12
	void ElementalAir0_OnAttack1Strike()
	{
		// this ensures he will use circle after a certain number of mele strikes
		if (FIRE_BALL_AMMO >= 0.0f)
			FIRE_BALL_AMMO -= 0.5f;
		USE_SWIPE_SOUND = true;

		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, FIRE_DAMAGE, ATTACK_ACCURACY);
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void ElementalAir0_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		SetAnimMoveSpeed(NPC_HACKED_MOVE_SPEED); // Force move, since the animation doesn't have the required movement

		if (int(HOVER_LOOP_DELAY) != 0)
			return;
		PlaySound(Int(GetVar("CHAN_BODY")), 8, SOUND_HOVER);
		HOVER_LOOP_DELAY = 1.0f;
		CallEventDelayed(PLAYTIME_HOVER, "hover_loop_reset");
	}

	// hover_loop_reset
	void ElementalAir0_OnHoverLoopReset()
	{
		HOVER_LOOP_DELAY = 0.0f;
	}

	// game_stopmoving
	void ElementalAir0_OnGameStopmoving()
	{
		SetAnimMoveSpeed(0); // Force Stop
	}

	// unnamed block (timer)
	void ElementalAir0_Timer()
	{
		CallEventDelayed(FREQ_REPOS, "ElementalAir0_Timer");
		int rndFloatX = RandomInt(1, 20);
		int rndFloatY = RandomInt(1, 20);
		int rndFloatZ = RandomInt(1, 20);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndFloatX, rndFloatY, rndFloatZ)));
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RandomInt(200, 255));
	}

	// npcatk_flee
	void ElementalAir0_OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		OnFleeStraight();
	}

	// flee_straight
	void ElementalAir0_OnFleeStraight()
	{
		if (!IS_FLEEING)
			return;
		CallEventDelayed(0.1f, "flee_straight");
		int myYaw = Int(LegacyFunction("get", Eval("game.monster.angles.yaw")));
		SetAngle("face", Vector3(0, myYaw, 0));
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 50))); // flee upwards
	}

	// game_death
	void ElementalAir0_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self);
		Effect("beam", "update", BEAM_ID, "remove", 0);
	}

	// init_beam
	void ElementalAir0_OnInitBeam()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 0, ENT_ME, 1, Vector3(200, 200, 255), 0, 30, -1);
		BEAM_ID = ENT_LASTCREATED;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ElementalAir0_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_flee
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		BaseNpcAttack_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); // monsters/base_npc_attack
		ElementalAir0_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack
		ElementalAir0_OnMyTargetDied(offender);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		ElementalAir0_OnCycleUp(reason);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		ElementalAir0_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElementalAir0_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		ElementalAir0_OnNpcTargetsighted(target);
	}

	void OnNpcStruck(float damage = 0.0f) { ElementalAir0_OnNpcStruck(damage); } // npc_struck
	void OnResetElFleeDelay() { ElementalAir0_OnResetElFleeDelay(); } // reset_el_flee_delay
	void OnIdleSounds() { ElementalAir0_OnIdleSounds(); } // idle_sounds
	void OnResetZapDelay() { ElementalAir0_OnResetZapDelay(); } // reset_zap_delay
	void OnCheckFireBall() { ElementalAir0_OnCheckFireBall(); } // check_fire_ball
	void OnDoLightning(string endOrigin = "") { ElementalAir0_OnDoLightning(endOrigin); } // do_lightning
	void OnSlowDown() { ElementalAir0_OnSlowDown(); } // slow_down
	void OnAmmoUp() { ElementalAir0_OnAmmoUp(); } // ammo_up
	void OnMovetoLastKnown() { ElementalAir0_OnMovetoLastKnown(); } // moveto_last_known
	void OnResetGloat() { ElementalAir0_OnResetGloat(); } // reset_gloat
	void OnAttack1Strike() { ElementalAir0_OnAttack1Strike(); } // attack1_strike
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { ElementalAir0_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnHoverLoopReset() { ElementalAir0_OnHoverLoopReset(); } // hover_loop_reset
	void OnGameStopmoving() { ElementalAir0_OnGameStopmoving(); } // game_stopmoving
	void OnFleeStraight() { ElementalAir0_OnFleeStraight(); } // flee_straight
	void OnInitBeam() { ElementalAir0_OnInitBeam(); } // init_beam
	void OnFreqFlee() {} // FREQ_FLEE
	void OnFreqZap() {} // FREQ_ZAP
	void OnNextSound() {} // NEXT_SOUND
	void OnPlaytimeHover() {} // PLAYTIME_HOVER

	// This file's events and timers by their .script names
	bool ElementalAir0_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ammo_up") { OnAmmoUp(); return true; }
		if (name == "attack1_strike") { OnAttack1Strike(); return true; }
		if (name == "check_fire_ball") { OnCheckFireBall(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_lightning") { OnDoLightning(Param(params, 0)); return true; }
		if (name == "flee_straight") { OnFleeStraight(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "hover_loop_reset") { OnHoverLoopReset(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "init_beam") { OnInitBeam(); return true; }
		if (name == "moveto_last_known") { OnMovetoLastKnown(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "reset_el_flee_delay") { OnResetElFleeDelay(); return true; }
		if (name == "reset_gloat") { OnResetGloat(); return true; }
		if (name == "reset_zap_delay") { OnResetZapDelay(); return true; }
		if (name == "slow_down") { OnSlowDown(); return true; }
		if (name == "ElementalAir0_Timer") { ElementalAir0_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/elemental_air0"]
shared class ElementalAir0Script : BaseMonsterScript, ElementalAir0
{
	// Variables every script that includes this file declares
	float BALL_SIZE = 0.0f;
	string BALL_TARGETS = "BALL_TARGETS";
	int DMG_BALL = 0;
	int DMG_CIRCLE = 0;
	float FREQ_CIRCLE = 0.0f;
	float FREQ_LIGHTING_BALLS = 0.0f;
	float NEXT_LIGHTNING_BALL = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ElementalAir0Script()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/elementals_lesser.mdl");
		Precache("monsters/elementals_lesser_fly.mdl");
		CallEventDelayed(FREQ_REPOS, "ElementalAir0_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalAir0_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ElementalAir0_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
