#pragma context server

// Converted from deraliasewers/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "deraliasewers/map_startup"]
class DeraliasewersMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	DeraliasewersMapStartup()
	{
		MAP_NAME = "deraliasewers";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void DeraliasewersMapStartup_FirstThink()
	{
		// setvarg G_MAP_NAME //set via the map
		// setvarg G_MAP_DESC
		SetGlobal("G_MAP_DIFF", "Levels 35-40 / 700+hp");
		SetGlobal("G_WARN_HP", 700);

		SetGlobal("G_TRACK_HP", 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliasewersMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
