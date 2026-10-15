#pragma context server

// Converted from ms_soccer/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ms_soccer/map_startup"]
class MsSoccerMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	MsSoccerMapStartup()
	{
		MAP_NAME = "ms_soccer";
		MAP_WEATHER = "clear;clear;clear";
	}

	// unnamed block (first think)
	void MsSoccerMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "MSC Soccer by Caluminium");
		SetGlobal("G_MAP_DESC", "MSC Science - We do what we must because we can.");
		SetGlobal("G_MAP_DIFF", "(Safe Area - Relatively Speaking)");
		SetGlobal("G_WARN_HP", 0);

		SetGlobal("G_SPECIAL_COMMANDS", 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MsSoccerMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
