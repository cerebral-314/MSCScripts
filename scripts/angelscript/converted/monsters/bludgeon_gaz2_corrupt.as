#pragma context server

// Converted from monsters/bludgeon_gaz2_corrupt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bludgeon_gaz_base.as"

[script "monsters/bludgeon_gaz2_corrupt"]
class BludgeonGaz2Corrupt : BludgeonGazBaseScript
{
	// Constants
	bool AM_CORRUPT = true;

	// Variables declared by included files, with the value they start with in this script
	BludgeonGaz2Corrupt()
	{
		AM_HAMMER = true;
	}
}
