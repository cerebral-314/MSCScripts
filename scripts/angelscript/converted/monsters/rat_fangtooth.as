#pragma context server

// Converted from monsters/rat_fangtooth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/fangtooth.as"

[script "monsters/rat_fangtooth"]
class RatFangtooth : CalruinFangtoothScript
{
	// Variables declared by included files, with the value they start with in this script
	RatFangtooth()
	{
		SOUND_DEATH = "none"; // from monsters/base_npc
	}
}
