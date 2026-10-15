#pragma context server

// Converted from monsters/skeleton_golden_guard.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/cavetroll.as"

[script "monsters/skeleton_golden_guard"]
class SkeletonGoldenGuard : CavetrollScript
{
	// Constants
	string NPC_BASE_EXP = "1000";

	// Variables declared by included files, with the value they start with in this script
	SkeletonGoldenGuard()
	{
		FORCE_GERIC = true;
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
		SetModelBody(0, 11);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return CavetrollScript::DispatchEvent(name, params);
	}
}
