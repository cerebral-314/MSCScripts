#pragma context server

// Converted from monsters/horror.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Also, I apologize, this script is a mess.
// Horror by Thothie - From scratch
// - Big flyin death machine, arial poison spit attack, close in blinding gas attack, gore attack
// - new model monsters/edwardgoery.mdl
// - new sprite poison_cloud.spr

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Horror
{
	// Constants
	bool NPC_NO_END_FLY = true;
	int ATTACK_BLIND_RANGE = 200;
	string RETALIATE_CHANGETARGET_CHANCE = "100";
	int FLEE_HEALTH = 25;
	string FLEE_CHANCE = "25";
	int MOVE_RAGE = 30;
	string ATTACK_ACCURACY = "80%";
	string ATTACK_DAMAGE = "100";
	int SPIT_DAMAGE = 50;
	int BREATH_DAMAGE_MIN = 10;
	int BREATH_DAMAGE_MAX = 20;
	string ANIM_SPIRAL = "fly2";
	string ANIM_FLY = "fly1";
	string ANIM_HOVER = "hover";
	string ANIM_SPIT = "bite1";
	string ANIM_BITE = "bite1";
	string ANIM_GORE = "bite2";
	string ANIM_BREATH = "breath";
	string ANIM_DEAD = "dead";
	string SOUND_IDLE1 = "controller/con_idle1.wav";
	string SOUND_IDLE2 = "controller/con_idle2.wav";
	string SOUND_IDLE3 = "controller/con_idle3.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_ATTACK3 = "controller/con_attack3.wav";
	string SOUND_DEATH = "controller/con_die1.wav";
	string SOUND_PAIN0 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "controller/con_pain1.wav";
	string SOUND_PAIN2 = "controller/con_die2.wav";
	string SOUND_SPIT1 = "bullchicken/bc_attack3.wav";
	string SOUND_SPIT2 = "bullchicken/bc_attack2.wav";
	string SOUND_SPRAY = "ambience/steamburst1.wav";
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
	string SOUND_LAND = "player/pl_fallpain1.wav";
	string BREATH_SPRITE = "poison_cloud.spr";

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "hover";
	string ANIM_WALK = "fly1";
	string ANIM_RUN = "fly2";
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
	string CAN_FLEE = "CAN_FLEE";
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float SPIT_AMMO = 0.0f;
	float BREATH_AMMO = 0.0f;
	int MONSTER_WIDTH = 0;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool I_FLY = false;
	float NPC_GIVE_EXP = 0.0f;
	bool FLIGHT_SCANNING = false;
	string LAST_TARGET = "LAST_TARGET";
	bool SPITTING = false;
	string MOVE_RANGE = "MOVE_RANGE";
	float FIRE_DELAY = 0.0f;
	float NEXT_HSTUCK_CHECK = 0.0f;
	bool SPRAYING_GAS = false;
	string MY_OWNER = "MY_OWNER";
	bool AM_SUMMONED = false;
	bool NO_SPAWN_STUCK_CHECK = false;
	Vector3 SPAWNED_ORG = Vector3();
	float TOTAL_STUCKAGE = 0.0f;
	float FLIGHT_STUCK = 0.0f;
	float LAST_PROG = 0.0f;
	Vector3 LAST_POS = Vector3();
	string OLD_HSTUCK_POS = "OLD_HSTUCK_POS";
	float CUR_SOLUTION = 0.0f;

	// unnamed block (first think)
	void Horror_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		IS_UNHOLY = true;

		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		CAN_FLY = true;
		CAN_HEAR = "1";
		CAN_WANDER = true;

		CAN_RETALIATE = "1";

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10";
		FLINCH_ANIM = "bite2";
		FLINCH_DELAY = "1";

		CAN_FLEE = "1";
		FLEE_DISTANCE = "2048";

		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 125.0f;

		ANIM_IDLE = "hover";
		ANIM_WALK = "fly1";
		ANIM_RUN = "fly2"; // alternates between fly1 and fly2
		ANIM_ATTACK = "bite1";
		ANIM_DEATH = "die";

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 40;

		SPIT_AMMO = 8.0f; // Sometimes gets +2 for false target died message on spawn
		BREATH_AMMO = 1.0f;

		MONSTER_WIDTH = 48; // for anti-stuck

		NO_STUCK_CHECKS = "1"; // for anti-stuck
	}

	// npc_spawn
	void Horror_OnNpcSpawn(string npc = "")
	{
		SetName("Horror");
		SetHealth(500); // hi HP, no armor
		SetWidth(22);
		SetHeight(22);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetFly(true);
		I_FLY = true;
		LegacyCommand("float", 0);
		SetRace("demon");
		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_WALK);
		SetDamageTaken("holy", 4);
		SetDamageTaken("poison", 0);
		SetHearingSensitivity(5);
		SetModel("monsters/edwardgorey.mdl");
		NPC_GIVE_EXP = 200.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		FLIGHT_SCANNING = true;
	}

	// npcatk_targetvalidate
	void Horror_OnNpcatkTargetvalidate(string target = "")
	{
		if (!CanSee("enemy"))
			return;

		LAST_TARGET = EntityId(EntityOf("ent_lastsseen"));

		if (SPIT_AMMO >= 1.0f)
		{
			// hover mode
			SPITTING = true;
			// do not move any closer
			MOVE_RANGE = "9999";
			// movespeed 0.01
			SetIdleAnim(ANIM_HOVER);
			SetMoveAnim(ANIM_HOVER);
			if (int(FIRE_DELAY) == 0)
			{
				FIRE_DELAY = 1.0f;
				CallEventDelayed(0.75f, "reset_fire_delay");
				PlayAnim("critical", ANIM_ATTACK);
				PlayRandomSound(0, 10, SOUND_SPIT1, SOUND_SPIT2);
				SPIT_AMMO -= 1.0f;
			}
		}
		else
		{
			OnFlyMode();
		}
	}

	// reset_fire_delay
	void Horror_OnResetFireDelay()
	{
		FIRE_DELAY = 0.0f;
	}

	// fly_mode
	void Horror_OnFlyMode()
	{
		// setvard NO_STUCK_CHECKS 0
		// movespeed 1.0
		MOVE_RANGE = "30";
		SetIdleAnim(ANIM_HOVER);
		if (BREATH_AMMO > 0.0f)
			ANIM_RUN = ANIM_SPIRAL;
		else
			ANIM_RUN = ANIM_FLY;
		SetMoveAnim(ANIM_RUN);
	}

	// reset_hunt_mode
	void Horror_OnResetHuntMode()
	{
		if (!CYCLED_UP)
			return;
		CallEventDelayed(1.0f, "reset_hunt_mode");

		if (CanSee("enemy"))
			return;
		OnFlyMode();
	}

	// cycle_up
	void Horror_OnCycleUp(string reason = "")
	{
		OnResetHuntMode();
	}

	// npc_selectattack
	// { npc_monster_stuck
	// //dbg I seem to be stuck
	// setmovedest LAST_TARGET MOVE_RANGE
	// //setmovedest game.monster.origin 512 flee
	// }
	void Horror_OnNpcSelectattack()
	{
		bool exitSub = false;

		if (BREATH_AMMO >= 1.0f)
		{
			ANIM_RUN = ANIM_SPIRAL;
			ANIM_ATTACK = ANIM_BREATH;
			BREATH_AMMO -= 1.0f;
			exitSub = true;
		}
		if (exitSub) // else is being screwy here?
			return;

		ANIM_RUN = ANIM_FLY;
		int biteType = RandomInt(1, 4);
		if (biteType > 1)
			ANIM_ATTACK = ANIM_BITE;
		if (biteType == 1)
			ANIM_ATTACK = ANIM_GORE;
	}

	// attack1
	// called by model anim: bite1
	void Horror_OnAttack1()
	{
		bool exitSub = false;

		if (SPITTING)
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_poison_spit2", "view", "none", 500, SPIT_DAMAGE, 0.5f, "none");
			SPITTING = false;
			NEXT_HSTUCK_CHECK = GameTime() + 3.0f;
			if (SPIT_AMMO == 0.0f)
				OnFlyMode();
			exitSub = true;
		}
		if (exitSub)
			return;

		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (RandomInt(1, 2) == 1) // developer - set back to 20
			ANIM_ATTACK = ANIM_GORE;
	}

	// attack2
	// called by model anim: bite2
	void Horror_OnAttack2()
	{
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);

		ANIM_ATTACK = ANIM_BITE;

		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= ATTACK_HITRANGE))
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 1, RelativeVelocity(Vector3(-250, 50, 10)), 0);
	}

	// stop_spraying
	void Horror_OnStopSpraying()
	{
		SPRAYING_GAS = false;
	}

	// spiral_charge
	// called by model anim: fly2
	void Horror_OnSpiralCharge()
	{
		if (RandomInt(1, 2) == 1) // try to vary moves
			ANIM_RUN = ANIM_FLY;
		PlayRandomSound(0, 10, SOUND_FLAP1, SOUND_FLAP2);
	}

	// turret_horror
	// called by model anim: hover
	void Horror_OnTurretHorror()
	{
		PlayRandomSound(0, 10, SOUND_FLAP1, SOUND_FLAP2);
	}

	// game_death
	void Horror_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -200)));
	}

	// npc_death
	void Horror_OnNpcDeath()
	{
		// setsolid none
		// setbbox none
		// setprop ent_me movetype const.movetype.noclip
		// setanim.movespeed 30
		// movespeed 2.0
		// addvelocity ent_me $relvel(0,0,-50)
		SetMoveAnim(ANIM_DEATH);
		SetIdleAnim(ANIM_DEAD);

		PlaySound(0, 10, SOUND_DEATH);
		PlayAnim("critical", ANIM_DEATH);
	}

	// npc_struck
	void Horror_OnNpcStruck(float damage = 0.0f)
	{
		float myHealth = HealthOf(ENT_ME);
		float myHurtStage = Divide(MaxHealthOf(ENT_ME), 2.0f);

		if (myHealth >= myHurtStage)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth <= myHurtStage)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);
	}

	// breath_reload
	void Horror_OnBreathReload()
	{
		BREATH_AMMO += 1.0f;
	}

	// breath_attack
	// called by model anim: breath
	void Horror_OnBreathAttack()
	{
		// dbg temp Breath Ammo
		// tempent trail 	<modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		Effect("tempent", "trail", BREATH_SPRITE, RelativePosition(Vector3(0, 32, 0)), RelativePosition(Vector3(0, 200, 20)), 1, 1, 8, 15, 0); // maybe make new summon NPC
		PlaySound(0, 10, SOUND_SPRAY);

		SPRAYING_GAS = true;
		// dodamage $relpos(0,64,0) 250 10 100% 0 reflective	//crash - wtf?
		CallEventDelayed(1.0f, "stop_spraying");

		if (RangeTo(ENT_LASTSEEN) <= ATTACK_BLIND_RANGE) {}

		// apply dot? since no more blind? I dunno
		// dbg Trying to poison Range $get(ent_laststruckbyme,range) of ATTACK_HITRANGE
		if (!(BREATH_AMMO <= 0.0f))
			return;
		CallEventDelayed(20.0f, "breath_reload");
	}

	// my_target_died
	// new in base_npc_attack
	void Horror_OnMyTargetDied(string offender = "")
	{
		SPIT_AMMO += 2.0f;
	}

	// npcatk_stopflee
	void Horror_OnNpcatkStopflee()
	{
		ANIM_RUN = ANIM_SPIRAL;
	}

	// idle_sounds
	void Horror_OnIdleSounds()
	{
		float nextSound = Random(3, 10);

		CallEventDelayed(nextSound, "idle_sounds");

		if (HUNT_LASTTARGET != "\xEF\xBF\xBDNONE\xEF\xBF\xBD")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// game_dynamically_created
	void Horror_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		AM_SUMMONED = true;
		NO_SPAWN_STUCK_CHECK = true;

		SPAWNED_ORG = MyOrigin();
		// dbg spawned @ SPAWNED_ORG
		CallEventDelayed(10.0f, "check_stuck_summon");
	}

	// check_stuck_summon
	void Horror_OnCheckStuckSummon()
	{
		bool exitSub = false;
		if (SPITTING)
		{
			CallEventDelayed(5.0f, "check_stuck_summon");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CanSee("player"))
		{
			exitSub = true;
			CallEventDelayed(5.0f, "check_stuck_summon");
		}
		if (exitSub)
			return;

		if (Text(MyOrigin()) == Text(SPAWNED_ORG))
			OnNpcSuicide();
		else
			OnAsTeleStuckCheck();
	}

	// game_death
	void Horror_OnGameDeath_2(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (AM_SUMMONED)
			CallExternal(MY_OWNER, "horror_died");
	}

	// remove_total_stuckage
	void Horror_OnRemoveTotalStuckage()
	{
		TOTAL_STUCKAGE -= 1.0f;
	}

	// unnamed block (timer)
	void Horror_Timer()
	{
		CallEventDelayed(1.0f, "Horror_Timer");
		if (!IS_HUNTING)
			return;
		OnNpcatkFaceattacker();
		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE && CanSee(NPCATK_TARGET))
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			SetVelocity(ENT_ME, Vector3(0, 0, 0));
		if (I_R_FROZEN)
			SetVelocity(ENT_ME, Vector3(0, 0, 0));
		if (SPITTING && CanSee(HUNT_LASTTARGET))
			SetVelocity(ENT_ME, Vector3(0, 0, 0));

		if (FLIGHT_STUCK > 4.0f)
		{
			// callevent chicken_run 1.0
			OnDoRandTweedee();
			OnNpcatkSuspendAi(Text(Random(0.3f, 0.9f)));
			SetMoveDest(NEW_DEST, Eval("game.monster.moveprox"));
			CallEventDelayed(0.1f, "horror_boost");
			TOTAL_STUCKAGE += 1.0f;
			CallEventDelayed(5.0f, "remove_total_stuckage");
			if (TOTAL_STUCKAGE > 3.0f && AM_SUMMONED)
				OnNpcSuicide();
			FLIGHT_STUCK = 0.0f;
		}

		Vector3 targPos = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI)
			SetAngle("face_origin", targPos);

		if (IS_FLEEING)
			return;
		if (SPITTING)
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;
		float curProg = Distance(MyOrigin(), targPos);
		if (LAST_PROG >= curProg)
			FLIGHT_STUCK += 1.0f;
		LAST_PROG = Distance(MyOrigin(), targPos);
		LAST_POS = MyOrigin();
	}

	// chicken_run
	void Horror_OnChickenRun(float duration = 0.0f)
	{
		CallEventDelayed(0.1f, "horror_boost");
	}

	// horror_boost
	void Horror_OnHorrorBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 500, 0)));
	}

	// npcatk_hunt
	void Horror_OnNpcatkHunt()
	{
		bool exitSub = false;
		if (!IsAlive(HUNT_LASTTARGET))
			return;
		if (SPITTING && CanSee(HUNT_LASTTARGET))
			exitSub = true;
		if (exitSub)
			return;
		if (!(GameTime() > NEXT_HSTUCK_CHECK))
			return;
		NEXT_HSTUCK_CHECK = GameTime() + 0.5f;
		if (OLD_HSTUCK_POS == "OLD_HSTUCK_POS")
		{
			OLD_HSTUCK_POS = Text(OriginOf(ENT_ME));
			exitSub = true;
		}
		if (exitSub)
			return;

		Vector3 pos = OriginOf(ENT_ME);
		if (Distance(pos, Vec(OLD_HSTUCK_POS)) < 32.0f)
		{
			if (RangeTo(HUNT_LASTTARGET) > ATTACK_RANGE)
			{
				CUR_SOLUTION += 1.0f;
				if (CUR_SOLUTION == 1.0f)
				{
					if (!BAST_STUCK_DID_INIT)
					{
						OnAsTeleStuckCheck();
						OLD_HSTUCK_POS = Text(pos);
					}
				}
				else
				{
					CUR_SOLUTION = 0.0f;
					float rndLeft = Random(-1000, 1000);
					float rndFwd = Random(-2000, 1000);
					float rndUp = Random(-1000, 1000);
					// local RND_YAW $randf(0,359.99)
					// local MY_VEL $get(ent_me,velocity)
					DebugPrint("solution #2 " + Text(rndLeft) + " " + Text(rndFwd) + " " + Text(rndUp));
					SetVelocity(ENT_ME, RelativeVelocity(Vector3(rndLeft, rndFwd, rndUp)));
				}
			}
		}
		else
		{
			OLD_HSTUCK_POS = Text(pos);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseFlyer_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseFlyer_OnNpcatkTargetvalidate(target); // monsters/base_flyer
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		Horror_OnNpcatkTargetvalidate(target);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseFlyer_OnNpcSelectattack(); // monsters/base_flyer
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		Horror_OnNpcSelectattack();
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Horror_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
		Horror_OnGameDeath_2(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		Horror_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Horror_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		Horror_OnNpcatkHunt();
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		BaseNpcAttackNew_OnNpcatkStopflee(); // monsters/base_npc_attack_new
		Horror_OnNpcatkStopflee();
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttackNew_OnChickenRun(duration); // monsters/base_npc_attack_new
		Horror_OnChickenRun(duration);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		Horror_OnMyTargetDied(offender);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		Horror_OnCycleUp(reason);
	}

	void OnResetFireDelay() { Horror_OnResetFireDelay(); } // reset_fire_delay
	void OnFlyMode() { Horror_OnFlyMode(); } // fly_mode
	void OnResetHuntMode() { Horror_OnResetHuntMode(); } // reset_hunt_mode
	void OnAttack1() { Horror_OnAttack1(); } // attack1
	void OnAttack2() { Horror_OnAttack2(); } // attack2
	void OnStopSpraying() { Horror_OnStopSpraying(); } // stop_spraying
	void OnSpiralCharge() { Horror_OnSpiralCharge(); } // spiral_charge
	void OnTurretHorror() { Horror_OnTurretHorror(); } // turret_horror
	void OnNpcDeath() { Horror_OnNpcDeath(); } // npc_death
	void OnNpcStruck(float damage = 0.0f) { Horror_OnNpcStruck(damage); } // npc_struck
	void OnBreathReload() { Horror_OnBreathReload(); } // breath_reload
	void OnBreathAttack() { Horror_OnBreathAttack(); } // breath_attack
	void OnIdleSounds() { Horror_OnIdleSounds(); } // idle_sounds
	void OnCheckStuckSummon() { Horror_OnCheckStuckSummon(); } // check_stuck_summon
	void OnRemoveTotalStuckage() { Horror_OnRemoveTotalStuckage(); } // remove_total_stuckage
	void OnHorrorBoost() { Horror_OnHorrorBoost(); } // horror_boost
	void OnNextSound() {} // NEXT_SOUND

	// This file's events and timers by their .script names
	bool Horror_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "breath_attack") { OnBreathAttack(); return true; }
		if (name == "breath_reload") { OnBreathReload(); return true; }
		if (name == "check_stuck_summon") { OnCheckStuckSummon(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "fly_mode") { OnFlyMode(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "horror_boost") { OnHorrorBoost(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "remove_total_stuckage") { OnRemoveTotalStuckage(); return true; }
		if (name == "reset_fire_delay") { OnResetFireDelay(); return true; }
		if (name == "reset_hunt_mode") { OnResetHuntMode(); return true; }
		if (name == "spiral_charge") { OnSpiralCharge(); return true; }
		if (name == "stop_spraying") { OnStopSpraying(); return true; }
		if (name == "turret_horror") { OnTurretHorror(); return true; }
		if (name == "Horror_Timer") { Horror_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/horror"]
shared class HorrorScript : BaseMonsterNewScript, Horror, BaseFlyer
{
	// Variables declared by included files, with the value they start with in this script
	HorrorScript()
	{
		ANIM_IDLE = "hover";
		ANIM_WALK = "fly1";
		ANIM_RUN = "fly2";
		SOUND_DEATH = "controller/con_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("monsters/edwardgorey.mdl");
		CallEventDelayed(1.0f, "Horror_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Horror_FirstThink();
		BaseFlyer_FirstThink();
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
		return Horror_DispatchEvent(name, params)
			|| BaseFlyer_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
