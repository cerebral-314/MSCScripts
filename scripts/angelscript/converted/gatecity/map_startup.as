#pragma context server

// Converted from gatecity/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "gatecity/map_startup"]
class GatecityMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	GatecityMapStartup()
	{
		MAP_NAME = "gatecity";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void GatecityMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Gatecity");
		SetGlobal("G_MAP_DESC", "This Dwarven capital is carved deep inside the mountains.");
		SetGlobal("G_MAP_DIFF", "Levels 10-25 / 100-400hp");
		SetGlobal("G_WARN_HP", 100);

		SetGlobal("G_NO_STEP_ADJ", 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GatecityMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
