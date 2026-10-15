#pragma context server

// Converted from other/monster_lure.script by msc_transpiler.
// Thothie - experiment to make monsters attack a scripted object
// - not working :\

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "other/monster_lure"]
class MonsterLure : BaseMonsterScript
{
	// game_spawn
	void MonsterLure_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetRoam(false);
		SetName("Structure");
		SetRace("human");
		SetBlood("none");
		SetSkillLevel(0);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		MonsterLure_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		UseTrigger("tower_fall");
		CallEventDelayed(0.1f, "remove_me");
		Effect("tempent", "gibs", "woodgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1, 5, 15, 20, 5);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity("me");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("woodgibs.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
