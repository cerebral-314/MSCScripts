#pragma context server

// Converted from msc_tutorial/map_startup.script by msc_transpiler.
// No weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "msc_tutorial/map_startup"]
class MscTutorialMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	MscTutorialMapStartup()
	{
		MAP_NAME = "tutorial";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void MscTutorialMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Tutorial map by Dridje");
		SetGlobal("G_MAP_DESC", "A quick tutorial map for new MSC players.");
		SetGlobal("G_MAP_DIFF", "(Easy)");
		SetGlobal("G_WARN_HP", 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MscTutorialMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
