#pragma context server

// Converted from monsters/skeleton_poison_bomber.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_poison_random.as"

[script "monsters/skeleton_poison_bomber"]
class SkeletonPoisonBomber : SkeletonPoisonRandomScript
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonPoisonBomber()
	{
		POISON_TYPE = "3";
	}
}
