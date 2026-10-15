#pragma context server

// Converted from monsters/summon/preset_volcano.script by msc_transpiler.
// as volcano, but dmg is fixed

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/summon_volcano.as"

[script "monsters/summon/preset_volcano"]
class PresetVolcano : SummonVolcanoScript
{
	// Variables declared by included files, with the value they start with in this script
	PresetVolcano()
	{
		VOLCANO_EXT_EVENT = "ext_volcano_hit";
		AOE_DMG = 25.0f;
		FIXED_VOLCANO = true;
	}
}
