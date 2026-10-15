#pragma context server

// Converted from monsters/bludgeon_gaz2_demon_mini.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bludgeon_gaz_base.as"

[script "monsters/bludgeon_gaz2_demon_mini"]
class BludgeonGaz2DemonMini : BludgeonGazBaseScript
{
	// Constants
	bool AM_MINI = true;

	// Variables declared by included files, with the value they start with in this script
	BludgeonGaz2DemonMini()
	{
		AM_DEMON = true;
		AM_HAMMER = true;
		MONSTER_MODEL = "monsters/bludgeon_gaz_mini.mdl";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("monsters/bludgeon_gaz_mini.mdl");
		CallEventDelayed(FREQ_IDLE, "BludgeonGazBase_Timer");
	}
}
