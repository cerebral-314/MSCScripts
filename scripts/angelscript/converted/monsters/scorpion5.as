#pragma context server

// Converted from monsters/scorpion5.script by msc_transpiler.
// Thothie - no death anim
// - Hit range was smaller than width
// - added poison% - it's a pretty dynamic model, should make use of it
// Large Scorpian

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Scorpion5
{
	// Constants
	bool DELETE_ON_DEATH = true;
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	string SOUND_SWING = "zombie/claw_miss1.wav";
	string SOUND_BIGSWING = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle_a";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ANIM_POISON = "attacka";
	string ATTACK_HITCHANCE = "60%";
	string ATTACK_DAMAGE = "30";
	int FLEE_HEALTH = 0;
	string FLEE_CHANCE = "100%";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string CAN_FLEE = "CAN_FLEE";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	float NPC_GIVE_EXP = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	string MY_OWNER = "MY_OWNER";
	bool AM_SUMMONED = false;

	// unnamed block (first think)
	void Scorpion5_FirstThink()
	{
		ANIM_IDLE = "idle_a";
		ANIM_IDLE = "idle_b";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attackb";
		ANIM_DEATH = "die";
		ANIM_POISON = "attacka";
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_HITCHANCE = "60%";
		ATTACK_DAMAGE = "30";
		CAN_FLEE = "0"; // Used by base_monster
		FLEE_HEALTH = 0; // Used by base_monster
		FLEE_CHANCE = "100%"; // Used by base_monster
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		NPC_MOVE_TARGET = "enemy";
	}

	// npc_spawn
	void Scorpion5_OnNpcSpawn(string npc = "")
	{
		OnScorpionSpawn();
	}

	// scorpion_spawn
	void Scorpion5_OnScorpionSpawn()
	{
		SetHealth(1000);
		// ov 360
		SetWidth(40);
		SetHeight(50);
		SetRace("spider");
		SetName("Gigantic Venomous Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 200.0f;

		SetModel("monsters/scorp5.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");

		SetAnimFrameRate(0.5f);
		SetAnimMoveSpeed(0.25f);
		BASE_FRAMERATE = "0.5";
		BASE_MOVESPEED = 0.25f;

		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, 10, SOUND_IDLE1);
	}

	// unnamed block (timer)
	// Idling
	void Scorpion5_Timer()
	{
		CallEventDelayed(10.0f, "Scorpion5_Timer");
		SetVolume(10);
		PlayRandomSound(2, 10, SOUND_IDLE1);
	}

	// game_death
	void Scorpion5_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 0, SOUND_IDLE1);

		if (!AM_SUMMONED)
			return;
		CallExternal(MY_OWNER, "scorpion_died");
	}

	// strike
	void Scorpion5_OnStrike()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);

		if (RandomInt(1, 10) == 1)
		{
			PlaySound(0, 10, SOUND_BIGSWING);
			PlayAnim("critical", ANIM_POISON);
			if (RangeTo(HUNT_LASTTARGET) < ATTACK_RANGE)
				ApplyEffect(HUNT_LASTTARGET, "effects/dot_poison", 10, self, Random(12, 20));
		}
		else
		{
			PlaySound(0, 10, SOUND_SWING);
			if (RangeTo(HUNT_LASTTARGET) < ATTACK_RANGE)
			{
				float rndLr = Random(-100, 100);
				float rndFb = Random(-200, 200);
				AddVelocity(HUNT_LASTTARGET, RelativeVelocity(Vector3(rndLr, rndFb, 10)));
			}
		}
	}

	// npc_struck
	// Hit by someone
	void Scorpion5_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1);
	}

	// game_dynamically_created
	void Scorpion5_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = EntityId(EntityOf(creatorValue1));
		SetRace(RaceOf(MY_OWNER));
		AM_SUMMONED = true;
		CallEventDelayed(0.1f, "summoned_sound");
	}

	// summoned_sound
	void Scorpion5_OnSummonedSound()
	{
		PlaySound(0, 10, "ambience/alien_humongo.wav");
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
		Scorpion5_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		Scorpion5_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Scorpion5_OnNpcSpawn(npc);
	}

	void OnScorpionSpawn() { Scorpion5_OnScorpionSpawn(); } // scorpion_spawn
	void OnStrike() { Scorpion5_OnStrike(); } // strike
	void OnNpcStruck(float damage = 0.0f) { Scorpion5_OnNpcStruck(damage); } // npc_struck
	void OnSummonedSound() { Scorpion5_OnSummonedSound(); } // summoned_sound

	// This file's events and timers by their .script names
	bool Scorpion5_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "scorpion_spawn") { OnScorpionSpawn(); return true; }
		if (name == "strike") { OnStrike(); return true; }
		if (name == "summoned_sound") { OnSummonedSound(); return true; }
		if (name == "Scorpion5_Timer") { Scorpion5_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/scorpion5"]
shared class Scorpion5Script : BaseMonsterScript, Scorpion5
{
	// Variables every script that includes this file declares
	bool IS_UNHOLY = false;

	// Variables declared by included files, with the value they start with in this script
	Scorpion5Script()
	{
		ANIM_IDLE = "idle_a";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/scorp5.mdl");
		CallEventDelayed(10.0f, "Scorpion5_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion5_FirstThink();
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
		return Scorpion5_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
