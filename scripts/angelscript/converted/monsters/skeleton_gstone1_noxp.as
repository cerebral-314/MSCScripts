#pragma context server

// Converted from monsters/skeleton_gstone1_noxp.script by msc_transpiler.
// No reward "trap" variant for Foamy

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_gstone1.as"

[script "monsters/skeleton_gstone1_noxp"]
class SkeletonGstone1Noxp : SkeletonGstone1Script
{
	// unnamed block (first think)
	void SkeletonGstone1Noxp_FirstThink()
	{
		NPC_GIVE_EXP = 0.0f;
		DROP_GOLD = 0;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonGstone1Noxp_FirstThink();
		SkeletonGstone1_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
