#pragma context server

// Converted from monsters/firegiantghoul3_turret.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/firegiantghoul3.as"

[script "monsters/firegiantghoul3_turret"]
class Firegiantghoul3Turret : Firegiantghoul3Script
{
	// Variables declared by included files, with the value they start with in this script
	Firegiantghoul3Turret()
	{
		AM_TURRET = true;
		NO_ROAM = true;
	}
}
