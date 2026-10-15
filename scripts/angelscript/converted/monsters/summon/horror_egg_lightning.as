#pragma context server

// Converted from monsters/summon/horror_egg_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/horror_egg.as"

[script "monsters/summon/horror_egg_lightning"]
class HorrorEggLightning : HorrorEggScript
{
	// Variables declared by included files, with the value they start with in this script
	HorrorEggLightning()
	{
		EGG_SCRIPT = "monsters/horror_lightning";
	}
}
