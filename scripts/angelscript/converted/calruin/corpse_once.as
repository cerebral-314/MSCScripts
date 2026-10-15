#pragma context server

// Converted from calruin/corpse_once.script by msc_transpiler.
// Weakest Undead Guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class CorpseOnce
{
	// Constants
	int SKEL_HP = 100;
	string ATTACK_HITCHANCE = "70%";
	float ATTACK_DAMAGE_LOW = 4.0f;
	float ATTACK_DAMAGE_HIGH = 5.0f;

	// Variables (an unset .script variable reads as its own name)
	float NPC_GIVE_EXP = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// unnamed block (first think)
	void CorpseOnce_FirstThink()
	{
		NPC_GIVE_EXP = 35.0f;

		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 2;
		DROP_GOLD_MAX = 9;
	}

	// skeleton_spawn
	void CorpseOnce_OnSkeletonSpawn()
	{
		SetName("Awakened Guardian");
		SetRoam(true);
		SetHearingSensitivity(3);
		SetModelBody(1, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnSkeletonSpawn() { CorpseOnce_OnSkeletonSpawn(); } // skeleton_spawn

	// This file's events and timers by their .script names
	bool CorpseOnce_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/corpse_once"]
shared class CorpseOnceScript : SkeletonBaseScript, CorpseOnce
{
	// Variables declared by included files, with the value they start with in this script
	CorpseOnceScript()
	{
		SKEL_HP = 100;
		ATTACK_HITCHANCE = "70%";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		CorpseOnce_FirstThink();
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
		return CorpseOnce_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
