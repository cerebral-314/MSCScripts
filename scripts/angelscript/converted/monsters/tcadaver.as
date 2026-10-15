#pragma context server

// Converted from monsters/tcadaver.script by msc_transpiler.
// Cadaver

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/tcadaver"]
class Tcadaver : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 14.0f;
	float ATTACK_DAMAGE_HIGH = 17.0f;
	string SKEL_RESPAWN_CHANCE = "75%";
	int SKEL_RESPAWN_LIVES = 3;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// Variables declared by included files, with the value they start with in this script
	Tcadaver()
	{
		SKEL_HP = 100;
		ATTACK_HITCHANCE = "70%";
	}

	// unnamed block (first think)
	void Tcadaver_FirstThink()
	{
		NPC_GIVE_EXP = 40.0f;

		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 2;
		DROP_GOLD_MAX = 10;
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetName("Fragile Knight");
		SetRoam(true);
		SetHearingSensitivity(3);
		SetModelBody(1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tcadaver_FirstThink();
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
