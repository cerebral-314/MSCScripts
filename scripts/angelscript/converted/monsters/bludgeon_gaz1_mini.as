#pragma context server

// Converted from monsters/bludgeon_gaz1_mini.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bludgeon_gaz_base.as"

[script "monsters/bludgeon_gaz1_mini"]
class BludgeonGaz1Mini : BludgeonGazBaseScript
{
	// Constants
	bool AM_MINI = true;

	// Variables declared by included files, with the value they start with in this script
	BludgeonGaz1Mini()
	{
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
