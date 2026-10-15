#pragma context server

// Converted from monsters/dragonfly.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result
// Thothie - Bugger can't attack, adding attack_hack
// - Bugger... The bugger STILL can't attack... Switching to bat script + attack_hack
// - Attacks now, but has a habit of ignoring monster clips
// Dragonfly

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/attack_hack.as"
#include "converted/monsters/base_flyer.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersDragonfly
{
	// Constants
	bool NPC_NO_END_FLY = true;
	bool DELETE_ON_DEATH = true;
	string ATTACK_HITCHANCE = "30%";
	int ATTACK_FREQUENCY = 10;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/sludge/null.wav";
	string SOUND_ATTACK1 = "monsters/sludge/null.wav";
	string SOUND_ATTACK2 = "monsters/sludge/null.wav";
	string SOUND_ATTACK3 = "monsters/sludge/null.wav";
	string SOUND_IDLE = "monsters/sludge/null.wav";
	string SOUND_DEATH = "monsters/sludge/null.wav";
	int FLEE_HEALTH = 5;
	string FLEE_CHANCE = "50%";
	string SOUND_HOVER = "monsters/dragonfly.wav";
	float FREQ_SOUND_HOVER = 5.9f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE_HANG = "flapping";
	string ANIM_IDLE_FLY = "fly";
	string ANIM_RUN = "fly";
	string ANIM_WALK = "fly";
	string ANIM_IDLE = "flapping";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_FLEE = "CAN_FLEE";
	float NPC_GIVE_EXP = 0.0f;
	float FLIGHT_STUCK = 0.0f;
	float AS_ATTACKING = 0.0f;
	float LAST_PROG = 0.0f;
	Vector3 LAST_POS = Vector3();

	// unnamed block (first think)
	void MonstersDragonfly_FirstThink()
	{
		ANIM_IDLE_HANG = "flapping";
		ANIM_IDLE_FLY = "fly";
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_ATTACK = "attack";
		ANIM_IDLE = "flapping";
		ATTACK_DAMAGE = "2";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 80.0f;

		HUNT_AGRO = "1";
		CAN_HUNT = "1";
		CAN_FLEE = "1"; // Used by base_npc_attack
	}

	// npc_spawn
	void MonstersDragonfly_OnNpcSpawn(string npc = "")
	{
		SetName("Giant dragonfly");
		SetFly(true);
		SetRace("vermin");
		SetHealth(20);
		// ov 270
		SetWidth(24);
		SetHeight(24);
		SetHearingSensitivity(2);
		SetVolume(5);
		SetRoam(true);
		SetDamageTaken("pierce", 0.5f);
		SetMonsterClip(false);
		NPC_GIVE_EXP = 10.0f;

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetModel("monsters/dragonfly.mdl");
	}

	// unnamed block (timer)
	void MonstersDragonfly_Timer()
	{
		CallEventDelayed(10.0f, "MonstersDragonfly_Timer");

		if (IS_HUNTING)
			return;
		if (RandomInt(0, 1) == 0)
			return;

		PlayAnim("once", ANIM_IDLE);
	}

	// bite1
	// Deal damage
	void MonstersDragonfly_OnBite1()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_struck
	// Hit by someone
	void MonstersDragonfly_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN);
	}

	// unnamed block (timer)
	// custom flyer mods
	void MonstersDragonfly_Timer2()
	{
		CallEventDelayed(0.5f, "MonstersDragonfly_Timer2");
		if (!IS_HUNTING)
			return;
		OnNpcatkFaceattacker();
		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE)
			SetVelocity(ENT_ME, Vector3(0, 0, 0));

		if (FLIGHT_STUCK > 4.0f)
		{
			// callevent chicken_run 1.0
			OnDoRandTweedee(); // do_rand_tweedee
			OnNpcatkSuspendAi(Text(Random(0.3f, 0.9f)));
			SetMoveDest(NEW_DEST, Eval("game.monster.moveprox"));
			CallEventDelayed(0.1f, "horror_boost");
			FLIGHT_STUCK = 0.0f;
		}

		AS_ATTACKING -= 2.0f;

		Vector3 targPos = OriginOf(NPCATK_TARGET);
		if (!SUSPEND_AI)
			SetAngle("face_origin", targPos);

		if (!(AS_ATTACKING <= 0.0f))
			return;
		AS_ATTACKING = 0.0f;
		if (IS_FLEEING)
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
	void MonstersDragonfly_OnChickenRun(float duration = 0.0f)
	{
		CallEventDelayed(0.1f, "horror_boost");
	}

	// horror_boost
	void MonstersDragonfly_OnHorrorBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 0)));
	}

	// unnamed block (timer)
	void MonstersDragonfly_Timer3()
	{
		CallEventDelayed(FREQ_SOUND_HOVER, "MonstersDragonfly_Timer3");

		PlaySound(2, 10, SOUND_HOVER);
	}

	// game_death
	void MonstersDragonfly_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// drop to the f*cking ground
		// local GROUND_Z $get_ground_height(game.monster.origin)
		// local MY_POS game.monster.origin
		// vectorset MY_POS z GROUND_Z
		// setorigin ent_me MY_POS
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -200)));
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
		MonstersDragonfly_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyer_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		BaseFlyer_OnNpcatkTargetvalidate(target); // monsters/base_flyer
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttack_OnChickenRun(duration); // monsters/base_npc_attack
		MonstersDragonfly_OnChickenRun(duration);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersDragonfly_OnNpcSpawn(npc);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BaseFlyer_OnNpcSelectattack(); // monsters/base_flyer
	}

	void OnNpcatkAttackenemy() { AttackHack_OnNpcatkAttackenemy(); } // npcatk_attackenemy
	void OnBite1() { MonstersDragonfly_OnBite1(); } // bite1
	void OnNpcStruck(float damage = 0.0f) { MonstersDragonfly_OnNpcStruck(damage); } // npc_struck
	void OnHorrorBoost() { MonstersDragonfly_OnHorrorBoost(); } // horror_boost

	// This file's events and timers by their .script names
	bool MonstersDragonfly_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "horror_boost") { OnHorrorBoost(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "MonstersDragonfly_Timer") { MonstersDragonfly_Timer(); return true; }
		if (name == "MonstersDragonfly_Timer2") { MonstersDragonfly_Timer2(); return true; }
		if (name == "MonstersDragonfly_Timer3") { MonstersDragonfly_Timer3(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/dragonfly"]
shared class MonstersDragonflyScript : BaseMonsterScript, MonstersDragonfly, AttackHack, BaseFlyer
{
	// Variables every script that includes this file declares
	string FIRST_TARGET = "FIRST_TARGET";
	string MY_DURATION = "MY_DURATION";
	string MY_OWNER = "MY_OWNER";
	string SUMMON_HP = "SUMMON_HP";

	// Variables declared by included files, with the value they start with in this script
	MonstersDragonflyScript()
	{
		ANIM_RUN = "fly";
		ANIM_WALK = "fly";
		ANIM_IDLE = "flapping";
		SOUND_DEATH = "monsters/sludge/null.wav";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/dragonfly.mdl");
		CallEventDelayed(10.0f, "MonstersDragonfly_Timer");
		CallEventDelayed(0.5f, "MonstersDragonfly_Timer2");
		CallEventDelayed(FREQ_SOUND_HOVER, "MonstersDragonfly_Timer3");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersDragonfly_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MonstersDragonfly_DispatchEvent(name, params)
			|| AttackHack_DispatchEvent(name, params)
			|| BaseFlyer_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
