#pragma context server

// Converted from nashalrath/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "nashalrath/map_startup"]
class NashalrathMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	NashalrathMapStartup()
	{
		MAP_NAME = "nashalrath";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void NashalrathMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Temple of Nashalrath");
		SetGlobal("G_MAP_DESC", "An ancient labrynth once belonging to The Lost.");
		SetGlobal("G_MAP_DIFF", "Levels 30-40 / 500-800hp");
		SetGlobal("G_WARN_HP", 500);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NashalrathMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
