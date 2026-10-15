#pragma context server

// Converted from mscave/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "mscave/map_startup"]
class MscaveMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	MscaveMapStartup()
	{
		MAP_NAME = "mscave";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void MscaveMapStartup_FirstThink()
	{
		SetGlobal("global.map.allownight", 0);

		SetGlobal("G_MAP_NAME", "The Dark Caves");
		SetGlobal("G_MAP_DESC", "These caves are infested with orcs, although there are rumors that they hide yet a greater evil.");
		SetGlobal("G_MAP_DIFF", "Levels 5-20 / 50-300hp");
		SetGlobal("G_WARN_HP", 50);
		SetGlobal("G_NO_STEP_ADJ", 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MscaveMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
