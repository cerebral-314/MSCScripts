#pragma context server

// Converted from edana/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "edana/map_startup"]
class EdanaMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	EdanaMapStartup()
	{
		MAP_NAME = "edana";
		MAP_WEATHER = "clear;clear;clear;clear;rain;clear";
	}

	// unnamed block (first think)
	void EdanaMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Village of Edana");
		SetGlobal("G_MAP_DESC", "This village grew around the temple of Urdual of the southern frontier.");
		SetGlobal("G_MAP_DIFF", "(Beginner/Safe Area)");
		SetGlobal("G_WARN_HP", 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EdanaMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
