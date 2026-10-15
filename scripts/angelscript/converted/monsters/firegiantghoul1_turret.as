#pragma context server

// Converted from monsters/firegiantghoul1_turret.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/firegiantghoul1.as"

[script "monsters/firegiantghoul1_turret"]
class Firegiantghoul1Turret : Firegiantghoul1Script
{
	// Variables declared by included files, with the value they start with in this script
	Firegiantghoul1Turret()
	{
		AM_TURRET = true;
		NO_ROAM = true;
	}
}
