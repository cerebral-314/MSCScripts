#pragma context server

// Converted from challs/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "challs/map_startup"]
class ChallsMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	ChallsMapStartup()
	{
		MAP_NAME = "challs";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void ChallsMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Halls of Charthane"); // Carthain
		SetGlobal("G_MAP_DESC", "Once a hall of heroes, now a den of evi.l");
		SetGlobal("G_MAP_DIFF", "Levels 15-25 / 200-450hp");
		SetGlobal("G_WARN_HP", 200);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ChallsMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
