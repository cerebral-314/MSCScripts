#pragma context server

// Converted from mines/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "mines/map_startup"]
class MinesMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	MinesMapStartup()
	{
		MAP_NAME = "mines";
		MAP_WEATHER = "clear;clear;clear;clear;rain;rain";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void MinesMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Abandoned Mines");
		SetGlobal("G_MAP_DESC", "These mines were abandoned when they were infested by evil creatures");
		SetGlobal("G_MAP_DIFF", "Levels 10-20 / 150-300hp");
		SetGlobal("G_WARN_HP", 150);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MinesMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
