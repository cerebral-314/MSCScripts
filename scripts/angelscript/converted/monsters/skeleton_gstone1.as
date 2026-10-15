#pragma context server

// Converted from monsters/skeleton_gstone1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonGstone1
{
	// Constants
	string SKEL_MODEL = "monsters/skeleton_boss2.mdl";
	int SKEL_WIDTH = 40;
	int SKEL_HEIGHT = 130;
	int SKEL_MOVE_RANGE = 64;
	int SKEL_ATTACK_RANGE = 150;
	int SKEL_ATTACK_HITRANGE = 220;
	int SKEL_HP = 4000;
	string ATTACK_HITCHANCE = "85%";
	float ATTACK_DAMAGE_LOW = 26.0f;
	float ATTACK_DAMAGE_HIGH = 60.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	string SOUND_STRUCK1 = "weapons/axemetal1.wav";
	string SOUND_STRUCK2 = "weapons/axemetal2.wav";
	string SOUND_STRUCK3 = "debris/concrete1.wav";
	string SOUND_RUN1 = "monsters/troll/step1.wav";
	string SOUND_RUN2 = "monsters/troll/step2.wav";
	string SOUND_WALK1 = "common/npc_step1.wav";
	string SOUND_WALK2 = "common/npc_step2.wav";
	float WALK_MOVESPEED = 1.0f;
	string SOUND_STUN = "zombie/claw_strike2.wav";
	string SOUND_SUMMON = "monsters/skeleton/calrain3.wav";
	string ROCK_DAMAGE = "$rand(400,800)";
	int STUN_ATK_CHANCE = 10;
	bool STONE_SKELETON = true;
	float ROCK_FREQ = 30.0f;
	bool CUSTOM_SIZE = true;
	string XSOUND_LEVITATE = "fans/fan4on.wav";
	string XSOUND_SPIN = "magic/fan4_noloop.wav";
	string XSOUND_SUMMON = "magic/volcano_start.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "run";
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float BASE_MOVESPEED = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	bool WAS_SLEEPING = false;
	bool STUN_ATTACK = false;
	string PUSH_VEL = "PUSH_VEL";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool ROCK_DELAY = false;
	bool ROCK_ON = false;
	float AS_ATTACKING = 0.0f;
	CBaseEntity@ MY_ROCK_STORM = null;
	bool G_SUMMING_ROCKS = false;

	// unnamed block (first think)
	void SkeletonGstone1_FirstThink()
	{
		ANIM_RUN = "run";
		NPC_GIVE_EXP = 1000.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 100;
		DROP_GOLD_MAX = 200;

		BASE_MOVESPEED = 2.0f;

		CAN_FLINCH = "0";
	}

	// skeleton_spawn
	void SkeletonGstone1_OnSkeletonSpawn()
	{
		SetModelBody(0, 7); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=icelord 9=bloodlord
		SetModelBody(1, 3); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		if (!SLEEPER)
			OnAnimateStone();
		if (SLEEPER)
		{
			SetInvincible(true);
			WAS_SLEEPING = true;
			OnNpcatkSuspendAi();
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_IDLE);
			SetAnimFrameRate(0);
		}
	}

	// animate_stone
	void SkeletonGstone1_OnAnimateStone()
	{
		SetName("Greater Stone Mason");
		SetRoam(true);

		SetBlood("none");

		SetDamageTaken("all", 0.6f);

		SetHearingSensitivity(3);

		if (WAS_SLEEPING)
		{
			SetMoveAnim(ANIM_WALK);
			SetAnimFrameRate(1);
			OnNpcatkResumeAi();
		}
	}

	// attack_1
	void SkeletonGstone1_OnAttack12()
	{
		STUN_ATTACK = false;

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 100, 10)));

		if (!(RandomInt(1, 100) < STUN_ATK_CHANCE))
			return;
		ANIM_ATTACK = "attack2";
	}

	// npc_targetsighted
	void SkeletonGstone1_OnNpcTargetsighted(string target = "")
	{
		if (IS_FLEEING)
			return;

		if (!ROCK_ON)
			return;
		if (ROCK_DELAY)
			return;
		CallEventDelayed(0.1f, "summon_rock");
	}

	// rock_delay_reset
	void SkeletonGstone1_OnRockDelayReset()
	{
		ROCK_DELAY = false;
	}

	// attack_2
	void SkeletonGstone1_OnAttack22()
	{
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));

		STUN_ATTACK = true;
		OnAttackSnd();
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);
		ANIM_ATTACK = "attack1";
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string SkeletonGstone1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit

		if (!STUN_ATTACK)
			return result;
		PlaySound(0, 10, SOUND_STUN);
		ApplyEffect(target, "effects/debuff_stun", Random(5, 10), self);
		STUN_ATTACK = false;
		return result;
	}

	// cycle_up
	void SkeletonGstone1_OnCycleUp(string reason = "")
	{
		ROCK_ON = true;
	}

	// summon_rock
	void SkeletonGstone1_OnSummonRock(Vector3 location = Vector3())
	{
		if (G_SUMMING_ROCKS && !ROCK_DELAY)
		{
			// someone else is summoning rocks, try again later
			CallEventDelayed(Random(10, 20), "summon_rock");
			ROCK_DELAY = true;
		}

		if (G_SUMMING_ROCKS)
			return;
		SetGlobal("G_SUMMING_ROCKS", 1); // tell other stone masons that it's MY turn to summon (crash prevention)
		CallEventDelayed(5.0f, "reset_summoning"); // tell others I'm done in 5 seconds
		ROCK_DELAY = true;
		CallEventDelayed(ROCK_FREQ, "rock_delay_reset");

		PlaySound(0, 10, SOUND_SUMMON);

		PlayAnim("break");
		AS_ATTACKING = GameTime(); // tells anti-stuck he's attacking
		OnNpcatkSuspendAi();
		PlayAnim("critical", "castspell");
		int numRocks = 4;
		if (PlayerCount() >= 1)
		{
			numRocks = PlayerCount();
			if (numRocks > 4)
			{
				int numRucks = 4;
			}
		}
		// dbg temp making NUM_ROCKS rocks for game.players
		numRocks = 4; // temporary
		if (Exists(MY_ROCK_STORM))
			return;
		CreateNpc("monsters/summon/rock_storm", RelativePosition(Vector3(0, 0, 0)), self, numRocks, ROCK_DAMAGE, 64, 200); // <Owner> <#Rocks> <Dmg> <FX_Radius> <Letivtate_Height>
		@MY_ROCK_STORM = EntityOf(ENT_LASTCREATED);
	}

	// reset_summoning
	void SkeletonGstone1_OnResetSummoning()
	{
		G_SUMMING_ROCKS = false;
		if (!SUSPEND_AI)
			return;
		OnNpcatkResumeAi();
	}

	// castspell
	// all called from model
	// castspell (sometimes doesn't get this far) :\
	void SkeletonGstone1_OnCastspell()
	{
		SetGlobal("G_SUMMING_ROCKS", 0);
		if (!SUSPEND_AI)
			return;
		OnNpcatkResumeAi();
	}

	// walk_step1
	// walk
	void SkeletonGstone1_OnWalkStep1()
	{
		// movespeed WALK_MOVESPEED
		PlaySound(0, 8, SOUND_WALK1);
	}

	// walk_step2
	// walk
	void SkeletonGstone1_OnWalkStep2()
	{
		// movespeed WALK_MOVESPEED
		PlaySound(0, 8, SOUND_WALK2);
	}

	// run_step1
	// run
	void SkeletonGstone1_OnRunStep1()
	{
		SetMoveSpeed(BASE_MOVESPEED);
		PlaySound(0, 8, SOUND_RUN1);
	}

	// run_step2
	// run
	void SkeletonGstone1_OnRunStep2()
	{
		SetMoveSpeed(BASE_MOVESPEED);
		PlaySound(0, 8, SOUND_RUN2);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		SkeletonGstone1_OnCycleUp(reason);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonGstone1_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SkeletonGstone1_OnNpcTargetsighted(target);
	}

	// attack_1
	void OnAttack12()
	{
		SkeletonBase_OnAttack12(); // monsters/skeleton_base
		SkeletonGstone1_OnAttack12();
	}

	void OnSkeletonSpawn() { SkeletonGstone1_OnSkeletonSpawn(); } // skeleton_spawn
	void OnAnimateStone() { SkeletonGstone1_OnAnimateStone(); } // animate_stone
	void OnRockDelayReset() { SkeletonGstone1_OnRockDelayReset(); } // rock_delay_reset
	void OnAttack22() { SkeletonGstone1_OnAttack22(); } // attack_2
	void OnSummonRock(Vector3 location = Vector3()) { SkeletonGstone1_OnSummonRock(location); } // summon_rock
	void OnResetSummoning() { SkeletonGstone1_OnResetSummoning(); } // reset_summoning
	void OnCastspell() { SkeletonGstone1_OnCastspell(); } // castspell
	void OnWalkStep1() { SkeletonGstone1_OnWalkStep1(); } // walk_step1
	void OnWalkStep2() { SkeletonGstone1_OnWalkStep2(); } // walk_step2
	void OnRunStep1() { SkeletonGstone1_OnRunStep1(); } // run_step1
	void OnRunStep2() { SkeletonGstone1_OnRunStep2(); } // run_step2
	void OnRockFreq() {} // ROCK_FREQ
	void OnAttackSnd() {} // attack_snd

	// This file's events and timers by their .script names
	bool SkeletonGstone1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "animate_stone") { OnAnimateStone(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "castspell") { OnCastspell(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "reset_summoning") { OnResetSummoning(); return true; }
		if (name == "rock_delay_reset") { OnRockDelayReset(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		if (name == "summon_rock") { OnSummonRock(Vec(Param(params, 0))); return true; }
		if (name == "walk_step1") { OnWalkStep1(); return true; }
		if (name == "walk_step2") { OnWalkStep2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_gstone1"]
shared class SkeletonGstone1Script : SkeletonBaseScript, SkeletonGstone1
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonGstone1Script()
	{
		SKEL_MODEL = "monsters/skeleton_boss2.mdl";
		SKEL_WIDTH = 40;
		SKEL_HEIGHT = 130;
		SKEL_MOVE_RANGE = 64;
		SKEL_ATTACK_RANGE = 150;
		SKEL_ATTACK_HITRANGE = 220;
		ANIM_RUN = "run";
		SKEL_HP = 4000;
		ATTACK_HITCHANCE = "85%";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss2.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonGstone1_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		return SkeletonGstone1_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
