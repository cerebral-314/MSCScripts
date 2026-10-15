#pragma context server

// Converted from monsters/skeleton_spartaaa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/cavetroll.as"

[script "monsters/skeleton_spartaaa"]
class SkeletonSpartaaa : CavetrollScript
{
	// Constants
	string NPC_BASE_EXP = "1000";

	// Variables declared by included files, with the value they start with in this script
	SkeletonSpartaaa()
	{
		FORCE_GERIC = true;
		SET_GREEK = true;
	}

	// unnamed block (first think)
	void SkeletonSpartaaa_FirstThink()
	{
		SET_GREEK = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonSpartaaa_FirstThink();
		Cavetroll_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
