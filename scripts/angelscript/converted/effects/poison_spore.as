#pragma context server

// Converted from effects/poison_spore.script by msc_transpiler.
// Thothie - minor syntax problems generating errors, fixed
// POISON
// Any npc
// PARAM1 == Duration
// PARAM2 == Damge Source (entity)
// PARAM3 == Damage per second
// PARAM4 == Skill to pass xp to

#include "runtime/ScriptEntity.as"
#include "converted/effects/dot_poison.as"

[script "effects/poison_spore"]
class PoisonSpore : DotPoisonScript
{
	// Variables declared by included files, with the value they start with in this script
	PoisonSpore()
	{
		DOT_IM_AFFECTED = "You have been overcome by noxious spores!";
		DOT_IM_RESIST = "You resist the worst of the spores.";
	}
}
