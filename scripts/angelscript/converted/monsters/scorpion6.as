#pragma context server

// Converted from monsters/scorpion6.script by msc_transpiler.
// Thothie - no death anim
// - Hit range was smaller than width
// - added poison% - it's a pretty dynamic model, should make use of it
// Large Scorpian

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Scorpion6
{
	// Constants
	float FREQ_JUMP = 30.0f;
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	int ATTACK_STINGRANGE = 120;
	string DOT_EFFECT = "effects/dot_poison";
	string DOT_EFFECT_STING = "effects/dot_poison";
	string DOT_EFFECT_BURST_TYPE = "stun";
	float DOT_DURATION = 10.0f;
	float DOT_DMG = 50.0f;
	string BURST_SCRIPT = "effects/sfx_stun_burst";
	float DMG_BURST = 200.0f;
	string SOUND_SWING = "zombie/claw_miss1.wav";
	string SOUND_BIGSWING = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle_a";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ANIM_POISON = "attacka";
	string ATTACK_HITCHANCE = "70%";
	string ATTACK_DAMAGE = "200";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	float BASE_MOVESPEED = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	string BURST_TARGS = "BURST_TARGS";
	string MY_OWNER = "MY_OWNER";
	bool AM_SUMMONED = false;

	// unnamed block (first think)
	void Scorpion6_FirstThink()
	{
		ANIM_IDLE = "idle_a";
		ANIM_IDLE = "idle_b";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attackb";
		ANIM_DEATH = "die";
		ANIM_POISON = "attacka";
		ATTACK_RANGE = 165.0f;
		ATTACK_HITRANGE = 180.0f;
		ATTACK_HITCHANCE = "70%";
		ATTACK_DAMAGE = "200";
	}

	// game_precache
	void Scorpion6_OnGamePrecache()
	{
		PrecacheFile("monsters/summon/stun_burst");
	}

	// npc_spawn
	void Scorpion6_OnNpcSpawn(string npc = "")
	{
		OnScorpionSpawn();
	}

	// scorpion_spawn
	void Scorpion6_OnScorpionSpawn()
	{
		SetHealth(5000);
		// ov 360
		SetWidth(196);
		SetHeight(196);
		SetBoundingBox("npcsize");
		SetRace("spider");
		SetName("Dread Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 800.0f;

		CallEventDelayed(FREQ_JUMP, "do_jump");

		SetModel("monsters/scorp6.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");
		SetProp(ENT_ME, "skin", 1);

		// setanim.framerate 0.5
		SetAnimMoveSpeed(0.5f);
		// setvard BASE_FRAMERATE 0.5
		BASE_MOVESPEED = 0.5f;

		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, 10, SOUND_IDLE1);
	}

	// unnamed block (timer)
	// Idling
	void Scorpion6_Timer()
	{
		CallEventDelayed(10.0f, "Scorpion6_Timer");
		SetVolume(10);
		PlayRandomSound(2, 10, SOUND_IDLE1);
	}

	// game_death
	void Scorpion6_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(2, 0, SOUND_IDLE1);

		if (!AM_SUMMONED)
			return;
		CallExternal(MY_OWNER, "scorpion_died");
	}

	// npc_post_spawn
	void Scorpion6_OnNpcPostSpawn()
	{
		NPC_MUST_SEE_TARGET = "0"; // cuz very big
	}

	// strike
	void Scorpion6_OnStrike()
	{
		// Deal damage
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			DoDamage(NPCATK_TARGET, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME);

		if (RandomInt(1, 10) == 1)
		{
			PlaySound(0, 10, SOUND_BIGSWING);
			PlayAnim("critical", ANIM_POISON);
			if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
				ApplyEffect(NPCATK_TARGET, DOT_EFFECT, DOT_DURATION, self, DOT_DMG);
		}
		else
		{
			PlaySound(0, 10, SOUND_SWING);
			if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			{
				float rndLr = Random(-100, 100);
				float rndFb = Random(-350, 100);
				AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(rndLr, rndFb, 10)));
			}
		}
	}

	// poison_strike
	void Scorpion6_OnPoisonStrike()
	{
		DebugPrint("poison_strike " + NameOf(ENT_LASTSEEN) + " " + NameOf(HUNT_LASTTARGET));

		if (RangeTo(NPCATK_TARGET) < ATTACK_STINGRANGE)
			DoDamage(NPCATK_TARGET, "direct", ATTACK_DAMAGE, "90%", ENT_ME);

		PlaySound(0, 10, SOUND_BIGSWING);
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_STINGRANGE))
			return;
		ApplyEffect(NPCATK_TARGET, DOT_EFFECT_STING, DOT_DURATION, self, DOT_DMG);

		if (!(RangeTo(NPCATK_TARGET) < ATTACK_STINGRANGE))
			return;
		float rndLr = Random(-100, 100);
		float rndFb = Random(-300, 400);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(rndLr, rndFb, 10)));
	}

	// npc_struck
	// Hit by someone
	void Scorpion6_OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_STRUCK2, SOUND_STRUCK1);
	}

	// do_jump
	void Scorpion6_OnDoJump()
	{
		int doJump;
		DebugPrint("do_jump " + NameOf(NPCATK_TARGET));
		CallEventDelayed(FREQ_JUMP, "do_jump");
		if (NPCATK_TARGET == "unset")
			return;
		string nBads = FindInBox("enemy", 640);
		if (nBads == "none")
		{
			doJump = RandomInt(0, 1); // less likely to do jump against single target
		}
		else if (GetTokenCount(nBads) > 1)
		{
			doJump = 1; // always jump for multiple targets
		}
		else
		{
			doJump = RandomInt(0, 1);
		}
		if (doJump == 0)
			return;
		DebugPrint("do_jumpb " + nBads);
		PlayAnim("critical", "jump");
		CallEventDelayed(1.0f, "do_jump2");
	}

	// do_jump2
	void Scorpion6_OnDoJump2()
	{
		// createnpc monsters/summon/stun_burst $relpos(0,0,0) $get(ent_me,id) 640 1 200
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 640, DMG_BURST, "100%", 0, "reflective", "blunt");
		Vector3 burstOrg = OriginOf(ENT_ME);
		ClientEvent("new", "all", BURST_SCRIPT, burstOrg, 640, 0);
		BURST_TARGS = FindInSphere("enemy", 640);
		DebugPrint("do_jump2 " + BURST_TARGS);
		if (BURST_TARGS == "none")
			return;
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargets();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// burst_affect_targets
	void Scorpion6_OnBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float newYaw = AnglesTo(myOrg, targOrg);

		DebugPrint("burst_affect_targets " + NameOf(curTarg));

		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));

		if (DOT_EFFECT_BURST_TYPE == "stun")
			ApplyEffect(curTarg, "effects/debuff_stun", 5.0f, self);
		if (DOT_EFFECT_BURST_TYPE == "effect")
			ApplyEffect(curTarg, DOT_EFFECT, DOT_DURATION, self, DOT_DMG);
	}

	// game_dynamically_created
	void Scorpion6_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (!IsAlive(MY_OWNER))
			return;
		MY_OWNER = EntityId(EntityOf(creatorValue1));
		SetRace(RaceOf(MY_OWNER));
		AM_SUMMONED = true;
		CallEventDelayed(0.1f, "summoned_sound");
	}

	// summoned_sound
	void Scorpion6_OnSummonedSound()
	{
		PlaySound(0, 10, "ambience/alien_humongo.wav");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { Scorpion6_OnGamePrecache(); } // game_precache

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Scorpion6_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		Scorpion6_OnNpcPostSpawn();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		Scorpion6_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Scorpion6_OnNpcSpawn(npc);
	}

	void OnScorpionSpawn() { Scorpion6_OnScorpionSpawn(); } // scorpion_spawn
	void OnStrike() { Scorpion6_OnStrike(); } // strike
	void OnPoisonStrike() { Scorpion6_OnPoisonStrike(); } // poison_strike
	void OnNpcStruck(float damage = 0.0f) { Scorpion6_OnNpcStruck(damage); } // npc_struck
	void OnDoJump() { Scorpion6_OnDoJump(); } // do_jump
	void OnDoJump2() { Scorpion6_OnDoJump2(); } // do_jump2
	void OnBurstAffectTargets() { Scorpion6_OnBurstAffectTargets(); } // burst_affect_targets
	void OnSummonedSound() { Scorpion6_OnSummonedSound(); } // summoned_sound
	void OnFreqJump() {} // FREQ_JUMP

	// This file's events and timers by their .script names
	bool Scorpion6_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "do_jump") { OnDoJump(); return true; }
		if (name == "do_jump2") { OnDoJump2(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "poison_strike") { OnPoisonStrike(); return true; }
		if (name == "scorpion_spawn") { OnScorpionSpawn(); return true; }
		if (name == "strike") { OnStrike(); return true; }
		if (name == "summoned_sound") { OnSummonedSound(); return true; }
		if (name == "Scorpion6_Timer") { Scorpion6_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/scorpion6"]
shared class Scorpion6Script : BaseMonsterNewScript, Scorpion6
{
	// Variables every script that includes this file declares
	bool IS_UNHOLY = false;

	// Variables declared by included files, with the value they start with in this script
	Scorpion6Script()
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
		Precache("monsters/scorp6.mdl");
		CallEventDelayed(10.0f, "Scorpion6_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion6_FirstThink();
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
		return Scorpion6_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
