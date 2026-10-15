#pragma context server

// Converted from monsters/guardian_iron.script by msc_transpiler.
// Iron Guardian - Level 40 boss by Thothie
// - Big wide swings*
// - Lightning heals*
// - Slows and recharges if charger script spawned (monsters/guardian_iron_charger)*
// - Charger script MUST be spawned BEFORE this script*
// - Stomp with stunning wave (knocks back nearby players to compensate for model lurch)
// - Smash stun
// - Projectile for distant targets (also knocks back any nearby players for model lurch)
// - (Alternate from projectile: pull in distant targets and strike immediately)
// - Sweep occasionally when roaming to charger to prevent sploits
// createnpc monsters/guardian_iron_charger

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GuardianIron
{
	// Constants
	string ANIM_RAWR = "rawr";
	string ANIM_ATTACK1 = "attack1";
	string ANIM_ATTACK2 = "attack2";
	string ANIM_ATTACK1_READY = "ready_attack1";
	string ANIM_ATTACK2_READY = "ready_attack2";
	string ANIM_DRAW_SWORD = "draw";
	string ANIM_RECHARGE = "recharge";
	string ANIM_REACH = "reach";
	string ANIM_STOMP = "stomp";
	string ANIM_SMASH = "smash";
	int GUARDIAN_TYPE = 1;
	bool GUARDIAN_BEAM_SWORD = true;
	string DMG_ELEF_TYPE = "lightning_effect";
	int PITCH_SWORD_OFF = 100;
	float FREQ_CL_REFRESH = 30.0f;
	int MAX_CHARGE_LEVEL = 50;
	float CHARGE_DROP_RATE = 1.0f;
	string GUARDIAN_CL_SCRIPT = "monsters/guardian_iron_cl";
	float BATTERY_LIFE = 60.0f;
	int STANCE_RANGE = 500;
	int MAX_RECHARGE_RANGE = 400;
	int DMG_SWING_ZAP = 700;
	int DMG_SWING_BLADE = 400;
	int DMG_REACH = 500;
	int DOT_REACH = 100;
	string DMG_SMASH = "400";
	int SWIPE_AOE = 384;
	int SMASH_AOE = 128;
	float FREQ_STOMP = 0.0f;
	float FREQ_REACH = 0.0f;
	float FREQ_SMASH = 0.0f;
	bool SWORD_HILT_IDX = false;
	bool SWORD_TIP_IDX = true;
	string RHAND_IDX = "2";
	string LHAND_IDX = "3";
	string SOUND_STEP1_START = "monsters/guardian/joint_move1.wav";
	string SOUND_STEP2_START = "monsters/guardian/joint_move2.wav";
	string SOUND_STEP1_LAND = "monsters/guardian/step1.wav";
	string SOUND_STEP2_LAND = "monsters/guardian/step2.wav";
	string SOUND_ATTACK1 = "monsters/guardian/swing1.wav";
	string SOUND_ATTACK2 = "monsters/guardian/swing2.wav";
	string SOUND_SWING = "weapons/swinghuge.wav";
	string SOUND_PAIN1 = "monsters/guardian/pain1.wav";
	string SOUND_PAIN2 = "monsters/guardian/pain2.wav";
	string SOUND_PAIN3 = "monsters/guardian/pain3.wav";
	string SOUND_STRUCK1 = "monsters/guardian/struck1.wav";
	string SOUND_STRUCK2 = "monsters/guardian/struck2.wav";
	string SOUND_RAWR = "monsters/guardian/rawr.wav";
	string SOUND_REACH = "monsters/guardian/sca_dragelec.wav";
	string SOUND_RECHARGE_START = "monsters/guardian/sca_dragelec.wav";
	string SOUND_SWORD_IDLE = "magic/bolt_loop.wav";
	string SOUND_SWORD_DRAW = "magic/elecidlepop.wav";
	string SOUND_SWORD_OFF = "magic/elecidle.wav";
	string SOUND_DEATH = "monsters/guardian/death.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_UNHOLY = true;
	string CAN_FLEE = "CAN_FLEE";
	bool NPC_NO_ATTACK = false;
	bool NPC_IS_BOSS = false;
	float NPC_GIVE_EXP = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float GAME_PUSH_RATIO = 0.0f;
	bool IMMUNE_VAMPIRE = false;
	string CHARGER_ORG = "CHARGER_ORG";
	bool NEEDS_CHARGER = false;
	float CHARGE_LEVEL = 0.0f;
	float ANIM_RATE = 0.0f;
	CBaseEntity@ SWORD_BEAM = null;
	bool IN_SWING = false;
	Vector3 SMASH_POINT = Vector3();
	bool SMASH_ATTACK = false;
	float AS_ATTACKING = 0.0f;
	bool DOING_STOMP = false;
	float NEXT_STOMP = 0.0f;
	bool NUDGE_NEAR = false;
	Vector3 NUDGE_POINT = Vector3();
	string NUDGE_TARGETS = "NUDGE_TARGETS";
	Vector3 STOMP_POINT = Vector3();
	string STOMP_TARGETS = "STOMP_TARGETS";
	bool MELEEING = false;
	float NEXT_CHARGE_DROP = 0.0f;
	float NEXT_SMASH = 0.0f;
	float NEXT_REACH = 0.0f;
	int DID_INTRO = 0;
	float NEXT_ROBOCOP_SOUND = 0.0f;
	float ROBOCOP_IDX = 0.0f;
	string REACH_TARGET = "REACH_TARGET";
	bool ATTEMPTING_RECHARGE = false;
	bool DOING_RECHARGE = false;
	bool DID_FIRST_CHARGE = false;
	bool NPC_FORCED_MOVEDEST = false;
	float FLICKER_IN_COUNT = 0.0f;
	float FLICKER_DELAY = 0.0f;
	bool FLICKER_MODE = false;
	bool SWORD_STATE = false;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float NEXT_CL_REFRESH = 0.0f;
	string CL_SCRIPT_IDX = "CL_SCRIPT_IDX";
	float OVERRIDE_SUSPEND_AI = 0.0f;
	bool ROBOCOP_MODE = false;
	float ROBOCOP_NSOUNDS = 0.0f;
	bool NPC_FIGHTS_NPCS = false;
	bool NPC_NO_PLAYER_DMG = false;

	// unnamed block (first think)
	void GuardianIron_FirstThink()
	{
		// anims - base
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_DEATH = "die";
		ANIM_ATTACK = "ready_attack1";
	}

	// unnamed block (first think)
	void GuardianIron_FirstThink2()
	{
		// base stats
		CAN_FLEE = "0";
		IS_UNHOLY = true;
		NPC_NO_ATTACK = true;
		if (Contains(ToLowerCase(MapName()), "shad_pal"))
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 10000.0f;
		}
		else
		{
			NPC_GIVE_EXP = 5000.0f;
		}

		ATTACK_MOVERANGE = 140.0f;
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 300.0f;
		GAME_PUSH_RATIO = 0.25f;

		IMMUNE_VAMPIRE = true;
	}

	// game_precache
	void GuardianIron_OnGamePrecache()
	{
		PrecacheFile(GUARDIAN_CL_SCRIPT);
	}

	// npc_spawn
	// ======================= INIT
	void GuardianIron_OnNpcSpawn(string npc = "")
	{
		OnGuardianSpawn();
		CatchSpeech("say_robocop", "robocop");
	}

	// guardian_spawn
	void GuardianIron_OnGuardianSpawn()
	{
		SetName("Iron Guardian");
		SetHealth(10000);
		SetModel("monsters/guardian.mdl");
		SetWidth(75);
		SetHeight(200);

		SetBoundingBox("npcsize");

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.25f);
		SetDamageTaken("stun", 0);
		SetModelBody(0, 0);
		SetRace("demon");

		SetBlood("none");

		SetHearingSensitivity(1);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(true);

		if (GetVar("G_GUARDIAN_CHARGER") != "G_GUARDIAN_CHARGER")
		{
			CHARGER_ORG = GetVar("G_GUARDIAN_CHARGER");
			NEEDS_CHARGER = true;
		}

		CHARGE_LEVEL = MAX_CHARGE_LEVEL;
		ANIM_RATE = 1.0f;

		OnRefreshFx();

		CallEventDelayed(0.01f, "beam_init");
	}

	// beam_init
	void GuardianIron_OnBeamInit()
	{
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 1, ENT_ME, 2, Vector3(196, 196, 255), 0, 30, -1);
		@SWORD_BEAM = EntityOf(ENT_LASTCREATED);
	}

	// frame_step1_start
	// ======================= ANIM EVENTS
	void GuardianIron_OnFrameStep1Start()
	{
		PlaySound(0, 10, SOUND_STEP1_START);
	}

	// frame_step2_start
	void GuardianIron_OnFrameStep2Start()
	{
		PlaySound(0, 10, SOUND_STEP2_START);
	}

	// frame_step1_land
	void GuardianIron_OnFrameStep1Land()
	{
		PlaySound(0, 10, SOUND_STEP1_LAND);
	}

	// frame_step2_land
	void GuardianIron_OnFrameStep2Land()
	{
		PlaySound(0, 10, SOUND_STEP2_LAND);
	}

	// frame_attack1_start
	void GuardianIron_OnFrameAttack1Start()
	{
		IN_SWING = true;
		PlaySound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// frame_attack2_start
	void GuardianIron_OnFrameAttack2Start()
	{
		IN_SWING = true;
		PlaySound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// frame_draw_flicker
	void GuardianIron_OnFrameDrawFlicker()
	{
		OnSwordOn();
	}

	// frame_smash
	void GuardianIron_OnFrameSmash()
	{
		ANIM_ATTACK = "ready_attack2";
		SMASH_POINT = AttachmentPositionOf(ENT_ME, LHAND_IDX);
		SMASH_POINT.z = GroundHeight(SMASH_POINT);
		SMASH_POINT += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 96, 0));
		DebugPrint("frame_smash " + Text(SMASH_POINT) + " distfromme " + Text(Distance(SMASH_POINT, MyOrigin())));
		ClientEvent("update", "all", CL_SCRIPT_IDX, "smash_fx", SMASH_POINT);
		SMASH_ATTACK = true;
		DoDamage(Text(SMASH_POINT), SMASH_AOE, DMG_SMASH, "100%", 0, "reflective", "blunt");
	}

	// frame_attack1_go
	void GuardianIron_OnFrameAttack1Go()
	{
		if (NPC_NO_ATTACK) // case sword fizzled
			return;
		string targsInRange = FindInSphere("enemy", ATTACK_HITRANGE);
		if (targsInRange == "none")
			return;
		PlayAnim("critical", ANIM_ATTACK1);
	}

	// frame_attack2_go
	void GuardianIron_OnFrameAttack2Go()
	{
		if (NPC_NO_ATTACK) // case sword fizzled
			return;
		string targsInRange = FindInSphere("enemy", ATTACK_HITRANGE);
		if (targsInRange == "none")
			return;
		PlayAnim("critical", ANIM_ATTACK2);
	}

	// frame_attack1_strike
	void GuardianIron_OnFrameAttack1Strike()
	{
		OnMeleeAttack();
		ANIM_ATTACK = ANIM_ATTACK2_READY;
		SetIdleAnim(ANIM_ATTACK);
		if (RandomInt(1, 3) != 1)
			return;
		ANIM_ATTACK = ANIM_ATTACK2; // attack quicker sometimes (sploit prevention)
	}

	// frame_attack2_strike
	void GuardianIron_OnFrameAttack2Strike()
	{
		OnMeleeAttack();
		ANIM_ATTACK = ANIM_ATTACK1_READY;
		SetIdleAnim(ANIM_ATTACK);
		if (RandomInt(1, 3) != 1)
			return;
		ANIM_ATTACK = ANIM_ATTACK1; // attack quicker sometimes (sploit prevention)
	}

	// frame_rawr_done
	void GuardianIron_OnFrameRawrDone()
	{
		OnRawrEvent();
	}

	// frame_reach_start
	void GuardianIron_OnFrameReachStart()
	{
		AS_ATTACKING = GameTime() + 5.0f;
	}

	// frame_reach_strike
	void GuardianIron_OnFrameReachStrike()
	{
		OnNpcatkResumeAi();
		if (ATTEMPTING_RECHARGE) // in case battery ran out mid swing
			return;
		PlaySound(0, 10, SOUND_REACH);
		ClientEvent("update", "all", CL_SCRIPT_IDX, "grab_fx", IndexOf(REACH_TARGET));
		ANIM_ATTACK = ANIM_ATTACK1;
		DoDamage(REACH_TARGET, 1024, DMG_REACH, "100%", DMG_ELEF_TYPE);
		if (!(DamageTakenOf(REACH_TARGET, "lightning") < 0.9f))
			return;
		ApplyEffect(REACH_TARGET, "effects/dot_lightning", 5.0f, self, DOT_REACH);
		AddVelocity(REACH_TARGET, RelativeVelocity(Vector3(0, -3000, 110)));
	}

	// frame_stomp_start
	void GuardianIron_OnFrameStompStart()
	{
		AS_ATTACKING = GameTime() + 10.0f;

		PlaySound(0, 10, SOUND_STEP1_START);
		DOING_STOMP = true;

		NEXT_STOMP = GameTime() + FREQ_STOMP;

		// model lurches forward quite a bit, nudge players in front of me away
		NUDGE_NEAR = true;
		OnNudgeLoop();
		CallEventDelayed(4.0f, "end_nudge_loop"); // in case doesn't reach end of stomp for some reason
	}

	// nudge_loop
	void GuardianIron_OnNudgeLoop()
	{
		if (!NUDGE_NEAR)
			return;
		CallEventDelayed(0.5f, "nudge_loop");
		NUDGE_POINT = BonePositionOf(ENT_ME, 13); // left foot
		NUDGE_POINT.z = GroundHeight(NUDGE_POINT);
		NUDGE_TARGETS = LegacyFunction("get_tsphere", "enemy", 64, NUDGE_POINT);
		if (NUDGE_TARGETS == "none")
			return;
		int count = GetTokenCount(NUDGE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectNudgeTargets();
		}
	}

	// end_nudge_loop
	void GuardianIron_OnEndNudgeLoop()
	{
		NUDGE_NEAR = false;
		DOING_STOMP = false;
		ANIM_ATTACK = "ready_attack1";
	}

	// affect_nudge_targets
	void GuardianIron_OnAffectNudgeTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(NUDGE_TARGETS, loopIteration));
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, 200, 110)));
	}

	// frame_stomp
	void GuardianIron_OnFrameStomp()
	{
		ANIM_ATTACK = "ready_attack1";
		DOING_STOMP = false;
		NUDGE_NEAR = false;
		STOMP_POINT = BonePositionOf(ENT_ME, 13); // left foot
		STOMP_POINT.z = GroundHeight(STOMP_POINT);
		STOMP_TARGETS = LegacyFunction("get_tsphere", "enemy", 256, STOMP_POINT);
		ClientEvent("update", "all", CL_SCRIPT_IDX, "stomp_fx", STOMP_POINT);
		if (STOMP_TARGETS == "none")
			return;
		int count = GetTokenCount(STOMP_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectStompTargets();
		}
	}

	// affect_stomp_targets
	void GuardianIron_OnAffectStompTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(STOMP_TARGETS, loopIteration));
		float stunDur = 5.0f;
		if (ATTEMPTING_RECHARGE)
			stunDur = 10.0f;

		ApplyEffect(curTarget, "effects/debuff_stun", stunDur, self);
		Vector3 targOrg = OriginOf(curTarget);
		float targAng = AnglesTo(STOMP_POINT, targOrg);
		int newYaw = int(targAng);
		SetVelocity(curTarget, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
	}

	// melee_attack
	void GuardianIron_OnMeleeAttack()
	{
		IN_SWING = false;
		PlaySound(0, 10, SOUND_SWING);
		MELEEING = true;
		DoDamage(Text(AttachmentPositionOf(ENT_ME, 1)), SWIPE_AOE, DMG_SWING_ZAP, "100%", 0, "reflective", DMG_ELEF_TYPE);
		DoDamage(Text(AttachmentPositionOf(ENT_ME, 1)), SWIPE_AOE, DMG_SWING_BLADE, "100%", 0, "reflective", "slash");
		MELEEING = false;
	}

	// game_damaged
	// ======================= STRUCK
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string GuardianIron_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";

		if (Contains(damageType, "lightning"))
		{
			Effect("glow", ENT_ME, Vector3(0, 255, 0), 64, 1, 1);
			if (HealthOf(ENT_ME) < MaxHealthOf(ENT_ME))
				GiveHealth(damage);
			result = AppendResult(result, "0");

			// player just recharged your batteries
			CHARGE_LEVEL = MAX_CHARGE_LEVEL;
			NEXT_CHARGE_DROP = GameTime() + BATTERY_LIFE;

			if (ATTEMPTING_RECHARGE)
				OnRechargeDone();
		}
		else
		{
			if (Contains(damageType, "effect")) // no struck sounds from DOT's on this guy
				exitSub = true;
			if (!exitSub)
				PlaySound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
		}
		return result;
	}

	// cycle_up
	// ======================= MAIN CYCLE
	void GuardianIron_OnCycleUp(string reason = "")
	{
		SetRoam(false);

		OnRefreshFx();

		float gameTime = GameTime();

		NEXT_SMASH = gameTime + FREQ_SMASH;

		NEXT_STOMP = gameTime + FREQ_STOMP;

		NEXT_REACH = gameTime + FREQ_REACH;

		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		AS_ATTACKING = gameTime + 5.0f;
		SetMoveDest(NPCATK_TARGET, 9999);
		OnDoIntro();

		if (Float(CL_SCRIPT_IDX) > -1.0f)
			OnRefreshFx();
	}

	// cycle_down
	void GuardianIron_OnCycleDown()
	{
		SetRoam(true);
	}

	// npc_selectattack
	void GuardianIron_OnNpcSelectattack()
	{
		AS_ATTACKING = GameTime() + 3.0f;
		if (ANIM_RATE < 1.0f) // give more times for attacks to complete when battery low
			AS_ATTACKING += 5.0f;
	}

	// npcatk_hunt
	void GuardianIron_OnNpcatkHunt()
	{
		bool exitSub = false;

		if (IsAlive(ENT_ME))
		{
			if (GameTime() > NEXT_CL_REFRESH)
				OnRefreshFx();
			if (ROBOCOP_MODE && GameTime() > NEXT_ROBOCOP_SOUND)
			{
				NEXT_ROBOCOP_SOUND = GameTime() + Random(3, 10);
				if (ROBOCOP_IDX > ROBOCOP_NSOUNDS)
					ROBOCOP_IDX = 0.0f;
				PlaySound(0, 10, GetArray("ROBOCOP_ARRAY", Text(ROBOCOP_IDX)));
				ROBOCOP_IDX += 1.0f;
			}
		}

		if (SUSPEND_AI)
			return;
		if (ATTEMPTING_RECHARGE)
			return;
		if (DOING_RECHARGE)
			return;
		if (DOING_STOMP)
			return;

		if (NPCATK_TARGET == "unset")
			return;

		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE && !IN_SWING)
		{
			if (SWORD_STATE && GameTime() > NEXT_REACH) // only if sword drawn - don't want to intereferh with draw process
			{
				Vector3 targOrg = OriginOf(NPCATK_TARGET);
				Vector3 handOrg = AttachmentPositionOf(ENT_ME, LHAND_IDX);
				string traceLine = LegacyFunction("get_traceline", handOrg, targOrg, "worldonly");
				if (traceLine == Text(targOrg))
				{
					NEXT_REACH = GameTime() + FREQ_REACH;
					REACH_TARGET = NPCATK_TARGET;
					OnDoReach();
					exitSub = true;
				}
			}
		}
		if (exitSub)
			return;

		if (GameTime() > NEXT_STOMP)
		{
			ANIM_ATTACK = ANIM_STOMP;
			NEXT_STOMP = GameTime() + FREQ_STOMP;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (GameTime() > NEXT_SMASH)
		{
			ANIM_ATTACK = ANIM_SMASH;
			NEXT_SMASH = GameTime() + FREQ_STOMP;
		}
	}

	// do_intro
	// ======================= INTRO SEQUENCE
	void GuardianIron_OnDoIntro()
	{
		PlayAnim("critical", ANIM_RAWR);
		PlaySound(0, 10, SOUND_RAWR);

		if (NEEDS_CHARGER)
		{
			// callevent 5.0 stop_music //this does not work
			CallEventDelayed(1.5f, "do_recharge");
			CallEventDelayed(0.1f, "intro_musak"); // in case hitting error here
		}
		else
		{
			CallEventDelayed(1.5f, "draw_sword");
		}
	}

	// intro_musak
	void GuardianIron_OnIntroMusak()
	{
		CallExternal("players", "ext_play_music", "media/Suspense07.mp3");
	}

	// do_recharge
	// ======================= RECHARGE SEQUENCE
	void GuardianIron_OnDoRecharge()
	{
		OnNpcatkSuspendAi();
		ATTEMPTING_RECHARGE = false;
		OnRefreshFx();
		OnDoRechargeFx();
	}

	// do_recharge_fx
	// Old buggy version
	// { do_recharge_move_loop
	// local CUR_DIST $dist(game.monster.origin,CHARGER_ORG)
	// if ( CUR_DIST > MAX_RECHARGE_RANGE )
	// {
	// callevent $randf(0.5,3.0) do_recharge_move_loop
	// callevent npcatk_suspend_ai //AI keeps coming back on for some reason
	// setmovedest CHARGER_ORG 100
	// if ( game.time > RECHARGE_OVERRIDE )
	// {
	// //been trying to get home a long time now - force a wiggle
	// dbg Overtime
	// setvard RECHARGE_OVERRIDE game.time
	// add RECHARGE_OVERRIDE 10.0
	// local RND_ANG $randf(0.0,359.99)
	// setmovedest $relpos($vec(0,RND_ANG,0),$vec(0,500,0)) 0
	// }
	// //Thothie's redundant school of redunancy
	// if ( game.time > EMERGANCY_OVERRIDE )
	// {
	// setvard ATTEMPTING_RECHARGE 0
	// callevent do_recharge_fx
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// if ( CUR_DIST >= OLD_DIST )
	// {
	// dbg no_progress OLD_DIST vs CUR_DIST
	// if !DOING_STOMP
	// if $rand(1,2) == 1
	// //don't seem to be getting closer - wiggle
	// local RND_ANG $randf(0.0,359.99)
	// setmovedest $relpos($vec(0,RND_ANG,0),$vec(0,500,0)) 0
	// }
	// setvard OLD_DIST CUR_DIST
	// //suck towards charger, force increases based on time
	// local TARG_ORG CHARGER_ORG
	// local TARG_ANG $angles(game.monster.origin,TARG_ORG)
	// local NEW_YAW TARG_ANG
	// local SUCK_STR game.time
	// subtract SUCK_STR ATTEMPT_STARTED
	// if ( SUCK_STR > 30 )
	// {
	// //been trying to get to charge way too long, just charge from here
	// setvard ATTEMPTING_RECHARGE 0
	// callevent do_recharge_fx
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// multiply SUCK_STR 10
	// //local SUCK_STR $neg(SUCK_STR)
	// addvelocity ent_me $relvel($vec(0,NEW_YAW,0),$vec($rand(-100,100),SUCK_STR,0))
	// //use repulse stomp if players are trying to stop me from reaching charger
	// if game.time > NEXT_RECHARGE_STOMP
	// local NEAR_TARGS $get_tsphere(enemy,256)
	// if NEAR_TARGS isnot none
	// playanim critical ANIM_STOMP
	// setvard NEXT_RECHARGE_STOMP game.time
	// add NEXT_RECHARGE_STOMP 15.0
	// }
	// else
	// {
	// setvard ATTEMPTING_RECHARGE 0
	// callevent do_recharge_fx
	// }
	// }
	void GuardianIron_OnDoRechargeFx()
	{
		CallEventDelayed(8.0f, "recharge_done");

		AS_ATTACKING = GameTime() + 10.0f;

		SetMoveDest(CHARGER_ORG, 9999);

		DOING_RECHARGE = true;
		SetIdleAnim(ANIM_RECHARGE);
		SetMoveAnim(ANIM_RECHARGE);
		PlayAnim("critical", ANIM_RECHARGE);
		SetRoam(false); // redundant
		ClientEvent("update", "all", CL_SCRIPT_IDX, "recharge_fx", CHARGER_ORG);
		OnDoRechargeLoop();
	}

	// do_recharge_loop
	void GuardianIron_OnDoRechargeLoop()
	{
		if (!DOING_RECHARGE)
			return;
		CallEventDelayed(0.1f, "do_recharge_loop");
		if (!(CHARGE_LEVEL < MAX_CHARGE_LEVEL))
			return;
		CHARGE_LEVEL += 1.0f;
		OnUpdateAnimSpeed();
	}

	// recharge_done
	void GuardianIron_OnRechargeDone()
	{
		OnNpcatkResumeAi();
		NEXT_CHARGE_DROP = GameTime() + BATTERY_LIFE;
		DOING_RECHARGE = false;
		CHARGE_LEVEL = MAX_CHARGE_LEVEL;
		DID_FIRST_CHARGE = true;
		SetAnimFrameRate(1);
		ANIM_RATE = 1.0f;
		SetMoveDest(NPCATK_TARGET, ATTACK_MOVERANGE);
		NPC_FORCED_MOVEDEST = true;
		OnDrawSword();
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);

		float gameTime = GameTime();

		NEXT_SMASH = gameTime + FREQ_SMASH;

		NEXT_STOMP = gameTime + FREQ_STOMP;

		NEXT_REACH = gameTime;
	}

	// draw_sword
	// ======================= DRAW SWORD
	void GuardianIron_OnDrawSword()
	{
		string curTarg = NPCATK_TARGET;
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(curTarg, 9999);
		PlayAnim("critical", ANIM_DRAW_SWORD);
		CallEventDelayed(5.0f, "sword_on"); // in case anim is interrupted
	}

	// sword_on
	void GuardianIron_OnSwordOn(string spitSprites = "")
	{
		if (SWORD_STATE)
			return;
		AS_ATTACKING = GameTime() + 2.0f;
		ClientEvent("update", "all", CL_SCRIPT_IDX, "sword_on", 1);
		FLICKER_IN_COUNT = 10.0f;
		FLICKER_DELAY = 0.0f;
		FLICKER_MODE = true;
		SWORD_STATE = true;
		OnSwordFlickerLoop();
		PlaySound(0, 10, SOUND_SWORD_DRAW);
		if (SOUND_SWORD_IDLE != "none)") {}
		NPC_NO_ATTACK = false;
	}

	// sword_flicker_loop
	void GuardianIron_OnSwordFlickerLoop()
	{
		if (FLICKER_IN_COUNT == 0.0f)
		{
			SetModelBody(1, (SWORD_STATE ? 1 : 0));
			if (GUARDIAN_BEAM_SWORD)
			{
				if (SWORD_STATE)
					Effect("beam", "update", @SWORD_BEAM, "brightness", 200);
				else
					Effect("beam", "update", @SWORD_BEAM, "brightness", 0);
			}
		}
		if (!(FLICKER_IN_COUNT >= 1.0f))
			return;
		SetModelBody(1, (FLICKER_MODE ? 1 : 0));
		if (FLICKER_MODE)
		{
			SetModelBody(1, 1);
			FLICKER_MODE = false;
		}
		else
		{
			SetModelBody(1, 0);
			FLICKER_MODE = true;
		}
		FLICKER_IN_COUNT -= 1.0f;
		FLICKER_DELAY += 0.01f;
		CallEventDelayed(FLICKER_DELAY, "sword_flicker_loop");
	}

	// sword_off
	void GuardianIron_OnSwordOff()
	{
		NPC_NO_ATTACK = true;
		SWORD_STATE = false;
		FLICKER_IN_COUNT = 10.0f;
		FLICKER_DELAY = 0.0f;
		FLICKER_MODE = true;
		OnSwordFlickerLoop();
		PlaySound(0, 10, SOUND_SWORD_OFF, 0.8f, PITCH_SWORD_OFF);
		if (SOUND_SWORD_IDLE != "none")
			ServerPlaySound(1, 0, SOUND_SWORD_IDLE);
		ClientEvent("update", "all", CL_SCRIPT_IDX, "sword_flicker_out");
	}

	// sword_off_instant
	// for death
	void GuardianIron_OnSwordOffInstant()
	{
		ClientEvent("update", "all", CL_SCRIPT_IDX, "sword_flicker_out");
		if (GUARDIAN_BEAM_SWORD)
		{
			Effect("beam", "update", @SWORD_BEAM, "brightness", 0);
			Effect("beam", "update", @SWORD_BEAM, "remove", 0.1f);
		}
		if (SOUND_SWORD_IDLE != "none")
			ServerPlaySound(1, 0, SOUND_SWORD_IDLE);
		SetModelBody(1, 0);
		SWORD_STATE = false;
	}

	// unnamed block (timer)
	// ======================= CHARGE DROP
	void GuardianIron_Timer()
	{
		CallEventDelayed(CHARGE_DROP_RATE, "GuardianIron_Timer");

		if (!NEEDS_CHARGER)
			return;
		if (!DID_FIRST_CHARGE)
			return;
		if (ATTEMPTING_RECHARGE)
			return;

		if (!(GameTime() > NEXT_CHARGE_DROP))
			return;
		CHARGE_LEVEL -= 1.0f;
		if (ANIM_RATE > 0.3f)
		{
			OnUpdateAnimSpeed();
			DebugPrint("losing_charge " + Text(CHARGE_LEVEL) + " " + Text(ANIM_RATE));
		}
		else
		{
			OnSwordOff();
			OnDoRecharge();
		}
	}

	// update_anim_speed
	void GuardianIron_OnUpdateAnimSpeed()
	{
		ANIM_RATE = Divide(CHARGE_LEVEL, MAX_CHARGE_LEVEL);
		BASE_FRAMERATE = Text(ANIM_RATE);
		SetAnimFrameRate(ANIM_RATE);
	}

	// game_death
	// ======================= DEATH
	void GuardianIron_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnSwordOffInstant();
		ClientEvent("update", "all", CL_SCRIPT_IDX, "remove_fx");
		if (ToLowerCase(MapName()) == "shad_palace")
		{
			// reset player spawn points so they don't sploit the map
			// (will suck if they die from post-mortem DOT, but not TOO likely with this boss)
			CallExternal("players", "ext_set_map", "shad_palace", "from_aluhandra2", "from_shad_palace");
		}
	}

	// refresh_fx
	// ======================= CLIENT FX REFRESH
	// {
	// repeatdelay 10.0
	// if !DOING_RECHARGE //dont refresh during recharge FX
	// if $get(ent_me,isalive)
	// callevent refresh_fx
	// }
	void GuardianIron_OnRefreshFx()
	{
		NEXT_CL_REFRESH = GameTime() + FREQ_CL_REFRESH;

		ClientEvent("update", "all", CL_SCRIPT_IDX, "end_fx");
		ClientEvent("new", "all", GUARDIAN_CL_SCRIPT, IndexOf(ENT_ME), 1, SWORD_STATE, FREQ_CL_REFRESH);
		CL_SCRIPT_IDX = LastClientScriptId();
	}

	// do_reach
	// ======================= "GET OVER HERE!"
	void GuardianIron_OnDoReach()
	{
		OnNpcatkSuspendAi("2.0");
		PlayAnim("critical", ANIM_REACH);
		PlaySound(0, 10, SOUND_SWING);
		ClientEvent("update", "all", CL_SCRIPT_IDX, "grab_sprite_on");
	}

	// game_dodamage
	// ======================= Other Dodamage Handling
	string GuardianIron_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (SMASH_ATTACK && IsAlive(target) && RangeTo(target) < ATTACK_HITRANGE)
			ApplyEffect(target, "effects/debuff_stun", 10.0f, self);
		SMASH_ATTACK = false;
		return result;
	}

	// npcatk_suspend_ai
	// developer
	// {
	// const BEAM_REPEAT 0.1
	// const H_WIDTH 75
	// const N_WIDTH -75
	// const F_HEIGHT 200
	// }
	// {
	// repeatdelay BEAM_REPEAT
	// width 75
	// height 200
	// setbbox npcsize //(-75,-75,0) (75,75,200)
	// local MY_ORG $get(ent_me,origin)
	// local MY_ANG $get(ent_me,angles.yaw)
	// local BEAM_START MY_ORG
	// vectoradd BEAM_START $relpos($vec(0,MY_ANG,0),$vec(H_WIDTH,H_WIDTH,0))
	// local BEAM_END BEAM_START
	// vectoradd BEAM_END z F_HEIGHT
	// effect beam point lgtning.spr 20 BEAM_START BEAM_END (255,0,255) 200 0 BEAM_REPEAT
	// local BEAM_START MY_ORG
	// vectoradd BEAM_START $relpos($vec(0,MY_ANG,0),$vec(N_WIDTH,N_WIDTH,0))
	// local BEAM_END BEAM_START
	// vectoradd BEAM_END z F_HEIGHT
	// effect beam point lgtning.spr 20 BEAM_START BEAM_END (255,0,255) 200 0 BEAM_REPEAT
	// local BEAM_START MY_ORG
	// vectoradd BEAM_START $relpos($vec(0,MY_ANG,0),$vec(H_WIDTH,N_WIDTH,0))
	// local BEAM_END BEAM_START
	// vectoradd BEAM_END z F_HEIGHT
	// effect beam point lgtning.spr 20 BEAM_START BEAM_END (255,0,255) 200 0 BEAM_REPEAT
	// local BEAM_START MY_ORG
	// vectoradd BEAM_START $relpos($vec(0,MY_ANG,0),$vec(N_WIDTH,H_WIDTH,0))
	// local BEAM_END BEAM_START
	// vectoradd BEAM_END z F_HEIGHT
	// effect beam point lgtning.spr 20 BEAM_START BEAM_END (255,0,255) 200 0 BEAM_REPEAT
	// }
	// BD prevention
	void GuardianIron_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		OVERRIDE_SUSPEND_AI = GameTime() + 45.0f;
	}

	// unnamed block (timer)
	void GuardianIron_Timer2()
	{
		CallEventDelayed(5.0f, "GuardianIron_Timer2");
		if (!SUSPEND_AI)
			return;
		if (!(GameTime() > OVERRIDE_SUSPEND_AI))
			return;
		OnNpcatkResumeAi();
	}

	// say_robocop
	void GuardianIron_OnSayRobocop()
	{
		if (ROBOCOP_MODE)
			return;
		ROBOCOP_MODE = true;
		ArrayCreate("ROBOCOP_ARRAY");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_comequietortrouble.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_deadoralive.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_robocop_arrest.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_dropit.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_intro.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_lookingforme.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_miranda.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_drop_arrest.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_stayoutoftrouble.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_thankyou_gnight.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_youareunderarrest1.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_youarewantedformurder.wav");
		ArrayAdd("ROBOCOP_ARRAY", "monsters/guardian/robocop_yourmovecreep.wav");
		ROBOCOP_NSOUNDS = GetArrayCount("ROBOCOP_ARRAY");
		ROBOCOP_IDX = 0.0f;
		ROBOCOP_NSOUNDS -= 1.0f;
		NPC_FIGHTS_NPCS = true;
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			SetRace("human");
			NPC_NO_PLAYER_DMG = true;
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { GuardianIron_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		GuardianIron_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		GuardianIron_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GuardianIron_OnNpcatkHunt();
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		GuardianIron_OnNpcatkSuspendAi(seconds, debugTag);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, GuardianIron_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		GuardianIron_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		GuardianIron_OnCycleDown();
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		GuardianIron_OnNpcSelectattack();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GuardianIron_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	void OnGuardianSpawn() { GuardianIron_OnGuardianSpawn(); } // guardian_spawn
	void OnBeamInit() { GuardianIron_OnBeamInit(); } // beam_init
	void OnFrameStep1Start() { GuardianIron_OnFrameStep1Start(); } // frame_step1_start
	void OnFrameStep2Start() { GuardianIron_OnFrameStep2Start(); } // frame_step2_start
	void OnFrameStep1Land() { GuardianIron_OnFrameStep1Land(); } // frame_step1_land
	void OnFrameStep2Land() { GuardianIron_OnFrameStep2Land(); } // frame_step2_land
	void OnFrameAttack1Start() { GuardianIron_OnFrameAttack1Start(); } // frame_attack1_start
	void OnFrameAttack2Start() { GuardianIron_OnFrameAttack2Start(); } // frame_attack2_start
	void OnFrameDrawFlicker() { GuardianIron_OnFrameDrawFlicker(); } // frame_draw_flicker
	void OnFrameSmash() { GuardianIron_OnFrameSmash(); } // frame_smash
	void OnFrameAttack1Go() { GuardianIron_OnFrameAttack1Go(); } // frame_attack1_go
	void OnFrameAttack2Go() { GuardianIron_OnFrameAttack2Go(); } // frame_attack2_go
	void OnFrameAttack1Strike() { GuardianIron_OnFrameAttack1Strike(); } // frame_attack1_strike
	void OnFrameAttack2Strike() { GuardianIron_OnFrameAttack2Strike(); } // frame_attack2_strike
	void OnFrameRawrDone() { GuardianIron_OnFrameRawrDone(); } // frame_rawr_done
	void OnFrameReachStart() { GuardianIron_OnFrameReachStart(); } // frame_reach_start
	void OnFrameReachStrike() { GuardianIron_OnFrameReachStrike(); } // frame_reach_strike
	void OnFrameStompStart() { GuardianIron_OnFrameStompStart(); } // frame_stomp_start
	void OnNudgeLoop() { GuardianIron_OnNudgeLoop(); } // nudge_loop
	void OnEndNudgeLoop() { GuardianIron_OnEndNudgeLoop(); } // end_nudge_loop
	void OnAffectNudgeTargets() { GuardianIron_OnAffectNudgeTargets(); } // affect_nudge_targets
	void OnFrameStomp() { GuardianIron_OnFrameStomp(); } // frame_stomp
	void OnAffectStompTargets() { GuardianIron_OnAffectStompTargets(); } // affect_stomp_targets
	void OnMeleeAttack() { GuardianIron_OnMeleeAttack(); } // melee_attack
	void OnDoIntro() { GuardianIron_OnDoIntro(); } // do_intro
	void OnIntroMusak() { GuardianIron_OnIntroMusak(); } // intro_musak
	void OnDoRecharge() { GuardianIron_OnDoRecharge(); } // do_recharge
	void OnDoRechargeFx() { GuardianIron_OnDoRechargeFx(); } // do_recharge_fx
	void OnDoRechargeLoop() { GuardianIron_OnDoRechargeLoop(); } // do_recharge_loop
	void OnRechargeDone() { GuardianIron_OnRechargeDone(); } // recharge_done
	void OnDrawSword() { GuardianIron_OnDrawSword(); } // draw_sword
	void OnSwordOn(string spitSprites = "") { GuardianIron_OnSwordOn(spitSprites); } // sword_on
	void OnSwordFlickerLoop() { GuardianIron_OnSwordFlickerLoop(); } // sword_flicker_loop
	void OnSwordOff() { GuardianIron_OnSwordOff(); } // sword_off
	void OnSwordOffInstant() { GuardianIron_OnSwordOffInstant(); } // sword_off_instant
	void OnUpdateAnimSpeed() { GuardianIron_OnUpdateAnimSpeed(); } // update_anim_speed
	void OnRefreshFx() { GuardianIron_OnRefreshFx(); } // refresh_fx
	void OnDoReach() { GuardianIron_OnDoReach(); } // do_reach
	void OnSayRobocop() { GuardianIron_OnSayRobocop(); } // say_robocop
	void OnFlickerDelay() {} // FLICKER_DELAY
	void OnRawrEvent() {} // RAWR_EVENT

	// This file's events and timers by their .script names
	bool GuardianIron_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "affect_nudge_targets") { OnAffectNudgeTargets(); return true; }
		if (name == "affect_stomp_targets") { OnAffectStompTargets(); return true; }
		if (name == "beam_init") { OnBeamInit(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_reach") { OnDoReach(); return true; }
		if (name == "do_recharge") { OnDoRecharge(); return true; }
		if (name == "do_recharge_fx") { OnDoRechargeFx(); return true; }
		if (name == "do_recharge_loop") { OnDoRechargeLoop(); return true; }
		if (name == "draw_sword") { OnDrawSword(); return true; }
		if (name == "end_nudge_loop") { OnEndNudgeLoop(); return true; }
		if (name == "frame_attack1_go") { OnFrameAttack1Go(); return true; }
		if (name == "frame_attack1_start") { OnFrameAttack1Start(); return true; }
		if (name == "frame_attack1_strike") { OnFrameAttack1Strike(); return true; }
		if (name == "frame_attack2_go") { OnFrameAttack2Go(); return true; }
		if (name == "frame_attack2_start") { OnFrameAttack2Start(); return true; }
		if (name == "frame_attack2_strike") { OnFrameAttack2Strike(); return true; }
		if (name == "frame_draw_flicker") { OnFrameDrawFlicker(); return true; }
		if (name == "frame_rawr_done") { OnFrameRawrDone(); return true; }
		if (name == "frame_reach_start") { OnFrameReachStart(); return true; }
		if (name == "frame_reach_strike") { OnFrameReachStrike(); return true; }
		if (name == "frame_smash") { OnFrameSmash(); return true; }
		if (name == "frame_step1_land") { OnFrameStep1Land(); return true; }
		if (name == "frame_step1_start") { OnFrameStep1Start(); return true; }
		if (name == "frame_step2_land") { OnFrameStep2Land(); return true; }
		if (name == "frame_step2_start") { OnFrameStep2Start(); return true; }
		if (name == "frame_stomp") { OnFrameStomp(); return true; }
		if (name == "frame_stomp_start") { OnFrameStompStart(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "guardian_spawn") { OnGuardianSpawn(); return true; }
		if (name == "intro_musak") { OnIntroMusak(); return true; }
		if (name == "melee_attack") { OnMeleeAttack(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "nudge_loop") { OnNudgeLoop(); return true; }
		if (name == "recharge_done") { OnRechargeDone(); return true; }
		if (name == "refresh_fx") { OnRefreshFx(); return true; }
		if (name == "say_robocop") { OnSayRobocop(); return true; }
		if (name == "sword_flicker_loop") { OnSwordFlickerLoop(); return true; }
		if (name == "sword_off") { OnSwordOff(); return true; }
		if (name == "sword_off_instant") { OnSwordOffInstant(); return true; }
		if (name == "sword_on") { OnSwordOn(Param(params, 0)); return true; }
		if (name == "update_anim_speed") { OnUpdateAnimSpeed(); return true; }
		if (name == "GuardianIron_Timer") { GuardianIron_Timer(); return true; }
		if (name == "GuardianIron_Timer2") { GuardianIron_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/guardian_iron"]
shared class GuardianIronScript : BaseMonsterNewScript, GuardianIron
{
	// Variables every script that includes this file declares
	float DOT_DMG = 0.0f;
	float NEXT_SWBEAMS_REFRESH = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	GuardianIronScript()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
		SOUND_DEATH = "monsters/guardian/death.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("c-tele1.spr");
		Precache("flare1.spr");
		Precache("monsters/guardian.mdl");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(CHARGE_DROP_RATE, "GuardianIron_Timer");
		CallEventDelayed(5.0f, "GuardianIron_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GuardianIron_FirstThink();
		GuardianIron_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GuardianIron_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
