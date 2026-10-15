#pragma context server

// Converted from monsters/skeleton_poison_sworder.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_poison_random.as"

[script "monsters/skeleton_poison_sworder"]
class SkeletonPoisonSworder : SkeletonPoisonRandomScript
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonPoisonSworder()
	{
		POISON_TYPE = "4";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SkeletonBase_OnNpcSpawn(npc); // monsters/skeleton_base
		SetRoam(false);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SkeletonPoisonRandomScript::DispatchEvent(name, params);
	}
}
