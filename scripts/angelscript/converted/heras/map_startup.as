#pragma context server

// Converted from heras/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "heras/map_startup"]
class HerasMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	HerasMapStartup()
	{
		MAP_NAME = "heras";
		MAP_WEATHER = "clear;clear;rain;rain;rain;rain";
	}

	// unnamed block (first think)
	void HerasMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Temple of Heras");
		SetGlobal("G_MAP_DESC", "This fallen temple of Urdual is now host to a variety of evils.");
		SetGlobal("G_MAP_DIFF", "Levels 10-15 / 100-250hp");
		SetGlobal("G_WARN_HP", 100);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HerasMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
