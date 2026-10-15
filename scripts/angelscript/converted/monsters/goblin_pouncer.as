#pragma context server

// Converted from monsters/goblin_pouncer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/goblin_pouncer_sa.as"

[script "monsters/goblin_pouncer"]
class GoblinPouncer : GoblinPouncerSaScript
{
	// Variables declared by included files, with the value they start with in this script
	GoblinPouncer()
	{
		GOBLIN_SELF_ADJUST = false;
	}
}
