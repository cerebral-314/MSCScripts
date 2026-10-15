#pragma context server

// Converted from monsters/base_monster.script by msc_transpiler.
// Standard monster that attacks and drops items when killed

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"
#include "converted/monsters/base_monster_shared.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMonster
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
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseNpcAttack_OnNpcatkGetPostspawnProperties(); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkGetPostspawnProperties(); // monsters/base_monster_shared
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		BaseNpcAttack_OnGameReachedDest(); // monsters/base_npc_attack
		BaseMonsterShared_OnGameReachedDest(); // monsters/base_monster_shared
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttack_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttack_OnNpcatkClearTargets(reason); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttack_OnNpcatkResumeAi(target); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
	}

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttack_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttack_OnCycleDown(); // monsters/base_npc_attack
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
	}

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseNpcAttack_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
	}

	void OnNpcatkHunt() { BaseAntiStuck_OnNpcatkHunt(); } // npcatk_hunt

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
	}

	void OnBmGoldSpew(int goldPerBag = 0, string bagsPerPlayer = "", int distance = 0, int minBags = 0, int maxBags = 0) { BaseMonsterShared_OnBmGoldSpew(goldPerBag, bagsPerPlayer, distance, minBags, maxBags); } // bm_gold_spew
	void OnAdjStepSize() { BaseMonsterShared_OnAdjStepSize(); } // adj_step_size
	void OnNpcatkAlertAllAllies(string attacker = "") { BaseMonsterShared_OnNpcatkAlertAllAllies(attacker); } // npcatk_alert_all_allies
	void OnNpcatkHandlePostevents() { BaseMonsterShared_OnNpcatkHandlePostevents(); } // npcatk_handle_postevents
	void OnNpcTargetsighted(string target = "") { BaseMonsterShared_OnNpcTargetsighted(target); } // npc_targetsighted
	void OnNpcTargetvalidate(CBaseEntity@ target = null) { BaseMonsterShared_OnNpcTargetvalidate(target); } // npc_targetvalidate
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_monster"]
shared class BaseMonsterScript : BaseNpcAttackScript, BaseMonster, BaseMonsterShared, BaseAntiStuck
{
	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNpcSuicide(string suicideMode = "") { MonstersExternals_OnNpcSuicide(suicideMode); } // npc_suicide
	void OnExtWinkOut(Vector3 spawnPosition = Vector3(), float delay = 0.0f) { MonstersExternals_OnExtWinkOut(spawnPosition, delay); } // ext_wink_out
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") { BaseNpcAttack_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); } // npcatk_flee
	void OnNpcatkTarget2(string target = "", string debug = "") { BaseNpcAttack_OnNpcatkTarget2(target, debug); } // npcatk_target
	void OnChickenRun(float duration = 0.0f) { BaseNpcAttack_OnChickenRun(duration); } // chicken_run
	void OnCycleUp(string reason = "") { BaseNpcAttack_OnCycleUp(reason); } // cycle_up

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
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
		return BaseMonsterShared_DispatchEvent(name, params)
			|| BaseAntiStuck_DispatchEvent(name, params)
			|| BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
