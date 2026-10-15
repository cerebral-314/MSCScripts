#pragma context server

// Converted from monsters/slime_black_small.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SlimeBlackSmall
{
	// Constants
	string SOUND_DEATH = "monsters/sludge/bio.wav";
	string SOUND_STRUCK1 = "barnacle/bcl_bite3.wav";
	string SOUND_STRUCK2 = "barnacle/bcl_die3.wav";
	string SOUND_IDLE = "barnacle/bcl_alert2.wav";
	string SOUND_ATTACK1 = "barnacle/bcl_tongue1.wav";
	string SOUND_ATTACK2 = "barnacle/bcl_chew3.wav";
	string ATTACK_HITCHANCE = "75%";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string NPC_BASE_EXP = "10";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "walk";
	string ANIM_RUN = "run";
	string ANIM_WALK = "walk";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NO_SPAWN_STUCK_CHECK = false;
	float NPC_GIVE_EXP = 0.0f;
	string MOMMY_KILLER = "MOMMY_KILLER";

	// unnamed block (first think)
	void SlimeBlackSmall_FirstThink()
	{
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		MOVE_RANGE = "10";
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 120.0f;

		NPC_MUST_SEE_TARGET = "0";

		NO_SPAWN_STUCK_CHECK = true;
	}

	// npc_spawn
	void SlimeBlackSmall_OnNpcSpawn(string npc = "")
	{
		SetName("Black Pudding");
		SetHealth(20);
		SetWidth(40);
		SetBlood("green");
		SetHeight(64);
		SetModel("monsters/slime.mdl");
		SetModelBody(0, 12);
		SetRace("wildanimal"); // greater version should be demon for ease of placement
		SetRoam(true);
		SetSolid("none");
		SetBoundingBox("trigger");
		NPC_GIVE_EXP = 10.0f;

		SetDamageTaken("poison", 0);
		SetDamageTaken("stun", 0);

		SetHearingSensitivity(8);

		CallEventDelayed(0.5f, "slime_cycle");
	}

	// bite1
	// called from model
	void SlimeBlackSmall_OnBite1()
	{
		OnNpcatkDodamage(HUNT_LASTTARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "acid");
	}

	// game_damaged_other
	string SlimeBlackSmall_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		return result;
	}

	// game_struck
	void SlimeBlackSmall_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
	}

	// game_dynamically_created
	// PARAM1=movedest PARAM2=motherkiller
	void SlimeBlackSmall_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MOMMY_KILLER = creatorValue2;
		OnNpcatkSuspendAi("0.5");
		SetMoveDest(creatorValue1, 1);
		CallEventDelayed(0.75f, "avenge_mommy");
	}

	// avenge_mommy
	void SlimeBlackSmall_OnAvengeMommy()
	{
		OnNpcatkSettarget(MOMMY_KILLER, "he_killed_mommy!");
	}

	// slime_cycle
	void SlimeBlackSmall_OnSlimeCycle()
	{
		// //dbg temp Slimetarget $get(NPCATK_TARGET,name)
		if (NPCATK_TARGET == "unset" && RandomInt(1, 10) == 1)
			PlaySound(0, 10, SOUND_IDLE);

		if (NPCATK_TARGET != "unset" && RangeTo(NPCATK_TARGET) < ATTACK_RANGE && RandomInt(1, 3) == 1)
			OnChickenRun(1.0f);

		CallEventDelayed(2.0f, "slime_cycle");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SlimeBlackSmall_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		SlimeBlackSmall_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SlimeBlackSmall_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SlimeBlackSmall_OnNpcSpawn(npc);
	}

	void OnBite1() { SlimeBlackSmall_OnBite1(); } // bite1
	void OnAvengeMommy() { SlimeBlackSmall_OnAvengeMommy(); } // avenge_mommy
	void OnSlimeCycle() { SlimeBlackSmall_OnSlimeCycle(); } // slime_cycle

	// This file's events and timers by their .script names
	bool SlimeBlackSmall_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "avenge_mommy") { OnAvengeMommy(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "slime_cycle") { OnSlimeCycle(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/slime_black_small"]
shared class SlimeBlackSmallScript : BaseMonsterNewScript, SlimeBlackSmall
{
	// Variables declared by included files, with the value they start with in this script
	SlimeBlackSmallScript()
	{
		SOUND_DEATH = "monsters/sludge/bio.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeBlackSmall_FirstThink();
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
		return SlimeBlackSmall_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
