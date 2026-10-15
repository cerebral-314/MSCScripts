#pragma context server

// Converted from sfor/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "sfor/map_startup"]
class SforMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	SforMapStartup()
	{
		MAP_NAME = "sfor";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void SforMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Dark Forest");
		SetGlobal("G_MAP_DESC", "This forest remains cursed by the power of the fallen Lord Undamael");
		SetGlobal("G_MAP_DIFF", "Levels 10-15 / 75-200hp");
		SetGlobal("G_WARN_HP", 75);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SforMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
