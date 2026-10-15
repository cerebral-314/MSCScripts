#pragma context server

// Converted from ww3d/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ww3d/map_startup"]
class Ww3dMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Ww3dMapStartup()
	{
		MAP_NAME = "ww3d";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void Ww3dMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "World Walker - Series One, Finale by Crow");
		SetGlobal("G_MAP_DESC", "The lower catacombs and the tomb Sir Geric.");
		SetGlobal("G_MAP_DIFF", "Levels 15-30 / 200-600hp");
		SetGlobal("G_WARN_HP", 200);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Ww3dMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
