#pragma context server

// Converted from monsters/skeleton2.script by msc_transpiler.
// Walking Ashes

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersSkeleton2
{
	// Constants
	int SKEL_HP = 70;
	string ATTACK_HITCHANCE = "70%";
	float ATTACK_DAMAGE_LOW = 0.9f;
	float ATTACK_DAMAGE_HIGH = 2.7f;
	string SKEL_RESPAWN_CHANCE = "80%";
	int SKEL_RESPAWN_LIVES = 3;

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// unnamed block (first think)
	void MonstersSkeleton2_FirstThink()
	{
		NPC_GIVE_EXP = 26.0f;

		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 3;
		DROP_GOLD_MAX = 7;
	}

	// skeleton_spawn
	void MonstersSkeleton2_OnSkeletonSpawn()
	{
		SetName("Walking Ashes");
		SetRoam(true);
		SetHearingSensitivity(3);
		SetModelBody(1, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnSkeletonSpawn() { MonstersSkeleton2_OnSkeletonSpawn(); } // skeleton_spawn

	// This file's events and timers by their .script names
	bool MonstersSkeleton2_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton2"]
shared class MonstersSkeleton2Script : SkeletonBaseScript, MonstersSkeleton2
{
	// Variables declared by included files, with the value they start with in this script
	MonstersSkeleton2Script()
	{
		SKEL_HP = 70;
		ATTACK_HITCHANCE = "70%";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersSkeleton2_FirstThink();
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
		return MonstersSkeleton2_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
