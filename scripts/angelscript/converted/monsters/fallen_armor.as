#pragma context server

// Converted from monsters/fallen_armor.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FallenArmor
{
	// Constants
	string ANIM_WALK_NORM = "walk";
	string ANIM_RUN_NORM = "run";
	string ANIM_WALK_SHIELD = "shield_walk";
	string ANIM_STANCE_IDLE = "idle";
	string ANIM_SIT_IDLE = "sit_idle";
	string ANIM_SHIELD_IDLE = "shield_idle";
	string ANIM_ATTACK_NORM = "attack1";
	string ANIM_ATTACK_STAB = "attack2";
	string ANIM_ATTACK_SHIELD = "shield_attack";
	string ANIM_SUMMON = "summon";
	string ANIM_GETUP = "get_up";
	string ANIM_EQUIP = "equip";
	string ANIM_EQUIP2 = "equip2";
	string ANIM_TOSHIELD = "stance_to_shield";
	string ANIM_TOSTANCE = "shield_to_stance";
	int SHIELD_RANGE = 500;
	int TRIGGER_RANGE = 256;
	int ATTACK_MOVERANGE_NORM = 28;
	int ATTACK_MOVERANGE_SHIELD = 64;
	int ATTACK_HITRANGE_SHIELD = 160;
	int ATTACK_HITRANGE_STAB = 160;
	int ATTACK_HITRANGE_NORM = 128;
	int ATTACK_RANGE_NORM = 80;
	int STAB_DAMAGE = 2200;
	string SWORD_DAMAGE = "$rand(60,120)";
	string SHIELD_DAMAGE = "$rand(50,200)";
	string ACCURACY_SWORD = "80%";
	string ACCURACY_SHIELD = "90%";
	string ACCURACY_STAB = "100%";
	string STAB_FREQ = "$randf(30,60)";
	string SOUND_GETUP = "amb/screeching.wav";
	string SOUND_STEP1 = "player/pl_grate1.wav";
	string SOUND_STEP2 = "player/pl_grate2.wav";
	string SOUND_STEP3 = "player/pl_grate3.wav";
	string SOUND_STEP4 = "player/pl_grate4.wav";
	string SOUND_STRUCK1 = "debris/metal1.wav";
	string SOUND_STRUCK2 = "debris/metal3.wav";
	string SOUND_STRUCKSHIELD1 = "debris/metal6.wav";
	string SOUND_STRUCKSHIELD2 = "doors/doorstop5.wav";
	string SOUND_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_HIT2 = "zombie/claw_strike3.wav";
	string SOUND_LARGESWING = "zombie/claw_miss2.wav";
	string SOUND_MISS1 = "weapons/swingsmall.wav";
	string SOUND_MISS2 = "weapons/cbar_miss1.wav";
	string SOUND_PAIN1 = "x/x_pain1.wav";
	string SOUND_PAIN2 = "x/x_pain3.wav";
	string SOUND_SUMMON = "x/x_ballattack1.wav";
	string SOUND_SUMMON_START = "x/x_recharge2.wav";
	string SOUND_POWERUP = "ambience/particle_suck2.wav";
	string SOUND_PRE_STAB = "x/x_attack2.wav";
	string SOUND_DEATH = "tentacle/te_death2.wav";
	int MOVE_FAST = 200;
	int MOVE_NORMAL = 100;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_IS_BOSS = false;
	bool IMMUNE_VAMPIRE = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_FLEE = "CAN_FLEE";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float MONSTER_STEP = 0.0f;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool WAITING_FOR_PLAYER = false;
	string FIRST_TARGET = "FIRST_TARGET";
	float TOSHIELD_DELAY = 0.0f;
	string NPC_STORE_TARGET = "NPC_STORE_TARGET";
	string CYCLE_TIME = "CYCLE_TIME";
	bool NPC_FORCED_MOVEDEST = false;
	bool SUPER_STABBING = false;
	bool PLAYING_STAB = false;
	bool SWITCHING_STANCE = false;
	bool SHIELD_ON = false;
	bool DID_PAIN_SOUND = false;
	bool AM_SUMMONING = false;
	bool DID_SUMMON = false;
	bool FIN_DID_SUMMON = false;
	bool DID_FIRST_SUMMON = false;
	bool HITBACK_FRUST = false;

	// unnamed block (first think)
	void FallenArmor_FirstThink()
	{
		NPC_GIVE_EXP = 1000.0f;

		if (ToLowerCase(MapName()) == "b_castle")
			NPC_IS_BOSS = true;

		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		ANIM_IDLE = ANIM_SIT_IDLE;
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_DEATH = "dead";
		ANIM_ATTACK = ANIM_ATTACK_NORM; // anim attack is played by main AI whenever in attack range

		// behavior
		CAN_FLINCH = "0";
		CAN_FLEE = "0";

		ATTACK_MOVERANGE = ATTACK_MOVERANGE_NORM; // try to get this close
		ATTACK_RANGE = 80.0f; // attack when this close
		ATTACK_HITRANGE = ATTACK_HITRANGE_NORM; // hit reaches up to this distance
		MONSTER_STEP = 0.0f;
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
	}

	// npc_spawn
	void FallenArmor_OnNpcSpawn(string npc = "")
	{
		OnArmorSpawn();
	}

	// armor_spawn
	void FallenArmor_OnArmorSpawn()
	{
		SetName("Armor of the Fallen");
		SetHealth(6000);
		SetWidth(32);
		SetHeight(96);
		SetRace("demon");
		SetModel("monsters/enemy.mdl");

		SetHearingSensitivity(11);

		SetIdleAnim(ANIM_SIT_IDLE);
		SetMoveAnim(ANIM_SIT_IDLE);

		PlayAnim("once", ANIM_SIT_IDLE);

		SetStat("parry", 30);
		NO_STUCK_CHECKS = "1";

		SetInvincible(true); // invincible until combat begins
		SetDamageTaken("all", 0.1f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("lightning", 1.5f);
		SetDamageTaken("cold", 0.8f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.5f);

		WAITING_FOR_PLAYER = true;
		OnNpcatkSuspendAi(); // suspend AI until combat begins
	}

	// game_heardsound
	void FallenArmor_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!WAITING_FOR_PLAYER)
			return;
		OnArmorHeardsound();
	}

	// armor_heardsound
	void FallenArmor_OnArmorHeardsound()
	{
		// using heardsound as $cansee buggers in some situations (as demonstrated by Keledros)
		if (!WAITING_FOR_PLAYER)
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		if (!(RangeTo(ENT_LASTHEARD) < TRIGGER_RANGE))
			return;
		FIRST_TARGET = EntityId(EntityOf(ENT_LASTHEARD));
		WAITING_FOR_PLAYER = false;
		OnOhItIsOnBiatch();
	}

	// oh_it_is_on_biatch
	void FallenArmor_OnOhItIsOnBiatch()
	{
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		TOSHIELD_DELAY = Random(10, 30);
		CallEventDelayed(TOSHIELD_DELAY, "setup_shield_check");
		PlayAnim("critical", ANIM_GETUP);
	}

	// getup_done
	// called from model when ANIM_GETUP is complete
	void FallenArmor_OnGetupDone()
	{
		SetMoveDest(RelativePosition(Vector3(0, 64, 0)), 10);
		PlayAnim("critical", ANIM_EQUIP);
	}

	// equip_done
	// called from model when ANIM_EQUIP is complete
	void FallenArmor_OnEquipDone()
	{
		UseTrigger("break_throne");

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 256, 5, 5);
		CreateNpc("monsters/companion/spell_maker_divination", RelativePosition(Vector3(0, 0, 50)), self, "none", "none", 64);
		SetModelBody(0, 1); // give weapons
		PlaySound(0, 10, SOUND_POWERUP);
		PlayAnim("critical", ANIM_EQUIP2);
		SetInvincible(false);
		NPC_STORE_TARGET = "unset";
		OnNpcatkResumeAi();
		if (IsAlive(FIRST_TARGET))
			OnNpcatkSettarget(FIRST_TARGET);
		OnStanceOn();
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_IDLE = ANIM_STANCE_IDLE;
		SetIdleAnim(ANIM_STANCE_IDLE);
		SetMoveAnim(ANIM_WALK_NORM);
		CallEventOrDelay(STAB_FREQ, "super_stab_check");
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(RelativePosition(Vector3(0, 64, 0)), 10);
		CallEventDelayed(5.0f, "restore_stuck_checks");
	}

	// restore_stuck_checks
	void FallenArmor_OnRestoreStuckChecks()
	{
		SetRoam(true);
		NO_STUCK_CHECKS = "0";
	}

	// super_stab_check
	void FallenArmor_OnSuperStabCheck()
	{
		float nextStabCheck = 0.0f;
		bool exitSub = false;

		if (NPCATK_TARGET == "unset")
		{
			// nothing to stab, check again real soon
			nextStabCheck = Float(STAB_FREQ);
			nextStabCheck = Divide(nextStabCheck, 4.0f);
			CallEventDelayed(nextStabCheck, "super_stab_check");
			// dbg temp SuperstabAbort no_target
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!CanSee(NPCATK_TARGET))
		{
			// can't see target, check again real soon
			nextStabCheck = Float(STAB_FREQ);
			nextStabCheck = Divide(nextStabCheck, 4.0f);
			CallEventDelayed(nextStabCheck, "super_stab_check");
			// dbg temp SuperstabAbort cant_see_target
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!SHIELD_ON)
		{
			PlaySound(0, 10, SOUND_PRE_STAB);
			Effect("glow", ENT_ME, Vector3(200, 200, 255), 256, 5, 5);
			SUPER_STABBING = true; // flag to tell him not to change stances until super stab complete
			CallEventDelayed(2.0f, "do_super_stab");
			CallEventOrDelay(STAB_FREQ, "super_stab_check");
		}

		if (SHIELD_ON)
		{
			// can't do super stab in this stance, check again later, but reduce time
			nextStabCheck = Float(STAB_FREQ);
			nextStabCheck = Divide(nextStabCheck, 2.0f);
			CallEventDelayed(nextStabCheck, "super_stab_check");
		}
	}

	// do_super_stab
	void FallenArmor_OnDoSuperStab()
	{
		OnNpcatkSuspendAi("6.0");
		PLAYING_STAB = true;
		PlayAnim("break");
		PlayAnim("critical", ANIM_ATTACK_STAB);
		SetMoveAnim(ANIM_ATTACK_STAB);
		SetIdleAnim(ANIM_ATTACK_STAB);
	}

	// stab_strike
	// called from model when ANIM_ATTACK_STAB @ frame 24
	void FallenArmor_OnStabStrike()
	{
		// ai is suspended during this strike, so use ent_lastseen instead of the stored NPCATK_TARGET
		OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE_STAB), Text(STAB_DAMAGE), ACCURACY_STAB, "magic");
		OnNpcatkResumeAi();
		SUPER_STABBING = false;
		PLAYING_STAB = false;
		OnStanceOn();
	}

	// setup_shield_check
	void FallenArmor_OnSetupShieldCheck()
	{
		// alternate periodically between stances
		TOSHIELD_DELAY = Random(10, 30);
		CallEventDelayed(TOSHIELD_DELAY, "setup_shield_check");

		if (NPCATK_TARGET == "unset")
			return;

		if (!SHIELD_ON && !SUPER_STABBING && RangeTo(NPCATK_TARGET) <= SHIELD_RANGE)
		{
			OnNpcatkSuspendAi("1.0"); // suspend AI for a sec to ensure anim completes
			PlayAnim("break");
			PlayAnim("critical", ANIM_TOSHIELD);
		}

		if (SHIELD_ON)
		{
			OnNpcatkSuspendAi("1.0"); // suspend AI for a sec to ensure anim completes
			PlayAnim("break");
			PlayAnim("critical", ANIM_TOSTANCE);
		}
	}

	// unnamed block (timer)
	void FallenArmor_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(1.0f, "FallenArmor_Timer");

		if (NPCATK_TARGET == "unset")
		{
			ANIM_WALK = ANIM_WALK_NORM;
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
		}

		if (NPCATK_TARGET == "unset")
			return;
		if (SWITCHING_STANCE)
			return;

		float targetRange = RangeTo(NPCATK_TARGET);
		if (targetRange > SHIELD_RANGE)
		{
			if (SHIELD_ON)
				PlayAnim("critical", "shield_to_stance");
			ANIM_RUN = ANIM_RUN_NORM;
			SWITCHING_STANCE = true;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!CanSee(NPCATK_TARGET) && SHIELD_ON)
		{
			PlayAnim("critical", "shield_to_stance");
			ANIM_RUN = ANIM_RUN_NORM;
			SWITCHING_STANCE = true;
		}
	}

	// sword_strike
	// called from model when ANIM_ATTACK_NORM @ frame 15
	void FallenArmor_OnSwordStrike()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SWORD_DAMAGE, ACCURACY_SWORD, "slash");
	}

	// shield_strike
	// called from model when ANIM_ATTACK_SHIELD @ frame 20
	void FallenArmor_OnShieldStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SHIELD_DAMAGE, ACCURACY_SHIELD, "slash");
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string FallenArmor_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
		{
			if (ANIM_ATTACK == "attack1")
				PlayRandomSound(0, 10, SOUND_MISS1, SOUND_MISS2);
			if (ANIM_ATTACK == "attack2")
				PlaySound(0, 10, SOUND_LARGESWING);
			if (ANIM_ATTACK == "shield_attack")
				PlaySound(0, 10, SOUND_LARGESWING);
		}
		if (hit)
			PlayRandomSound(0, 10, SOUND_HIT1, SOUND_HIT2);
		return result;
	}

	// stance_on
	// called from model when ANIM_TOSTANCE is complete
	void FallenArmor_OnStanceOn()
	{
		SetStat("parry", 30);
		SetDamageTaken("all", 0.4f);
		SHIELD_ON = false;
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_RUN = ANIM_RUN_NORM;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		ANIM_ATTACK = ANIM_ATTACK_NORM;
		ATTACK_MOVERANGE = ATTACK_MOVERANGE_NORM;
		ATTACK_HITRANGE = ATTACK_HITRANGE_NORM;
		SWITCHING_STANCE = false;
	}

	// shield_on
	// called from model when ANIM_TOSHIELD is complete
	void FallenArmor_OnShieldOn()
	{
		SetStat("parry", 60);
		SetDamageTaken("all", 0.1f);
		SHIELD_ON = true;
		ANIM_WALK = ANIM_WALK_SHIELD;
		ANIM_RUN = ANIM_WALK_SHIELD;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_SHIELD_IDLE);
		ANIM_ATTACK = ANIM_ATTACK_SHIELD;
		ATTACK_MOVERANGE = ATTACK_MOVERANGE_SHIELD;
		ATTACK_HITRANGE = ATTACK_HITRANGE_SHIELD;
		SWITCHING_STANCE = false;
	}

	// run_step
	// called from model during anim "run" @ frames 6 and 13
	void FallenArmor_OnRunStep()
	{
		MONSTER_STEP += 1.0f;
		if (MONSTER_STEP == 1.0f)
			PlaySound(0, 10, SOUND_STEP1);
		if (MONSTER_STEP == 2.0f)
			PlaySound(0, 10, SOUND_STEP2);
		if (MONSTER_STEP == 3.0f)
			PlaySound(0, 10, SOUND_STEP3);
		if (MONSTER_STEP == 4.0f)
		{
			PlaySound(0, 10, SOUND_STEP4);
			MONSTER_STEP = 0.0f;
		}
	}

	// game_struck
	// PARAM1 = inc damage
	void FallenArmor_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (MyHealth() < 2000.0f && damage > 30.0f && RandomInt(1, 10) == 1)
		{
			PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2);
			DID_PAIN_SOUND = true;
		}

		if (!DID_PAIN_SOUND)
		{
			if (SHIELD_ON)
				PlayRandomSound(0, 10, SOUND_STRUCKSHIELD1, SOUND_STRUCKSHIELD2);
			if (!SHIELD_ON)
				PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
		}
		DID_PAIN_SOUND = false;

		if (DID_SUMMON)
			return;
		if (!(MyHealth() < 4000.0f))
			return;
		// dbg temp Summoning Armors...
		OnNpcatkSuspendAi();
		SetMoveAnim(ANIM_SUMMON);
		SetIdleAnim(ANIM_SUMMON);
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 256, 5, 5);
		PlaySound(0, 10, SOUND_SUMMON_START);
		PlayAnim("break");
		PlayAnim("critical", ANIM_SUMMON);
		AM_SUMMONING = true;
		DID_SUMMON = true;
		FIN_DID_SUMMON = false;
		CallEventDelayed(0.25f, "summon_loop");
		CallEventDelayed(5.0f, "summon_done");
	}

	// summon_loop
	void FallenArmor_OnSummonLoop()
	{
		if (FIN_DID_SUMMON)
			return;
		CallEventDelayed(0.25f, "summon_loop");
	}

	// cycle_up
	void FallenArmor_OnCycleUp(string reason = "")
	{
		if (DID_FIRST_SUMMON)
			return;
		DID_FIRST_SUMMON = true;
		CallEventDelayed(10.0f, "first_summon");
	}

	// first_summon
	void FallenArmor_OnFirstSummon()
	{
		PlayAnim("critical", ANIM_SUMMON);
	}

	// summon_done
	// also called from model but not dependable
	void FallenArmor_OnSummonDone()
	{
		if (FIN_DID_SUMMON)
			return;
		FIN_DID_SUMMON = true;
		CreateNpc("monsters/companion/spell_maker_summoning", RelativePosition(Vector3(0, 0, 50)), self, "none", "none", 64);
		OnNpcatkResumeAi();
		PlaySound(0, 10, SOUND_SUMMON);
		// summons are handled by map
		// dbg temp Summon complete
		OnStanceOn();
		UseTrigger("summon_armors");
		AM_SUMMONING = false;
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void FallenArmor_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		NPC_HACKED_MOVE_SPEED = MOVE_FAST;
		if (SHIELD_ON)
			NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
		if (NPCATK_TARGET == "unset")
			NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
		if (PLAYING_STAB)
			NPC_HACKED_MOVE_SPEED = 0.0f;
		if (AM_SUMMONING)
			NPC_HACKED_MOVE_SPEED = 0.0f;
		SetAnimMoveSpeed(NPC_HACKED_MOVE_SPEED); // Force move, since the animation doesn't have the required movement
	}

	// game_stopmoving
	void FallenArmor_OnGameStopmoving()
	{
		SetAnimMoveSpeed(0); // Force Stop
	}

	// npcatk_suspend_ai
	void FallenArmor_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		HITBACK_FRUST = false;
		SetMoveDest("none");
		OnGameStopmoving();
	}

	// npc_selectattack
	void FallenArmor_OnNpcSelectattack()
	{
		SetAnimMoveSpeed(0);
	}

	// npc_death
	void FallenArmor_OnNpcDeath()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 190, 20, 15, 1024);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		FallenArmor_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		FallenArmor_OnNpcSpawn(npc);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		FallenArmor_OnGameHeardsound(soundType, origin, dangerRadius);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		FallenArmor_OnNpcatkSuspendAi(seconds, debugTag);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, FallenArmor_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		FallenArmor_OnCycleUp(reason);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		FallenArmor_OnNpcSelectattack();
	}

	void OnArmorSpawn() { FallenArmor_OnArmorSpawn(); } // armor_spawn
	void OnArmorHeardsound() { FallenArmor_OnArmorHeardsound(); } // armor_heardsound
	void OnOhItIsOnBiatch() { FallenArmor_OnOhItIsOnBiatch(); } // oh_it_is_on_biatch
	void OnGetupDone() { FallenArmor_OnGetupDone(); } // getup_done
	void OnEquipDone() { FallenArmor_OnEquipDone(); } // equip_done
	void OnRestoreStuckChecks() { FallenArmor_OnRestoreStuckChecks(); } // restore_stuck_checks
	void OnSuperStabCheck() { FallenArmor_OnSuperStabCheck(); } // super_stab_check
	void OnDoSuperStab() { FallenArmor_OnDoSuperStab(); } // do_super_stab
	void OnStabStrike() { FallenArmor_OnStabStrike(); } // stab_strike
	void OnSetupShieldCheck() { FallenArmor_OnSetupShieldCheck(); } // setup_shield_check
	void OnSwordStrike() { FallenArmor_OnSwordStrike(); } // sword_strike
	void OnShieldStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false) { FallenArmor_OnShieldStrike(hitType, endPos, hitEntity, hit); } // shield_strike
	void OnStanceOn() { FallenArmor_OnStanceOn(); } // stance_on
	void OnShieldOn() { FallenArmor_OnShieldOn(); } // shield_on
	void OnRunStep() { FallenArmor_OnRunStep(); } // run_step
	void OnSummonLoop() { FallenArmor_OnSummonLoop(); } // summon_loop
	void OnFirstSummon() { FallenArmor_OnFirstSummon(); } // first_summon
	void OnSummonDone() { FallenArmor_OnSummonDone(); } // summon_done
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { FallenArmor_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnGameStopmoving() { FallenArmor_OnGameStopmoving(); } // game_stopmoving
	void OnNpcDeath() { FallenArmor_OnNpcDeath(); } // npc_death
	void OnNextStabCheck() {} // NEXT_STAB_CHECK
	void OnStabFreq() {} // STAB_FREQ
	void OnToshieldDelay() {} // TOSHIELD_DELAY

	// This file's events and timers by their .script names
	bool FallenArmor_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "armor_heardsound") { OnArmorHeardsound(); return true; }
		if (name == "armor_spawn") { OnArmorSpawn(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_super_stab") { OnDoSuperStab(); return true; }
		if (name == "equip_done") { OnEquipDone(); return true; }
		if (name == "first_summon") { OnFirstSummon(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "getup_done") { OnGetupDone(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "oh_it_is_on_biatch") { OnOhItIsOnBiatch(); return true; }
		if (name == "restore_stuck_checks") { OnRestoreStuckChecks(); return true; }
		if (name == "run_step") { OnRunStep(); return true; }
		if (name == "setup_shield_check") { OnSetupShieldCheck(); return true; }
		if (name == "shield_on") { OnShieldOn(); return true; }
		if (name == "shield_strike") { OnShieldStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "stab_strike") { OnStabStrike(); return true; }
		if (name == "stance_on") { OnStanceOn(); return true; }
		if (name == "summon_done") { OnSummonDone(); return true; }
		if (name == "summon_loop") { OnSummonLoop(); return true; }
		if (name == "super_stab_check") { OnSuperStabCheck(); return true; }
		if (name == "sword_strike") { OnSwordStrike(); return true; }
		if (name == "FallenArmor_Timer") { FallenArmor_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/fallen_armor"]
shared class FallenArmorScript : BaseMonsterNewScript, FallenArmor
{
	// Variables declared by included files, with the value they start with in this script
	FallenArmorScript()
	{
		SOUND_DEATH = "tentacle/te_death2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/enemy.mdl");
		CallEventDelayed(1.0f, "FallenArmor_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FallenArmor_FirstThink();
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
		return FallenArmor_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
