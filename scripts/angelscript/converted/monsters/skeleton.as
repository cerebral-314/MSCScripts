#pragma context server

// Converted from monsters/skeleton.script by msc_transpiler.
// Skeleton Warrior

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/skeleton"]
class MonstersSkeleton : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 0.9f;
	float ATTACK_DAMAGE_HIGH = 2.7f;
	string SKEL_RESPAWN_CHANCE = "75%";
	int SKEL_RESPAWN_LIVES = 3;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// Variables declared by included files, with the value they start with in this script
	MonstersSkeleton()
	{
		SKEL_HP = 40;
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void MonstersSkeleton_FirstThink()
	{
		NPC_GIVE_EXP = 16.0f;

		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 1;
		DROP_GOLD_MAX = 3;
	}

	// game_spawn
	void MonstersSkeleton_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		string mapName = MapName();
		if (mapName != "thornlands")
			return;
		// dbg set to sleep due to thornlands
		SLEEPER = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		MonstersSkeleton_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Skeleton Warrior");
		SetRoam(true);
		SetHearingSensitivity(3);
		SetModelBody(1, 0);
		SetBlood("none");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSkeleton_FirstThink();
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
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
