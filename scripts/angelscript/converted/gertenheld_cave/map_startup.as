#pragma context server

// Converted from gertenheld_cave/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "gertenheld_cave/map_startup"]
class GertenheldCaveMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	GertenheldCaveMapStartup()
	{
		MAP_NAME = "gertenheld_cave";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void GertenheldCaveMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Vile Blood Goblin Caves");
		SetGlobal("G_MAP_DESC", "These caves are infested with the most tenacious goblins in all of daragoth");
		SetGlobal("G_MAP_DIFF", "Levels 35-40 / 500-800hp");
		SetGlobal("G_WARN_HP", 500);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GertenheldCaveMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
