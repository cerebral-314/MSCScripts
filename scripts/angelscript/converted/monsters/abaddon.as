#pragma context server

// Converted from monsters/abaddon.script by msc_transpiler.
// Thothie - for compatibility
// - No idea what this was supposed to be, tis the lightning slime now

#include "runtime/ScriptEntity.as"
#include "converted/monsters/lslime.as"

[script "monsters/abaddon"]
class Abaddon : LslimeScript
{
	// Variables declared by included files, with the value they start with in this script
	Abaddon()
	{
		SOUND_DEATH = "none"; // from monsters/base_npc
	}
}
