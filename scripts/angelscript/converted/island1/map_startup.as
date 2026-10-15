#pragma context server

// Converted from island1/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "island1/map_startup"]
class Island1MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Island1MapStartup()
	{
		MAP_NAME = "island1";
		MAP_WEATHER = "clear;clear;clear;storm;clear;rain";
	}

	// unnamed block (first think)
	void Island1MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Newbie Island by Orpheus");
		SetGlobal("G_MAP_DESC", "This island is renowned for its excellent hunting");
		SetGlobal("G_MAP_DIFF", "Levels 5-12 / 50-150hp");
		SetGlobal("G_WARN_HP", 50);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Island1MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
