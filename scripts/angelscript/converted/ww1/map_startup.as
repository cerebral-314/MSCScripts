#pragma context server

// Converted from ww1/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ww1/map_startup"]
class Ww1MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Ww1MapStartup()
	{
		MAP_NAME = "ww1";
		MAP_WEATHER = "clear;clear;rain;clear;clear;rain";
	}

	// unnamed block (first think)
	void Ww1MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "World Walker - Series One, Part I by Crow");
		SetGlobal("G_MAP_DESC", "The First of three gauntlet maps: Entrance to the tomb of Sir Geric");
		SetGlobal("G_MAP_DIFF", "Levels 15-25 / 200-500hp");
		SetGlobal("G_WARN_HP", 200);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Ww1MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
