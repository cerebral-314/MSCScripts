#pragma context server

// Converted from monsters/slime_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/lslime.as"

[script "monsters/slime_lightning"]
class SlimeLightning : LslimeScript
{
	// Variables declared by included files, with the value they start with in this script
	SlimeLightning()
	{
		SOUND_DEATH = "none"; // from monsters/base_npc
	}
}
