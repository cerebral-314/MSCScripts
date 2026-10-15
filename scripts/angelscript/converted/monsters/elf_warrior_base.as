#pragma context server

// Converted from monsters/elf_warrior_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ElfWarriorBase
{
	// Constants
	string ANIM_MOVE_FAST = "run";
	string ANIM_MOVE_CAUTIOUS = "run_squatwalk1_R";
	string ANIM_IDLE_CAUTIOUS = "stand_squatwalk1_R";
	string ANIM_IDLE_NORMAL = "deep_idle";
	string ANIM_LOOK = "look_idle";
	string ANIM_GUARD_IDLE = "stand";
	string ANIM_DUCK_MOVE = "crawl";
	string ANIM_DUCK_IDLE = "crouch_idle";
	string ANIM_JUMP = "jump";
	string ANIM_LONG_JUMP = "long_jump";
	string ANIM_AURA = "prepare_fireball";
	string ANIM_DEATH1 = "die_simple";
	string ANIM_DEATH2 = "die_backwards1";
	string ANIM_DEATH3 = "die_backwards";
	string ANIM_DEATH4 = "die_forwards";
	string ANIM_DEATH5 = "headshot";
	string ANIM_DEATH6 = "die_spin";
	string ANIM_DEATH7 = "gutshot";
	string ANIM_ATTACK_1H = "swordswing1_R";
	string ANIM_ATTACK_2H = "longsword_swipe_L";
	string ANIM_ATTACK_JAB = "swordjab1_R";
	string ANIM_ATTACK_1H_READY = "swordready1_R";
	string ANIM_ATTACK_GAXE = "battleaxe_swing1_L";
	string ANIM_SPELL_PREP = "prepare_fireball";
	string ANIM_SPELL_CUDDLE = "aim_fireball_R";
	string ANIM_SPELL_FIRE = "throw_fireball_R";
	string ANIM_DRAW_SWORD = "swordready1_R";
	string ANIM_MA_IDLE = "aim_fists";
	string ANIM_ATTACK_MA = "aim_punch1";
	string ANIM_KICK = "stance_normal_highkick_r1";
	string ANIM_SWEEP = "stance_normal_lowkick_r1";
	string ANIM_PARRY = "longsword_parry";
	string ANIM_BLOCK = "aim_block1_L";
	string ANIM_HOLD_AURA = "aim_sword1_R";
	string ELF_MODEL = "npc/elf_f_warrior.mdl";
	int WALK_RANGE = 200;
	int DMG_MELEE = 300;
	string DMG_TYPE = "slash";
	string DMG_KICK = "400";
	string DOT_SCRIPT = "effects/dot_fire";
	string DOT_AMT = "50";
	float DOT_DURATION = 5.0f;
	string ATTACK_HITCHANCE = "90%";
	string CHANCE_STUN = "0%";
	string CHANCE_DOT = "0%";
	float STUN_DURATION = 10.0f;
	float FREQ_LOOK = 5.0f;
	bool CAN_THROW = false;
	int DMG_THROW = 600;
	int THROW_SPEED = 600;
	int THROW_RANGE = 512;
	float FREQ_THROW = 6.0f;
	string KNIFE_TYPE = "poison";
	string KNIFE_THROW_ITEM = "proj_k_knife";
	bool CAN_KICK = false;
	float FREQ_KICK = 0.0f;
	int KICK_RANGE = 90;
	bool LEAP_AFTER_KICK = false;
	bool CAN_JUMP = true;
	float FREQ_JUMP = 5.0f;
	int MAX_JUMP_RANGE = 600;
	bool CAN_FREEZE_AURA = false;
	int FREEZE_AURA_RADIUS = 128;
	float FREEZE_AURA_DURATION = 10.0f;
	string FREEZE_AURA_CL_SCRIPT = "effects/sfx_ice_burst";
	int FREQ_FREEZE_AURA = 25;
	bool WEAPON_AURA = false;
	string WAURA_TYPE = "lightning";
	string WAURA_EFFECT_SCRIPT = "effects/dot_lightning";
	int WAURA_RANGE = 128;
	string WEAPON_AURA_CL_SCRIPT = "monsters/telf_warrior_laxe_cl";
	int DMG_WAURA = 300;
	int DOT_WAURA = 100;
	string WAURA_DMG_TYPE = "lightning_effect";
	float FREQ_WAURA = 0.0f;
	float WAURA_DURATION = 5.0f;
	string SOUND_WAURA_START = "magic/bolt_end.wav";
	string SOUND_WAURA_LOOP = "magic/bolt_loop.wav";
	bool CAN_BLOCK = false;
	float FREQ_BLOCK = 0.0f;
	float BLOCK_DURATION = 5.0f;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_SHIELD1 = "weapons/axemetal1.wav";
	string SOUND_SHIELD2 = "weapons/axemetal2.wav";
	string SOUND_SHIELD3 = "doors/doorstop5.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACK_CRY1 = "npc/elvenfemale/ElfF_Attack1.wav";
	string SOUND_ATTACK_CRY2 = "npc/elvenfemale/ElfF_Attack2.wav";
	string SOUND_ATTACK_CRY3 = "npc/elvenfemale/ElfF_Attack3.wav";
	string SOUND_PAIN1 = "npc/elvenfemale/ElfF_Criticalhit.wav";
	string SOUND_PAIN2 = "npc/elvenfemale/ElfF_Pain1.wav";
	string SOUND_PAIN3 = "npc/elvenfemale/ElfF_Pain2.wav";
	string SOUND_PAIN4 = "npc/elvenfemale/ElfF_Pain3.wav";
	string SOUND_DEATH = "npc/elvenfemale/ElfF_Die.wav";
	string SOUND_THROW = "zombie/claw_miss1.wav";
	string SOUND_DRAW = "weapons/dagger/dagger2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk2";
	string ANIM_IDLE = "deep_idle";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ELF_HALF_HEALTH = 0.0f;
	string DEF_ANIM_WALK = "DEF_ANIM_WALK";
	string DEF_ANIM_RUN = "DEF_ANIM_RUN";
	string DEF_ANIM_IDLE = "DEF_ANIM_IDLE";
	float FIRST_CYCLE = 0.0f;
	float NEXT_KICK = 0.0f;
	float NEXT_THROW = 0.0f;
	float NEXT_JUMP = 0.0f;
	float NEXT_FREEZE_AURA = 0.0f;
	float NEXT_WAURA = 0.0f;
	float NEXT_BLOCK = 0.0f;
	bool CAUTIOUS_MOVE = false;
	bool THROWING_KNIFE = false;
	bool MELEE_ATTACK = false;
	float LAST_HIT_FOR = 0.0f;
	float NEXT_CALM_TIME = 0.0f;
	string ANIM_DEATH = "ANIM_DEATH";
	string KNIFE_TARGET = "KNIFE_TARGET";
	float AS_ATTACKING = 0.0f;
	float AS_ATTAKCING = 0.0f;
	string ALCO_TYPE = "ALCO_TYPE";
	bool DOING_LEAP = false;
	string LEAP_TARGET = "LEAP_TARGET";
	bool NPC_FORCED_MOVEDEST = false;
	string REPULSE_LIST = "REPULSE_LIST";
	float UP_JUMP_STR = 0.0f;
	float FWD_JUMP_STR = 0.0f;
	string FREEZE_TARGS = "FREEZE_TARGS";
	bool WAURA_ON = false;
	string WAURA_TARGETS = "WAURA_TARGETS";
	string BLOCK_TARGET = "BLOCK_TARGET";
	bool AM_BLOCKING = false;
	float NEXT_LOOK = 0.0f;
	float MAX_SUSPEND = 0.0f;
	bool AM_ESCORT = false;

	// unnamed block (first think)
	void ElfWarriorBase_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk2";
		ANIM_IDLE = "deep_idle";

		ANIM_RUN = "run";
		ANIM_ATTACK = "swordswing1_R";
	}

	// unnamed block (first think)
	void ElfWarriorBase_FirstThink2()
	{
		// base stats
		ATTACK_MOVERANGE = 48.0f;
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 120.0f;
	}

	// npc_spawn
	// ==================================== Init
	void ElfWarriorBase_OnNpcSpawn(string npc = "")
	{
		SetModel(ELF_MODEL);
		SetWidth(24);
		SetHeight(80);
		SetRoam(true);

		SetHearingSensitivity(10);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		// general elemental resistance
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("poison", 0.5f);
		SetDamageTaken("lightning", 0.5f);

		SetDamageTaken("holy", 0); // native to plane

		OnElfSpawn();

		ELF_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;

		DEF_ANIM_WALK = ANIM_WALK;
		DEF_ANIM_RUN = ANIM_RUN;
		DEF_ANIM_IDLE = ANIM_IDLE;
		CallEventDelayed(3.0f, "mark_def_anims");

		FIRST_CYCLE = GameTime() + 10.0f;
	}

	// npc_post_spawn
	void ElfWarriorBase_OnNpcPostSpawn()
	{
		OnCloseMouth();

		if (!Truthy(GetVar("AM_ARCHER")))
			return;
		ANIM_ATTACK = "shootbow";
		ATTACK_RANGE = 800.0f;
		ATTACK_HITRANGE = 800.0f;
	}

	// mark_def_anims
	// give time for the top script to redefine
	void ElfWarriorBase_OnMarkDefAnims()
	{
		DEF_ANIM_WALK = ANIM_WALK;
		DEF_ANIM_RUN = ANIM_RUN;
		DEF_ANIM_IDLE = ANIM_IDLE;
	}

	// suspend_movement
	// ==================================== Movement Suspend
	// - This shouldn't be needed, but something in the base AI or code is causing creatuers to move when when the AI is suspended
	void ElfWarriorBase_OnSuspendMovement(string holdAnimation = "")
	{
		ANIM_WALK = holdAnimation;
		ANIM_RUN = holdAnimation;
		ANIM_IDLE = holdAnimation;
		SetMoveAnim(holdAnimation);
		SetIdleAnim(holdAnimation);
		SetRoam(false);
	}

	// resume_movement
	void ElfWarriorBase_OnResumeMovement()
	{
		ANIM_WALK = DEF_ANIM_WALK;
		ANIM_RUN = DEF_ANIM_RUN;
		ANIM_IDLE = DEF_ANIM_IDLE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		SetRoam(true);
	}

	// cycle_npc
	// ==================================== Alerts / Releases
	void ElfWarriorBase_OnCycleNpc(string mode = "")
	{
		string nearAlly = "NEAR_ALLY";
		if (mode == "test")
		{
			// debug
			SetSayTextRange(1024);
			SayText("Is that... An orc?");
			nearAlly = FindInSphere("ally", 1024);
			if (nearAlly != "none")
				CallExternal(GetToken(nearAlly, 0), "ext_say_orc");
		}
		if (ToLowerCase(MapName()) != "the_wall")
			return;
		if (!Truthy(GetVar("G_ORC_ALERT")))
			return;
		SetGlobal("G_ORC_ALERT", 0);
		SetSayTextRange(1024);
		SayText("Is that... An Orc?");
		nearAlly = FindInSphere("ally", 1024);
		if (nearAlly == "none")
			return;
		CallExternal(GetToken(nearAlly, 0), "ext_say_orc");
	}

	// npc_targetsighted
	void ElfWarriorBase_OnNpcTargetsighted(string target = "")
	{
		if (!IsPlayer(NPCATK_TARGET))
			return;
		if (GetVar("G_ESCORT_ALERT_SAYTEXT") == "G_ESCORT_ALERT_SAYTEXT") // in case escort alert text not yet set due to spawn order
			return;
		if (AM_ESCORT)
		{
			if (!Truthy(GetVar("G_DID_ESCORT_ALERT"))) // reset by each leader
			{
				SetSayTextRange(1024);
				SayText(GetVar("G_ESCORT_ALERT_SAYTEXT"));
				SetGlobal("G_DID_ESCORT_ALERT", 1);
			}
		}
	}

	// cycle_up
	void ElfWarriorBase_OnCycleUp(string reason = "")
	{
		if (GetVar("ATTACK_STANCE") == "1h")
		{
			PlayAnim("critical", ANIM_ATTACK_1H_READY);
			OnMoveType(1);
		}

		if (CAN_KICK)
			NEXT_KICK = GameTime() + FREQ_KICK;
	}

	// cycle_down
	void ElfWarriorBase_OnCycleDown()
	{
		if (GetVar("ATTACK_STANCE") == "1h")
			OnMoveType(0);
	}

	// my_target_died
	void ElfWarriorBase_OnMyTargetDied(string offender = "")
	{
		if (GetVar("ATTACK_STANCE") == "1h")
			OnMoveType(0);
	}

	// heard_cycle_down
	void ElfWarriorBase_OnHeardCycleDown()
	{
		if (GetVar("ATTACK_STANCE") == "1h")
			OnMoveType(0);
	}

	// npc_heard_player
	void ElfWarriorBase_OnNpcHeardPlayer()
	{
		if (GetVar("ATTACK_STANCE") == "1h")
			OnMoveType(1);
	}

	// npcatk_hunt
	// ==================================== Main Cycle
	void ElfWarriorBase_OnNpcatkHunt()
	{
		bool exitSub = false;

		if (SUSPEND_AI && GameTime() > MAX_SUSPEND)
			OnNpcatkResumeAi();

		float gameTime = GameTime(); // we're checking game.time a lot in this sub, so store it here

		if (!(gameTime > FIRST_CYCLE)) // suspend cycles until we're sure we're fully initialized
			return;

		if (NPCATK_TARGET == "unset")
			return;

		if (SUSPEND_AI)
			return;

		if (GetVar("ATTACK_STANCE") == "1h")
		{
			// walk calmly up to opponent if not struck within last 5 secs
			if (gameTime > NEXT_CALM_TIME)
			{
				if (RangeTo(NPCATK_TARGET) < WALK_RANGE)
				{
					if (CanSee(NPCATK_TARGET))
						OnMoveType(1);
					else
						OnMoveType(0);
				}
				else
				{
					OnMoveType(0);
				}
			}
			else
			{
				OnMoveType(0);
			}
		}

		// endif ATTACK_STANCE equals 1h
		if (CAN_THROW && gameTime > NEXT_THROW && !DOING_LEAP && CanSee(NPCATK_TARGET) && RangeTo(NPCATK_TARGET) > ATTACK_RANGE && RangeTo(NPCATK_TARGET) < THROW_RANGE)
		{
			NEXT_THROW = gameTime + FREQ_THROW;
			OnThrowKnife(NPCATK_TARGET);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CAN_KICK && gameTime > NEXT_KICK)
		{
			NEXT_KICK = gameTime;
			if (RangeTo(NPCATK_TARGET) < KICK_RANGE)
			{
				NEXT_KICK += FREQ_KICK;
				OnDoKick();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		// jump at targets too high
		if (CAN_JUMP && gameTime > NEXT_JUMP && RangeTo(NPCATK_TARGET) < MAX_JUMP_RANGE)
		{
			float myZ = OriginOf(ENT_ME).z;
			float targZ = OriginOf(NPCATK_TARGET).z;
			if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
				targZ -= 38.0f;

			float zDiff = targZ;
			string zDiffText;
			zDiff -= myZ;

			if (zDiff > ATTACK_RANGE)
			{
				OnDoHop(zDiff);
				exitSub = true;
				NEXT_JUMP = gameTime + FREQ_JUMP;
			}
		}
		if (exitSub)
			return;

		if (CAN_FREEZE_AURA && RangeTo(NPCATK_TARGET) < FREEZE_AURA_RADIUS && gameTime > NEXT_FREEZE_AURA)
		{
			NEXT_FREEZE_AURA = gameTime + FREQ_FREEZE_AURA;
			OnDoFreezeAura();
			exitSub = true;
		}
		if (exitSub)
			return;

		bool canSee = CanSee(NPCATK_TARGET);

		if (WEAPON_AURA && canSee && RangeTo(NPCATK_TARGET) < WAURA_RANGE && gameTime > NEXT_WAURA)
		{
			NEXT_WAURA = gameTime + FREQ_WAURA;
			OnDoWaura();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CAN_BLOCK && canSee && gameTime > NEXT_BLOCK)
		{
			NEXT_BLOCK = gameTime + FREQ_BLOCK;
			OnDoBlock();
		}
	}

	// npc_selectattack
	// ==================================== Attack switches
	void ElfWarriorBase_OnNpcSelectattack()
	{
		int rndAtk = 0;
		if (GetVar("ATTACK_STANCE") == "assasin")
		{
			rndAtk = RandomInt(1, 2);
			if (rndAtk == 1)
				ANIM_ATTACK = ANIM_ATTACK_1H;
			else
				ANIM_ATTACK = ANIM_ATTACK_JAB;
		}

		if (GetVar("ATTACK_STANCE") == "2hsword")
		{
			rndAtk = RandomInt(1, 2);
			if (rndAtk == 1)
				ANIM_ATTACK = ANIM_ATTACK_2H;
			else
				ANIM_ATTACK = ANIM_ATTACK_GAXE;
		}
	}

	// move_type
	// ==================================== Calm approach
	// 1=Cautious 0=Combat
	void ElfWarriorBase_OnMoveType(int cautious = 0)
	{
		if (GetVar("ATTACK_STANCE") != "1h")
			return;
		if (SUSPEND_AI)
			return;

		// dbg move_type PARAM1 CAUTIOUS_MOVE
		if (cautious == 1)
		{
			if (!CAUTIOUS_MOVE)
			{
				CAUTIOUS_MOVE = true;
				SetMoveAnim(ANIM_MOVE_CAUTIOUS);
				SetIdleAnim(ANIM_IDLE_CAUTIOUS);
			}
		}
		else if (CAUTIOUS_MOVE)
		{
			CAUTIOUS_MOVE = false;
			SetMoveAnim(ANIM_MOVE_FAST);
			SetIdleAnim(ANIM_IDLE_NORMAL);
		}
	}

	// combat_move
	void ElfWarriorBase_OnCombatMove()
	{
		CAUTIOUS_MOVE = false;
		SetMoveAnim(ANIM_MOVE_FAST);
		SetIdleAnim(ANIM_IDLE_NORMAL);
	}

	// frame_melee_1h
	// ==================================== Anim Events
	void ElfWarriorBase_OnFrameMelee1h()
	{
		bool exitSub = false;

		// <target> <range> <dmg> <cth> [type]
		if (THROWING_KNIFE)
		{
			THROWING_KNIFE = false;
			exitSub = true;
		}
		if (exitSub)
			return;

		OnMeleeAttack();
	}

	// frame_jab
	void ElfWarriorBase_OnFrameJab()
	{
		OnMeleeAttack();
	}

	// frame_axe2
	void ElfWarriorBase_OnFrameAxe2()
	{
		OnMeleeAttack();
	}

	// frame_melee_2h
	void ElfWarriorBase_OnFrameMelee2h()
	{
		OnMeleeAttack();
	}

	// frame_kick_high
	void ElfWarriorBase_OnFrameKickHigh()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_KICK, ATTACK_HITCHANCE, DMG_TYPE);
		if (!(RangeTo(NPCATK_TARGET) < KICK_RANGE))
			return;
		ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 10.0f, self);

		if (!LEAP_AFTER_KICK)
			return;
		CallEventDelayed(0.2f, "leap_away");
	}

	// melee_attack
	void ElfWarriorBase_OnMeleeAttack()
	{
		MELEE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_MELEE, ATTACK_HITCHANCE, DMG_TYPE);
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		if (RandomInt(1, 5) != 1)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK_CRY1, SOUND_ATTACK_CRY2, SOUND_ATTACK_CRY3);
		OnMoveMouth();
	}

	// frame_jump_land
	void ElfWarriorBase_OnFrameJumpLand()
	{
		OnForceLeapEnd();
	}

	// frame_hop_land
	void ElfWarriorBase_OnFrameHopLand()
	{
		OnNpcatkResumeAi();
	}

	// game_struck
	// ==================================== Struck
	void ElfWarriorBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		LAST_HIT_FOR = damage;

		// be agitated for at least 5 seconds after being struck
		NEXT_CALM_TIME = GameTime() + 5.0f;

		if (AM_BLOCKING)
			return;

		if (GetVar("ATTACK_STANCE") == "1h")
			OnMoveType(0);

		PlayRandomSound(1, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (damage > 100.0f)
			OnSoundPain();
		else if (HealthOf(ENT_ME) < ELF_HALF_HEALTH && RandomInt(1, 5) == 1)
			OnSoundPain();
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string ElfWarriorBase_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";
		if (!AM_BLOCKING)
			return result;
		CBaseEntity@ attackerId = attacker;
		Vector3 attackerOrg = OriginOf(attacker);
		if (!WithinCone2D(attackerOrg, MyOrigin(), MyAngles(), 1))
			return result;
		if (Contains(damageType, "effect"))
			exitSub = true;
		if (exitSub)
			return result;
		result = AppendResult(result, "0.1");
		float negDmg = -damage;
		DebugPrint("game_damaged " + Text(negDmg));
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, negDmg, 110)));
		PlayRandomSound(0, 10, SOUND_SHIELD1, SOUND_SHIELD2, SOUND_SHIELD3);
		return result;
	}

	// game_dodamage
	// ==================================== Damage specials
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string ElfWarriorBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (MELEE_ATTACK && hit)
		{
			if (Float(CHANCE_STUN) > 0.0f && RandomInt(1, 100) <= Float(CHANCE_STUN))
				ApplyEffect(target, "effects/debuff_stun", STUN_DURATION, self);

			if (Float(CHANCE_DOT) > 0.0f && RandomInt(1, 100) <= Float(CHANCE_DOT))
				ApplyEffect(target, DOT_SCRIPT, DOT_DURATION, self, DOT_AMT);
		}
		MELEE_ATTACK = false;
		return result;
	}

	// npc_death
	// ==================================== Handle Death
	void ElfWarriorBase_OnNpcDeath()
	{
		int rndDeath = RandomInt(1, 7);
		if (rndDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (rndDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (rndDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (rndDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (rndDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;
		if (rndDeath == 6)
			ANIM_DEATH = ANIM_DEATH6;
		if (rndDeath == 7)
			ANIM_DEATH = ANIM_DEATH7;
		if (LAST_HIT_FOR > 100.0f) // spin out from heavy killing blows
			ANIM_DEATH = ANIM_DEATH6;
		OnCloseMouth();

		if (Float(GetVar("G_TELF_ESCORTS")) > 0.0f && AM_ESCORT)
		{
			LegacyCommand("subtract", "G_TELF_ESCORTS", 1); // The_Wall escort tracker
		}
	}

	// throw_knife
	// ==================================== Throw Knife
	// <PARAM1> target
	void ElfWarriorBase_OnThrowKnife(string target = "")
	{
		PlayRandomSound(1, 10, SOUND_ATTACK_CRY1, SOUND_ATTACK_CRY2, SOUND_ATTACK_CRY3);
		THROWING_KNIFE = true;
		KNIFE_TARGET = target;
		AS_ATTACKING = GameTime();
		AS_ATTAKCING += 5.0f;
		OnNpcatkSuspendAi();
		SetModelBody(1, 0);
		SetRoam(false);
		SetIdleAnim(ANIM_ATTACK_1H);
		SetMoveAnim(ANIM_ATTACK_1H);
		SetMoveDest(KNIFE_TARGET, 9999);
		PlayAnim("critical", ANIM_ATTACK_1H);
		PlaySound(0, 10, SOUND_THROW);
		CallEventDelayed(0.25f, "throw_knife2");
		CallEventDelayed(0.75f, "throw_knife_done");
	}

	// throw_knife2
	void ElfWarriorBase_OnThrowKnife2()
	{
		ALCO_TYPE = KNIFE_TYPE;

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(KNIFE_THROW_ITEM, RelativePosition(Vector3(0, 38, 22)), KNIFE_TARGET, THROW_SPEED, DMG_THROW, 0.2f, "none");
	}

	// throw_knife_done
	void ElfWarriorBase_OnThrowKnifeDone()
	{
		PlaySound(0, 10, SOUND_DRAW);
		SetModelBody(1, 1);
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkResumeAi();
	}

	// do_kick
	// ==================================== Kick
	void ElfWarriorBase_OnDoKick()
	{
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("critical", ANIM_KICK);
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		PlayRandomSound(0, 10, SOUND_ATTACK_CRY1, SOUND_ATTACK_CRY2, SOUND_ATTACK_CRY3);
	}

	// leap_away
	// ==================================== Leap Away
	void ElfWarriorBase_OnLeapAway(string target = "")
	{
		OnNpcatkSuspendAi();
		DOING_LEAP = true;
		LEAP_TARGET = target;
		if (!IsAlive(LEAP_TARGET))
			LEAP_TARGET = NPCATK_TARGET;
		SetMoveDest(LEAP_TARGET, 1024, "flee");
		NPC_FORCED_MOVEDEST = true;
		PlayAnim("critical", ANIM_LONG_JUMP);
		SetMoveAnim(ANIM_LONG_JUMP);
		OnSoundPain();
		OnRepulseArea();
		CallEventDelayed(0.1f, "leap_away_boost");
		CallEventDelayed(2.0f, "force_leap_end");
	}

	// leap_away_boost
	void ElfWarriorBase_OnLeapAwayBoost()
	{
		// addvelocity ent_me $relvel(0,1000,400)
		Vector3 leapTargOrg = OriginOf(LEAP_TARGET);
		float targAng = AnglesTo(leapTargOrg, MyOrigin());
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 800, 120)));
	}

	// force_leap_end
	void ElfWarriorBase_OnForceLeapEnd()
	{
		if (!DOING_LEAP)
			return;
		DOING_LEAP = false;
		SetMoveAnim(ANIM_RUN);
		OnNpcatkResumeAi();
	}

	// repulse_area
	void ElfWarriorBase_OnRepulseArea()
	{
		PlaySound(0, 10, "magic/boom.wav");
		ClientEvent("new", "all", "monsters/cold_one_cl", "repulse", OriginOf(ENT_ME), 128, 1);
		REPULSE_LIST = FindInSphere("enemy", 128);
		if (REPULSE_LIST == "none")
			return;
		int count = GetTokenCount(REPULSE_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRepulseTargets();
		}
	}

	// repulse_targets
	void ElfWarriorBase_OnRepulseTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(REPULSE_LIST, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 10)));
	}

	// do_hop
	// ==================================== Hop up at targets out of reach
	// <vertical_difference> - determines jump strength
	void ElfWarriorBase_OnDoHop(float verticalDifference = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_ATTACK_CRY1, SOUND_ATTACK_CRY2, SOUND_ATTACK_CRY3);
		UP_JUMP_STR = verticalDifference * 5.0f;
		OnNpcatkSuspendAi("1.0");
		FWD_JUMP_STR = RangeTo(NPCATK_TARGET);
		DebugPrint("do_hop " + Text(UP_JUMP_STR) + " " + Text(FWD_JUMP_STR));
		PlayAnim("critical", ANIM_JUMP);
		CallEventDelayed(0.1f, "do_jump_boost");
	}

	// do_jump_boost
	void ElfWarriorBase_OnDoJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, FWD_JUMP_STR, UP_JUMP_STR)));
	}

	// do_freeze_aura
	// ==================================== Litch Tounge Freeze Aura
	void ElfWarriorBase_OnDoFreezeAura()
	{
		ClientEvent("new", "all", FREEZE_AURA_CL_SCRIPT, OriginOf(ENT_ME), FREEZE_AURA_RADIUS, 1, Vector3(128, 128, 255));
		PlayAnim("critical", ANIM_AURA);
		AS_ATTACKING = GameTime() + 3.0f;
		CallEventDelayed(0.25f, "do_freeze_aura2");
	}

	// do_freeze_aura2
	void ElfWarriorBase_OnDoFreezeAura2()
	{
		FREEZE_TARGS = FindInSphere("enemy", FREEZE_AURA_RADIUS);
		if (FREEZE_TARGS == "none")
			return;
		int count = GetTokenCount(FREEZE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFeezeTargets();
		}
	}

	// feeze_targets
	void ElfWarriorBase_OnFeezeTargets()
	{
		string curTarg = GetToken(FREEZE_TARGS, loopIteration);
		if (!IsAlive(curTarg))
			return;
		if (!IsOnGround(curTarg))
			return;
		ApplyEffect(curTarg, "effects/dot_cold_freeze", FREEZE_AURA_DURATION, self, DOT_AMT);
	}

	// sound_pain
	void ElfWarriorBase_OnSoundPain()
	{
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3, SOUND_PAIN4);
		OnMoveMouth();
	}

	// move_mouth
	// can't seem to figure a way to garuntee the gals mouth will move without being left open
	// so we do random, and figure it'll close at least half the time
	void ElfWarriorBase_OnMoveMouth()
	{
		string rndSay1 = "[" + Text(Random(0.5f, 1)) + "]";
		Say(rndSay1);
	}

	// do_waura
	// ==================================== Weapon Aura (made after the litchtoungue, or we woulda dealt with that here too)
	void ElfWarriorBase_OnDoWaura()
	{
		SetProp(ENT_ME, "controller0", 150); // model weridness - straighten back
		// leaning to side too, may need to fix that controller as well
		OnNpcatkSuspendAi();
		PlayAnim("hold", ANIM_HOLD_AURA);
		OnSuspendMovement(ANIM_HOLD_AURA);
		ClientEvent("new", "all", WEAPON_AURA_CL_SCRIPT, IndexOf(ENT_ME), WAURA_DURATION);
		PlaySound(0, 10, SOUND_WAURA_START);
		WAURA_ON = true;
		CallEventDelayed(0.5f, "do_waura_loop");
		CallEventDelayed(WAURA_DURATION, "end_waura");
		AS_ATTACKING = GameTime() + 5.0f + WAURA_DURATION;
	}

	// do_waura_loop
	void ElfWarriorBase_OnDoWauraLoop()
	{
		if (!WAURA_ON)
			return;
		CallEventDelayed(1.0f, "do_waura_loop");
		if (SOUND_WAURA_LOOP != "none")
			ServerPlaySound(1, 10, SOUND_WAURA_LOOP);
		// xdodamage $get(ent_me,origin) WAURA_RANGE DMG_WAURA 0 ent_me ent_me none WAURA_DMG_TYPE
		WAURA_TARGETS = FindInSphere("enemy", WAURA_RANGE);
		if (WAURA_TARGETS == "none")
			return;
		int count = GetTokenCount(WAURA_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDoWauraAffectTargs();
		}
	}

	// do_waura_affect_targs
	void ElfWarriorBase_OnDoWauraAffectTargs()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(WAURA_TARGETS, loopIteration));
		if (!(HeightOf(curTarg) > 36.0f))
			return;
		ApplyEffect("CUR_TARGET", WAURA_EFFECT_SCRIPT, 5.0f, self, DOT_WAURA);
		DoDamage(curTarg, "direct", DMG_WAURA, "100%", ENT_ME, WAURA_DMG_TYPE);
		if (WAURA_TYPE == "lightning")
		{
			float targResist = DamageTakenOf(curTarg, "lightning");
			float rndRoll = Random(0, 1);
			DebugPrint(Text(rndRoll) + " vs " + Text(targResist));
			if (rndRoll <= targResist)
				Effect("screenfade", @curTarg, 3, 1, Vector3(255, 255, 255), 255, "fadein");
		}
	}

	// end_waura
	void ElfWarriorBase_OnEndWaura()
	{
		DebugPrint("end_waura " + SOUND_WAURA_LOOP);
		SetProp(ENT_ME, "controller0", -1); // model weridness - straighten back
		PlayAnim("break");
		WAURA_ON = false;
		if (SOUND_WAURA_LOOP != "none")
			ServerPlaySound(1, 0, SOUND_WAURA_LOOP);
		OnNpcatkResumeAi();
		OnResumeMovement();

		if (CAN_BLOCK)
		{
			// delay next block so we don't do one vulnerable moment after another
			NEXT_BLOCK = GameTime() + FREQ_BLOCK;
		}
	}

	// do_block
	// ==================================== Shield Block
	void ElfWarriorBase_OnDoBlock()
	{
		DebugPrint("do_block");
		SetProp(ENT_ME, "controller0", 60);
		BLOCK_TARGET = NPCATK_TARGET;
		OnNpcatkSuspendAi();
		PlayAnim("break");
		PlayAnim("hold", ANIM_BLOCK);
		OnSuspendMovement(ANIM_BLOCK);
		AM_BLOCKING = true;
		OnDoBlockLoop();
		CallEventDelayed(BLOCK_DURATION, "end_block");

		AS_ATTACKING = GameTime() + 2.0f + BLOCK_DURATION;
	}

	// do_block_loop
	void ElfWarriorBase_OnDoBlockLoop()
	{
		DebugPrint("do_block_loop");
		if (!AM_BLOCKING)
			return;
		// dbg Blocking...
		if (IsAlive(BLOCK_TARGET))
		{
			CallEventDelayed(0.1f, "do_block_loop");
			SetMoveDest(BLOCK_TARGET, 9999);
		}
		else
		{
			OnEndBlock();
		}
	}

	// end_block
	void ElfWarriorBase_OnEndBlock()
	{
		DebugPrint("end_block");
		if (!AM_BLOCKING)
			return;
		PlayAnim("break");
		SetProp(ENT_ME, "controller0", -1);
		AM_BLOCKING = false;
		OnNpcatkResumeAi();
		OnResumeMovement();
	}

	// npcatk_lost_sight
	// ==================================== Lost target emote
	void ElfWarriorBase_OnNpcatkLostSight()
	{
		if (!(GameTime() > NEXT_LOOK))
			return;
		NEXT_LOOK = GameTime() + FREQ_LOOK;
		PlayAnim("critical", ANIM_LOOK);
	}

	// npcatk_suspend_ai
	// ==================================== BD Prevention
	void ElfWarriorBase_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		MAX_SUSPEND = GameTime() + 10.0f;
	}

	// ext_con
	// ==================================== Debugarry
	void ElfWarriorBase_OnExtCon(float controllerIndex = 0.0f, string controllerValue = "")
	{
		if (controllerIndex == 0.0f)
			SetProp(ENT_ME, "controller0", controllerValue);
		if (controllerIndex == 1.0f)
			SetProp(ENT_ME, "controller1", controllerValue);
		if (controllerIndex == 2.0f)
			SetProp(ENT_ME, "controller2", controllerValue);
		if (controllerIndex == 3.0f)
			SetProp(ENT_ME, "controller3", controllerValue);
	}

	// set_escort
	// ==================================== External for The_Wall
	void ElfWarriorBase_OnSetEscort()
	{
		LegacyCommand("add", "G_TELF_ESCORTS", 1);
		AM_ESCORT = true;
	}

	// close_mouth
	void ElfWarriorBase_OnCloseMouth()
	{
		SetProp(ENT_ME, "controller1", 0);
	}

	// ext_say_orc
	void ElfWarriorBase_OnExtSayOrc()
	{
		SetSayTextRange(2048);
		SayText("It's an undead orc. Some luckless fool of a Marogar trying to plunder the fortresses, no doubt.");
		CallEventDelayed(3.0f, "ext_say_orc2");
	}

	// ext_say_orc2
	void ElfWarriorBase_OnExtSayOrc2()
	{
		SetSayTextRange(2048);
		SayText("Wait... He was looking at something before he came at us...");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		ElfWarriorBase_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ElfWarriorBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		ElfWarriorBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		ElfWarriorBase_OnNpcatkHunt();
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		ElfWarriorBase_OnNpcatkLostSight();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		ElfWarriorBase_OnMyTargetDied(offender);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		ElfWarriorBase_OnNpcatkSuspendAi(seconds, debugTag);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElfWarriorBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		ElfWarriorBase_OnCycleUp(reason);
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		ElfWarriorBase_OnCycleDown();
	}

	// cycle_npc
	void OnCycleNpc(string mode = "")
	{
		BaseNpcAttackNew_OnCycleNpc(mode); // monsters/base_npc_attack_new
		ElfWarriorBase_OnCycleNpc(mode);
	}

	// heard_cycle_down
	void OnHeardCycleDown()
	{
		BaseNpcAttackNew_OnHeardCycleDown(); // monsters/base_npc_attack_new
		ElfWarriorBase_OnHeardCycleDown();
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		ElfWarriorBase_OnNpcSelectattack();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, ElfWarriorBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		ElfWarriorBase_OnNpcTargetsighted(target);
	}

	void OnMarkDefAnims() { ElfWarriorBase_OnMarkDefAnims(); } // mark_def_anims
	void OnSuspendMovement(string holdAnimation = "") { ElfWarriorBase_OnSuspendMovement(holdAnimation); } // suspend_movement
	void OnResumeMovement() { ElfWarriorBase_OnResumeMovement(); } // resume_movement
	void OnNpcHeardPlayer() { ElfWarriorBase_OnNpcHeardPlayer(); } // npc_heard_player
	void OnMoveType(int cautious = 0) { ElfWarriorBase_OnMoveType(cautious); } // move_type
	void OnCombatMove() { ElfWarriorBase_OnCombatMove(); } // combat_move
	void OnFrameMelee1h() { ElfWarriorBase_OnFrameMelee1h(); } // frame_melee_1h
	void OnFrameJab() { ElfWarriorBase_OnFrameJab(); } // frame_jab
	void OnFrameAxe2() { ElfWarriorBase_OnFrameAxe2(); } // frame_axe2
	void OnFrameMelee2h() { ElfWarriorBase_OnFrameMelee2h(); } // frame_melee_2h
	void OnFrameKickHigh() { ElfWarriorBase_OnFrameKickHigh(); } // frame_kick_high
	void OnMeleeAttack() { ElfWarriorBase_OnMeleeAttack(); } // melee_attack
	void OnFrameJumpLand() { ElfWarriorBase_OnFrameJumpLand(); } // frame_jump_land
	void OnFrameHopLand() { ElfWarriorBase_OnFrameHopLand(); } // frame_hop_land
	void OnNpcDeath() { ElfWarriorBase_OnNpcDeath(); } // npc_death
	void OnThrowKnife(string target = "") { ElfWarriorBase_OnThrowKnife(target); } // throw_knife
	void OnThrowKnife2() { ElfWarriorBase_OnThrowKnife2(); } // throw_knife2
	void OnThrowKnifeDone() { ElfWarriorBase_OnThrowKnifeDone(); } // throw_knife_done
	void OnDoKick() { ElfWarriorBase_OnDoKick(); } // do_kick
	void OnLeapAway(string target = "") { ElfWarriorBase_OnLeapAway(target); } // leap_away
	void OnLeapAwayBoost() { ElfWarriorBase_OnLeapAwayBoost(); } // leap_away_boost
	void OnForceLeapEnd() { ElfWarriorBase_OnForceLeapEnd(); } // force_leap_end
	void OnRepulseArea() { ElfWarriorBase_OnRepulseArea(); } // repulse_area
	void OnRepulseTargets() { ElfWarriorBase_OnRepulseTargets(); } // repulse_targets
	void OnDoHop(float verticalDifference = 0.0f) { ElfWarriorBase_OnDoHop(verticalDifference); } // do_hop
	void OnDoJumpBoost() { ElfWarriorBase_OnDoJumpBoost(); } // do_jump_boost
	void OnDoFreezeAura() { ElfWarriorBase_OnDoFreezeAura(); } // do_freeze_aura
	void OnDoFreezeAura2() { ElfWarriorBase_OnDoFreezeAura2(); } // do_freeze_aura2
	void OnFeezeTargets() { ElfWarriorBase_OnFeezeTargets(); } // feeze_targets
	void OnSoundPain() { ElfWarriorBase_OnSoundPain(); } // sound_pain
	void OnMoveMouth() { ElfWarriorBase_OnMoveMouth(); } // move_mouth
	void OnDoWaura() { ElfWarriorBase_OnDoWaura(); } // do_waura
	void OnDoWauraLoop() { ElfWarriorBase_OnDoWauraLoop(); } // do_waura_loop
	void OnDoWauraAffectTargs() { ElfWarriorBase_OnDoWauraAffectTargs(); } // do_waura_affect_targs
	void OnEndWaura() { ElfWarriorBase_OnEndWaura(); } // end_waura
	void OnDoBlock() { ElfWarriorBase_OnDoBlock(); } // do_block
	void OnDoBlockLoop() { ElfWarriorBase_OnDoBlockLoop(); } // do_block_loop
	void OnEndBlock() { ElfWarriorBase_OnEndBlock(); } // end_block
	void OnExtCon(float controllerIndex = 0.0f, string controllerValue = "") { ElfWarriorBase_OnExtCon(controllerIndex, controllerValue); } // ext_con
	void OnSetEscort() { ElfWarriorBase_OnSetEscort(); } // set_escort
	void OnCloseMouth() { ElfWarriorBase_OnCloseMouth(); } // close_mouth
	void OnExtSayOrc() { ElfWarriorBase_OnExtSayOrc(); } // ext_say_orc
	void OnExtSayOrc2() { ElfWarriorBase_OnExtSayOrc2(); } // ext_say_orc2
	void OnBlockDuration() {} // BLOCK_DURATION
	void OnWauraDuration() {} // WAURA_DURATION
	void OnElfSpawn() {} // elf_spawn

	// This file's events and timers by their .script names
	bool ElfWarriorBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "close_mouth") { OnCloseMouth(); return true; }
		if (name == "combat_move") { OnCombatMove(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_block") { OnDoBlock(); return true; }
		if (name == "do_block_loop") { OnDoBlockLoop(); return true; }
		if (name == "do_freeze_aura") { OnDoFreezeAura(); return true; }
		if (name == "do_freeze_aura2") { OnDoFreezeAura2(); return true; }
		if (name == "do_hop") { OnDoHop(Float(Param(params, 0))); return true; }
		if (name == "do_jump_boost") { OnDoJumpBoost(); return true; }
		if (name == "do_kick") { OnDoKick(); return true; }
		if (name == "do_waura") { OnDoWaura(); return true; }
		if (name == "do_waura_affect_targs") { OnDoWauraAffectTargs(); return true; }
		if (name == "do_waura_loop") { OnDoWauraLoop(); return true; }
		if (name == "end_block") { OnEndBlock(); return true; }
		if (name == "end_waura") { OnEndWaura(); return true; }
		if (name == "ext_con") { OnExtCon(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "ext_say_orc") { OnExtSayOrc(); return true; }
		if (name == "ext_say_orc2") { OnExtSayOrc2(); return true; }
		if (name == "feeze_targets") { OnFeezeTargets(); return true; }
		if (name == "force_leap_end") { OnForceLeapEnd(); return true; }
		if (name == "frame_axe2") { OnFrameAxe2(); return true; }
		if (name == "frame_hop_land") { OnFrameHopLand(); return true; }
		if (name == "frame_jab") { OnFrameJab(); return true; }
		if (name == "frame_jump_land") { OnFrameJumpLand(); return true; }
		if (name == "frame_kick_high") { OnFrameKickHigh(); return true; }
		if (name == "frame_melee_1h") { OnFrameMelee1h(); return true; }
		if (name == "frame_melee_2h") { OnFrameMelee2h(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "heard_cycle_down") { OnHeardCycleDown(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away_boost") { OnLeapAwayBoost(); return true; }
		if (name == "mark_def_anims") { OnMarkDefAnims(); return true; }
		if (name == "melee_attack") { OnMeleeAttack(); return true; }
		if (name == "move_mouth") { OnMoveMouth(); return true; }
		if (name == "move_type") { OnMoveType(Int(Param(params, 0))); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_heard_player") { OnNpcHeardPlayer(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "repulse_area") { OnRepulseArea(); return true; }
		if (name == "repulse_targets") { OnRepulseTargets(); return true; }
		if (name == "resume_movement") { OnResumeMovement(); return true; }
		if (name == "set_escort") { OnSetEscort(); return true; }
		if (name == "sound_pain") { OnSoundPain(); return true; }
		if (name == "suspend_movement") { OnSuspendMovement(Param(params, 0)); return true; }
		if (name == "throw_knife") { OnThrowKnife(Param(params, 0)); return true; }
		if (name == "throw_knife2") { OnThrowKnife2(); return true; }
		if (name == "throw_knife_done") { OnThrowKnifeDone(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/elf_warrior_base"]
shared class ElfWarriorBaseScript : BaseMonsterNewScript, ElfWarriorBase
{
	// Variables declared by included files, with the value they start with in this script
	ElfWarriorBaseScript()
	{
		ANIM_WALK = "walk2";
		ANIM_IDLE = "deep_idle";
		SOUND_DEATH = "npc/elvenfemale/ElfF_Die.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_f_warrior.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElfWarriorBase_FirstThink();
		ElfWarriorBase_FirstThink2();
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
		return ElfWarriorBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
