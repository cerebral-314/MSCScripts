#pragma context server

// Converted from monsters/skeleton_geric.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/cavetroll.as"

[script "monsters/skeleton_geric"]
class SkeletonGeric : CavetrollScript
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonGeric()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		FORCE_GERIC = true;
	}

	// unnamed block (first think)
	void SkeletonGeric_FirstThink()
	{
		// testing
		NPC_IS_BOSS = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonGeric_FirstThink();
		Cavetroll_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
