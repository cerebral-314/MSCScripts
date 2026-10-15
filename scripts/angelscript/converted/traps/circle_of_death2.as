#pragma context server

// Converted from traps/circle_of_death2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/traps/circle_of_death1.as"

[script "traps/circle_of_death2"]
class CircleOfDeath2 : CircleOfDeath1Script
{
	// Variables declared by included files, with the value they start with in this script
	CircleOfDeath2()
	{
		CIRCLE_RAD = 140.0f;
		CL_BODY = 4;
		CL_RAD = 156;
	}
}
