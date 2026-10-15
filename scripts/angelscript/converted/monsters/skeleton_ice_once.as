#pragma context server

// Converted from monsters/skeleton_ice_once.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_ice.as"

[script "monsters/skeleton_ice_once"]
class SkeletonIceOnce : SkeletonIceScript
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonIceOnce()
	{
		SKEL_RESPAWN_CHANCE = "0%";
		SKEL_RESPAWN_LIVES = 0;
	}
}
