#pragma context server

// Converted from daragoth/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "daragoth/map_startup"]
class DaragothMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	DaragothMapStartup()
	{
		MAP_NAME = "daragoth";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void DaragothMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Plains of Daragoth");
		SetGlobal("G_MAP_DESC", "These expansive plains are contested by orcish hordes.");
		SetGlobal("G_MAP_DIFF", "Levels 15-20 / 150-250hp");
		SetGlobal("G_WARN_HP", 100);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DaragothMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
