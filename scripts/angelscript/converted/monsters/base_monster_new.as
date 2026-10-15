#pragma context server

// Converted from monsters/base_monster_new.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack_new.as"
#include "converted/monsters/base_monster_shared.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMonsterNew
{

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
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
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
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseNpcAttackNew_OnNpcatkGetPostspawnProperties(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkGetPostspawnProperties(); // monsters/base_monster_shared
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
	}

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		BaseNpcAttackNew_OnGameReachedDest(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameReachedDest(); // monsters/base_monster_shared
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkResumeAi(target); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
	}

	void OnBmGoldSpew(int goldPerBag = 0, string bagsPerPlayer = "", int distance = 0, int minBags = 0, int maxBags = 0) { BaseMonsterShared_OnBmGoldSpew(goldPerBag, bagsPerPlayer, distance, minBags, maxBags); } // bm_gold_spew
	void OnAdjStepSize() { BaseMonsterShared_OnAdjStepSize(); } // adj_step_size
	void OnNpcatkRun() { BaseMonsterShared_OnNpcatkRun(); } // npcatk_run
	void OnNpcatkWalk() { BaseMonsterShared_OnNpcatkWalk(); } // npcatk_walk
	void OnNpcatkAlertAllAllies(string attacker = "") { BaseMonsterShared_OnNpcatkAlertAllAllies(attacker); } // npcatk_alert_all_allies
	void OnNpcatkHandlePostevents() { BaseMonsterShared_OnNpcatkHandlePostevents(); } // npcatk_handle_postevents
	void OnNpcTargetsighted(string target = "") { BaseMonsterShared_OnNpcTargetsighted(target); } // npc_targetsighted
	void OnNpcTargetvalidate(CBaseEntity@ target = null) { BaseMonsterShared_OnNpcTargetvalidate(target); } // npc_targetvalidate
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_monster_new"]
shared class BaseMonsterNewScript : BaseNpcAttackNewScript, BaseMonsterNew, BaseMonsterShared, BaseAntiStuck
{
	// Variables declared by included files, with the value they start with in this script
	BaseMonsterNewScript()
	{
		NPC_BOSS_REGEN_RATE = 0.1f; // from monsters/base_monster_shared
		NPC_BOSS_REGEN_FREQ = 60.0f; // from monsters/base_monster_shared
		NPC_BOSS_RESTORATION = 0.5f; // from monsters/base_monster_shared
		NPC_CANT_PARRY_TYPES = "target;magic"; // from monsters/base_monster_shared
		DEF_STEP_SIZE = 32; // from monsters/base_monster_shared
		PARRY_TYPE = "parried!"; // from monsters/base_monster_shared
		AS_MAX_ATTACK_TIME = 3.0f; // from monsters/base_anti_stuck
		AS_STUCK_FREQ = 0.25f; // from monsters/base_anti_stuck
		AS_WIGGLE_DURATION = 2.0f; // from monsters/base_anti_stuck
		AS_TELE_THRESH = 10; // from monsters/base_anti_stuck
		AS_CRITICAL_THRESH = 40; // from monsters/base_anti_stuck
		AS_DIST_THRESH = 1; // from monsters/base_anti_stuck
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNpcSuicide(string suicideMode = "") { MonstersExternals_OnNpcSuicide(suicideMode); } // npc_suicide
	void OnExtWinkOut(Vector3 spawnPosition = Vector3(), float delay = 0.0f) { MonstersExternals_OnExtWinkOut(spawnPosition, delay); } // ext_wink_out
	void OnNpcatkTarget2(string target = "", string debug = "") { BaseNpcAttackNew_OnNpcatkTarget2(target, debug); } // npcatk_target
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") { BaseNpcAttackNew_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); } // npcatk_flee
	void OnChickenRun(float duration = 0.0f) { BaseNpcAttackNew_OnChickenRun(duration); } // chicken_run
	void OnCycleUp(string reason = "") { BaseNpcAttackNew_OnCycleUp(reason); } // cycle_up

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
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
		return BaseMonsterShared_DispatchEvent(name, params)
			|| BaseAntiStuck_DispatchEvent(name, params)
			|| BaseNpcAttackNewScript::DispatchEvent(name, params);
	}
}
