#pragma context server

// Converted from monsters/firegiantghoul2_turret.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/firegiantghoul.as"

[script "monsters/firegiantghoul2_turret"]
class Firegiantghoul2Turret : FiregiantghoulScript
{
	// Variables declared by included files, with the value they start with in this script
	Firegiantghoul2Turret()
	{
		AM_TURRET = true;
		NO_ROAM = true;
	}
}
