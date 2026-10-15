#pragma context server

// Converted from orc_for/goblin_base.script by msc_transpiler.
// Blood goblin fodder by Thothie
// Weakest of the blood goblins
// generic randomized high-end goblin with random weapon
// All the bgoblins and vgoblins use this as their base, hence its complexity
// In addition the hobgoblin_ scripts use this base their base
// The old goblin_ scripts, however, still use their original configurations, and do not share this script

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GoblinBase
{
	// Constants
	string FLINCH_CHANCE = "25%";
	string ANIM_SMASH = "battleaxe_swing1_L";
	string ANIM_SWIPE = "swordswing1_L";
	string ANIM_WARCRY = "warcry";
	string ANIM_KICK = "kick";
	string ANIM_BOW = "shootorcbow";
	int DMG_CLUB = 0;
	float DMG_AXE = 0.0f;
	float DMG_SWORD = 0.0f;
	int GOB_TYPE = 0;
	int GOBLIN_JUMPRANGE = 512;
	int DMG_FIREBALL = 50;
	int DMG_FIREBALL_DOT = 10;
	float FREQ_FIREBALL = 0.0f;
	bool GOB_JUMPER = true;
	string ANIM_PARRY = "deflectcounter";
	int CHARGE_SPEED = 600;
	float FREQ_CHARGE = 10.0f;
	bool GOB_CHARGER = true;
	int GOB_CHARGE_MIN_DIST = 128;
	int GOB_CHARGE_MAX_DIST = 256;
	int MIN_FIREBALL_DIST = 96;
	float FREQ_LEAP_AWAY = 0.0f;
	float FREQ_GOB_JUMP = 0.0f;
	bool NEW_MODEL = true;
	float FREQ_ZDIFF_JUMP = 0.0f;
	int GOB_MAX_ZDIFF_JUMP_RANGE = 600;
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN1 = "monsters/goblin/c_gargoyle_hit1.wav";
	string SOUND_PAIN2 = "monsters/goblin/c_gargoyle_hit2.wav";
	string SOUND_ALERT1 = "monsters/goblin/c_goblin_bat1.wav";
	string SOUND_ALERT2 = "monsters/goblin/c_goblin_bat2.wav";
	string SOUND_IDLE = "monsters/goblin/c_goblin_slct.wav";
	string SOUND_ATTACK1 = "monsters/goblin/c_goblin_atk1.wav";
	string SOUND_ATTACK2 = "monsters/goblin/c_goblin_atk2.wav";
	string SOUND_ATTACK3 = "monsters/goblin/c_goblin_atk3.wav";
	string SOUND_FIREBALL_CAST = "monsters/goblin/c_gargoyle_slct.wav";
	string SOUND_FIREBALL = "magic/fireball_strike.wav";
	string SOUND_JUMP1 = "monsters/goblin/c_goblin_hit1.wav";
	string SOUND_JUMP2 = "monsters/goblin/c_goblin_hit2.wav";
	string SOUND_PARRY1 = "body/armour1.wav";
	string SOUND_PARRY2 = "body/armour2.wav";
	string SOUND_PARRY3 = "body/armour3.wav";
	string SOUND_CHIEF_ALERT = "monsters/goblin/c_goblinchf_bat1.wav";
	string SOUND_SHAM_ALERT = "monsters/goblin/c_goblinwiz_bat1.wav";
	string SOUND_DEATH = "monsters/goblin/c_goblin_dead.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "ANIM_RUN";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	string ANIM_DEATH = "ANIM_DEATH";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_ANIM = "FLINCH_ANIM";
	float FLINCH_HEALTH = 0.0f;
	float GOB_LEAP_AWAY_THRESHOLD = 0.0f;
	bool TOSS_FIREBALL = false;
	float NEXT_ZDIFF_JUMP = 0.0f;
	float GOB_NEXT_JUMP = 0.0f;
	float NEXT_FIREBALL = 0.0f;
	float AS_ATTACKING = 0.0f;
	float NEXT_CHARGE = 0.0f;
	string STUN_LIST = "STUN_LIST";
	bool GOB_JUMP_SCANNING = false;
	bool DBL_JUMP = false;
	float NEXT_LEAP_AWAY = 0.0f;
	float NEXT_GOB_HOP = 0.0f;
	bool CYCLES_STARTED = false;
	float UP_JUMP_STR = 0.0f;
	float FWD_JUMP_STR = 0.0f;

	// unnamed block (first think)
	void GoblinBase_FirstThink()
	{
		// base
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 120.0f;
		ATTACK_MOVERANGE = 48.0f;
		MOVE_RANGE = "48";
		NPC_GIVE_EXP = 200.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 15);
		NPC_ALLY_RESPONSE_RANGE = 4096.0f;
		ANIM_DEATH = "die_fallback";
		CAN_FLINCH = "1";
		FLINCH_ANIM = "flinch";
		FLINCH_HEALTH = 100.0f;
	}

	// npc_spawn
	void GoblinBase_OnNpcSpawn(string npc = "")
	{
		SetBlood("red"); // green for v_goblin
		SetRoam(true);
		SetHearingSensitivity(2);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		OnGoblinSpawn();
		CallEventDelayed(2.0f, "final_post_spawn_checks");
		CallEventDelayed(1.0f, "idle_mode");
		CallEventDelayed(0.01f, "goblin_pre_spawn"); // use to reset setvard props handled by post_spawn
	}

	// goblin_pre_spawn
	// not required in this script, but here to stop console spam
	void GoblinBase_OnGoblinPreSpawn()
	{
		ATTACK_RANGE = 64.0f;
		ATTACK_HITRANGE = 120.0f;
		ATTACK_MOVERANGE = 48.0f;
		MOVE_RANGE = "48";
	}

	// goblin_spawn
	void GoblinBase_OnGoblinSpawn()
	{
		CallEventDelayed(0.01f, "goblin_set_weapon");
	}

	// final_post_spawn_checks
	void GoblinBase_OnFinalPostSpawnChecks()
	{
		GOB_LEAP_AWAY_THRESHOLD = MaxHealthOf(ENT_ME) * 0.05f;
	}

	// swing_axe
	// ANIM_SMASH
	void GoblinBase_OnSwingAxe()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (Float(GetVar("F_GOB_TYPE")) == 1.0f)
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_CLUB, GetVar("ATTACK_HITCHANCE"), "blunt");
		if (Float(GetVar("F_GOB_TYPE")) == 2.0f)
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_AXE, GetVar("ATTACK_HITCHANCE"), "slash");
	}

	// swing_sword
	// ANIM_SWIPE
	void GoblinBase_OnSwingSword()
	{
		if (TOSS_FIREBALL)
			OnTossFireball();
		if (TOSS_FIREBALL)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWORD, GetVar("ATTACK_HITCHANCE"), "slash");
	}

	// toss_fireball
	void GoblinBase_OnTossFireball()
	{
		TOSS_FIREBALL = false;

		Vector3 pos = OriginOf(ENT_ME) + RelativePosition(AnglesOf(ENT_ME), Vector3(0, 48, 28));
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_fire_ball", pos, NPCATK_TARGET, 400, DMG_FIREBALL, 0.5f, "none");
		CallExternal(ENT_LASTPROJECTILE, "lighten", DMG_FIREBALL_DOT, 0.01f);
		PlaySound(0, 10, SOUND_FIREBALL);
	}

	// npcatk_hunt
	void GoblinBase_OnNpcatkHunt()
	{
		OnGobHunt();
	}

	// gob_hunt
	void GoblinBase_OnGobHunt()
	{
		float myZ = 0.0f;
		bool exitSub = false;

		if (!IsAlive(NPCATK_TARGET))
			return;
		if (SUSPEND_AI)
			return;
		if (I_R_FROZEN)
			return;

		if (Truthy(GetVar("CAN_FIREBALL")) && !IS_FLEEING && GameTime() > NEXT_FIREBALL)
			OnPrepFireball();

		if (!GOB_CHARGER)
			return;

		if (I_R_FROZEN)
			return;
		if (IS_FLEEING)
			return;
		if (Truthy(GetVar("AM_LATCHED")))
			return;
		if (Truthy(GetVar("IN_LEAP")))
			return;
		if (Truthy(GetVar("LEAP_MODE")))
			return;

		// mega-jump if opponent out of reach
		if (GameTime() > NEXT_ZDIFF_JUMP && GOB_JUMPER)
		{
			if (RangeTo(NPCATK_TARGET) < GOB_MAX_ZDIFF_JUMP_RANGE && GameTime() > NEXT_ZDIFF_JUMP)
			{
				myZ = OriginOf(ENT_ME).z;
				float targZ = OriginOf(NPCATK_TARGET).z;
				if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
					targZ -= 38.0f;

				float zDiff = targZ;
				string zDiffText;
				zDiff -= myZ;

				if (zDiff > ATTACK_RANGE)
				{
					OnGobHopZdiff(zDiff);
					exitSub = true;
					NEXT_ZDIFF_JUMP = GameTime() + FREQ_ZDIFF_JUMP;

					// don't do a positional jump and random jump one after the other
					GOB_NEXT_JUMP = GameTime() + FREQ_GOB_JUMP;
				}
			}

			if (RangeTo(NPCATK_TARGET) > GOB_CHARGE_MIN_DIST)
				if (RangeTo(NPCATK_TARGET) < GOB_CHARGE_MAX_DIST) {}
		}

		// randomly jump forward if far enough and haven't attacked recently
		if (GOB_JUMPER && GameTime() > GOB_NEXT_JUMP && RangeTo(NPCATK_TARGET) < GOBLIN_JUMPRANGE && RangeTo(NPCATK_TARGET) > ATTACK_HITRANGE)
		{
			GOB_NEXT_JUMP = GameTime() + FREQ_GOB_JUMP;

			// jump at target if he's higher than I am
			Vector3 mePos = MyOrigin();
			myZ = mePos.z;
			Vector3 targetPos = OriginOf(NPCATK_TARGET);
			float targetZ = targetPos.z;
			float targetZDifference = targetZ - myZ;

			if (targetZDifference < 500.0f) // not hoplessly high up - handled above
			{
				PlayAnim("critical", ANIM_SMASH);
				CallEventDelayed(0.1f, "gob_hop");
				// don't do a zdiff jump for a bit
				NEXT_ZDIFF_JUMP = GameTime() + FREQ_ZDIFF_JUMP;
			}
		}

		if (GameTime() > NEXT_CHARGE)
			OnLeapForward();
	}

	// prep_fireball
	void GoblinBase_OnPrepFireball()
	{
		if (!(RangeTo(NPCATK_TARGET) > MIN_FIREBALL_DIST))
			return;
		if (!CanSee(NPCATK_TARGET))
			return;
		NEXT_FIREBALL = GameTime() + FREQ_FIREBALL;
		TOSS_FIREBALL = true;
		PlayAnim("critical", ANIM_SWIPE);
		PlaySound(0, 10, SOUND_FIREBALL_CAST);
		AS_ATTACKING = GameTime() + 10.0f;
	}

	// leap_forward
	void GoblinBase_OnLeapForward()
	{
		NEXT_CHARGE = GameTime() + FREQ_CHARGE;
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2);
		PlayAnim("critical", ANIM_SMASH);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, CHARGE_SPEED, 100)));
		CallEventDelayed(0.5f, "leap_stun");
	}

	// leap_stun
	void GoblinBase_OnLeapStun()
	{
		STUN_LIST = LegacyFunction("get_tsphere", "enemy", 64, MyOrigin());
		if (STUN_LIST == "none")
			return;
		int count = GetTokenCount(STUN_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunTargets();
		}
	}

	// stun_targets
	void GoblinBase_OnStunTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(STUN_LIST, loopIteration));
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 200, 120)));
	}

	// cycle_up
	void GoblinBase_OnCycleUp(string reason = "")
	{
		OnGobCycleUp();
	}

	// gob_cycle_up
	void GoblinBase_OnGobCycleUp()
	{
		// delay first fireball
		NEXT_FIREBALL = GameTime() + Random(10, 30);

		if (GOB_JUMP_SCANNING)
			return;
		GOB_JUMP_SCANNING = true;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2);
	}

	// cycle_down
	void GoblinBase_OnCycleDown()
	{
		GOB_JUMP_SCANNING = false;
		SetMoveAnim(ANIM_WALK);
		CallEventDelayed(1.0f, "idle_mode");
	}

	// gob_hop
	void GoblinBase_OnGobHop()
	{
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2);
		float jumpHeight = RandomInt(350, 550);
		if (DBL_JUMP)
		{
			jumpHeight *= 2.0f;
			DBL_JUMP = false;
		}
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// game_death
	void GoblinBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// hide arrow
		SetModelBody(2, 0);
	}

	// idle_mode
	void GoblinBase_OnIdleMode()
	{
		if (NPCATK_TARGET != "unset")
			return;
		if (!CanSee("ally"))
			return;
		SetMoveDest(ENT_LASTSEEN, 9999);
		PlayAnim("once", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(10, 20), "idle_mode");
		CallExternal(ENT_LASTSEEN, "ext_faceme", self);
	}

	// ext_faceme
	void GoblinBase_OnExtFaceme(CBaseEntity@ target = null)
	{
		if (NPCATK_TARGET != "unset")
			return;
		SetMoveDest(@target, 9999);
		CallEventDelayed(0.1f, "reply_anim");
	}

	// reply_anim
	void GoblinBase_OnReplyAnim()
	{
		PlayAnim("once", ANIM_WARCRY);
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string GoblinBase_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!Truthy(GetVar("AM_LATCHED")))
			PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
		else
			CallExternal(GetVar("LATCH_TARGET"), "ext_playrandomsound", 0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);

		if (damage > GOB_LEAP_AWAY_THRESHOLD && !Truthy(GetVar("AIMING_CAGE")) && GameTime() > NEXT_LEAP_AWAY && RangeTo(attacker) < 150.0f)
		{
			NEXT_LEAP_AWAY = GameTime() + FREQ_LEAP_AWAY;
			if (!Truthy(GetVar("AM_LATCHED")) && !Truthy(GetVar("IN_LEAP")) && !Truthy(GetVar("LEAP_MODE")))
				OnGobLeapAway(attacker);
		}
		return result;
	}

	// gob_leap_away
	void GoblinBase_OnGobLeapAway(CBaseEntity@ target = null)
	{
		OnNpcatkFlee(EntityId(target), "512", "1.0");
		CallEventDelayed(0.1f, "gob_leap_away2");
	}

	// gob_leap_away2
	void GoblinBase_OnGobLeapAway2()
	{
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2);
		PlayAnim("critical", ANIM_SMASH);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, CHARGE_SPEED, 100)));
	}

	// npc_selectattack
	void GoblinBase_OnNpcSelectattack()
	{
		// I'm in swing range, don't do random jump unless struck
		// dbg npc_selectattack
		float nextGobHop = NEXT_GOB_HOP + 1.0f;
		if (!(GameTime() > nextGobHop))
			return;

		NEXT_GOB_HOP = GameTime() + 2.0f;
	}

	// cycle_up
	// Zdiff jump
	void GoblinBase_OnCycleUp_2(string reason = "")
	{
		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		OnJumpCheck();
	}

	// gob_hop_zdiff
	// =================== Hop up at targets out of reach (from elf_base)
	// <vertical_difference> - determines jump strength
	void GoblinBase_OnGobHopZdiff(float verticalDifference = 0.0f)
	{
		PlayAnim("critical", ANIM_SMASH);
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2);
		UP_JUMP_STR = verticalDifference * 5.0f;
		SetMoveDest(NPCATK_TARGET, AS_MOVEPROX);
		if (!SUSPEND_AI)
			OnNpcatkSuspendAi("1.0");
		FWD_JUMP_STR = RangeTo(NPCATK_TARGET);
		// dbg do_hop UP_JUMP_STR FWD_JUMP_STR
		CallEventDelayed(0.1f, "gob_hop_zdiff_boost");
	}

	// gob_hop_zdiff_boost
	void GoblinBase_OnGobHopZdiffBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, FWD_JUMP_STR, UP_JUMP_STR)));
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
		GoblinBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		GoblinBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GoblinBase_OnNpcatkHunt();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		GoblinBase_OnCycleUp(reason);
		GoblinBase_OnCycleUp_2(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		GoblinBase_OnCycleDown();
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		GoblinBase_OnNpcSelectattack();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GoblinBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	void OnGoblinPreSpawn() { GoblinBase_OnGoblinPreSpawn(); } // goblin_pre_spawn
	void OnGoblinSpawn() { GoblinBase_OnGoblinSpawn(); } // goblin_spawn
	void OnFinalPostSpawnChecks() { GoblinBase_OnFinalPostSpawnChecks(); } // final_post_spawn_checks
	void OnSwingAxe() { GoblinBase_OnSwingAxe(); } // swing_axe
	void OnSwingSword() { GoblinBase_OnSwingSword(); } // swing_sword
	void OnTossFireball() { GoblinBase_OnTossFireball(); } // toss_fireball
	void OnGobHunt() { GoblinBase_OnGobHunt(); } // gob_hunt
	void OnPrepFireball() { GoblinBase_OnPrepFireball(); } // prep_fireball
	void OnLeapForward() { GoblinBase_OnLeapForward(); } // leap_forward
	void OnLeapStun() { GoblinBase_OnLeapStun(); } // leap_stun
	void OnStunTargets() { GoblinBase_OnStunTargets(); } // stun_targets
	void OnGobCycleUp() { GoblinBase_OnGobCycleUp(); } // gob_cycle_up
	void OnGobHop() { GoblinBase_OnGobHop(); } // gob_hop
	void OnIdleMode() { GoblinBase_OnIdleMode(); } // idle_mode
	void OnExtFaceme(CBaseEntity@ target = null) { GoblinBase_OnExtFaceme(target); } // ext_faceme
	void OnReplyAnim() { GoblinBase_OnReplyAnim(); } // reply_anim
	void OnGobLeapAway(CBaseEntity@ target = null) { GoblinBase_OnGobLeapAway(target); } // gob_leap_away
	void OnGobLeapAway2() { GoblinBase_OnGobLeapAway2(); } // gob_leap_away2
	void OnGobHopZdiff(float verticalDifference = 0.0f) { GoblinBase_OnGobHopZdiff(verticalDifference); } // gob_hop_zdiff
	void OnGobHopZdiffBoost() { GoblinBase_OnGobHopZdiffBoost(); } // gob_hop_zdiff_boost
	void OnJumpCheck() {} // jump_check

	// This file's events and timers by their .script names
	bool GoblinBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "ext_faceme") { OnExtFaceme(EntityParam(params, 0)); return true; }
		if (name == "final_post_spawn_checks") { OnFinalPostSpawnChecks(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gob_cycle_up") { OnGobCycleUp(); return true; }
		if (name == "gob_hop") { OnGobHop(); return true; }
		if (name == "gob_hop_zdiff") { OnGobHopZdiff(Float(Param(params, 0))); return true; }
		if (name == "gob_hop_zdiff_boost") { OnGobHopZdiffBoost(); return true; }
		if (name == "gob_hunt") { OnGobHunt(); return true; }
		if (name == "gob_leap_away") { OnGobLeapAway(EntityParam(params, 0)); return true; }
		if (name == "gob_leap_away2") { OnGobLeapAway2(); return true; }
		if (name == "goblin_pre_spawn") { OnGoblinPreSpawn(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "idle_mode") { OnIdleMode(); return true; }
		if (name == "leap_forward") { OnLeapForward(); return true; }
		if (name == "leap_stun") { OnLeapStun(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "prep_fireball") { OnPrepFireball(); return true; }
		if (name == "reply_anim") { OnReplyAnim(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "toss_fireball") { OnTossFireball(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "orc_for/goblin_base"]
shared class GoblinBaseScript : BaseMonsterNewScript, GoblinBase
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK = "ANIM_ATTACK";
	string NPC_BASE_EXP = "NPC_BASE_EXP";

	// Variables declared by included files, with the value they start with in this script
	GoblinBaseScript()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "monsters/goblin/c_goblin_dead.wav";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GoblinBase_FirstThink();
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
		return GoblinBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
