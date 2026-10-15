#pragma context server

// Converted from traps/circle_of_death3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/traps/circle_of_death1.as"

[script "traps/circle_of_death3"]
class CircleOfDeath3 : CircleOfDeath1Script
{
	// Variables declared by included files, with the value they start with in this script
	CircleOfDeath3()
	{
		CIRCLE_RAD = 180.0f;
		CL_BODY = 5;
		CL_RAD = 200;
	}
}
