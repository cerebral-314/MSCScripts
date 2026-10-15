#pragma context server

// Converted from monsters/hunger.script by msc_transpiler.
// Hunger, from Walking Ashes

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/hunger"]
class Hunger : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 0.9f;
	float ATTACK_DAMAGE_HIGH = 10.0f;
	string SKEL_RESPAWN_CHANCE = "80%";
	int SKEL_RESPAWN_LIVES = 3;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// Variables declared by included files, with the value they start with in this script
	Hunger()
	{
		SKEL_HP = 70;
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void Hunger_FirstThink()
	{
		NPC_GIVE_EXP = 20.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 3;
		DROP_GOLD_MAX = 7;
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Hungry Skeleton");
		SetMoveSpeed(2);
		SetRoam(true);
		SetHearingSensitivity(3);
		SetBlood("none");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Hunger_FirstThink();
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
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
