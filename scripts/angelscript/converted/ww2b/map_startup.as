#pragma context server

// Converted from ww2b/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ww2b/map_startup"]
class Ww2bMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Ww2bMapStartup()
	{
		MAP_NAME = "ww2b";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void Ww2bMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "World Walker - Series One, Part II by Crow");
		SetGlobal("G_MAP_DESC", "The upper catacombs of an ancient tomb.");
		SetGlobal("G_MAP_DIFF", "Levels 15-25 / 200-500hp");
		SetGlobal("G_WARN_HP", 200);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Ww2bMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
