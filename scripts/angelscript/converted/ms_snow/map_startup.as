#pragma context server

// Converted from ms_snow/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ms_snow/map_startup"]
class MsSnowMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	MsSnowMapStartup()
	{
		MAP_NAME = "ms_snow";
		MAP_WEATHER = "snow;snow;snow";
	}

	// unnamed block (first think)
	void MsSnowMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Frozen Summit by Avoozl & P.Barnum");
		SetGlobal("G_MAP_DESC", "Great evil lies in the frozen North. Its cold tendrils have sapped this once rich land.");
		SetGlobal("G_MAP_DIFF", "Levels 25-35 / 400-700hp");
		SetGlobal("G_WARN_HP", 400);

		SetGlobal("G_NO_STEP_ADJ", 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MsSnowMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
