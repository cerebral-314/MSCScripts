#pragma context server

// Converted from goblintown/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "goblintown/map_startup"]
class GoblintownMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	GoblintownMapStartup()
	{
		MAP_NAME = "goblintown";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void GoblintownMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Goblin Town");
		SetGlobal("G_MAP_DESC", "The goblins have an extensive encampment here");
		SetGlobal("G_MAP_DIFF", "Levels 10-25 / 100-400hp");
		SetGlobal("G_WARN_HP", 100);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GoblintownMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
