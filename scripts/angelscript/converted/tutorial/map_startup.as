#pragma context server

// Converted from tutorial/map_startup.script by msc_transpiler.
// No weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "tutorial/map_startup"]
class TutorialMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	TutorialMapStartup()
	{
		MAP_NAME = "tutorial";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void TutorialMapStartup_FirstThink()
	{
		SetGlobal("global.map.allownight", 0);

		SetGlobal("G_NO_STEP_ADJ", 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TutorialMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
