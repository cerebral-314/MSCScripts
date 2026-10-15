#pragma context server

// Converted from tundra/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "tundra/map_startup"]
class TundraMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	TundraMapStartup()
	{
		MAP_NAME = "tundra";
		MAP_WEATHER = "clear;snow;snow;snow;snow;clear";
	}

	// unnamed block (first think)
	void TundraMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_DIFF", "Levels 30-35 / 700-900hp");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TundraMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
