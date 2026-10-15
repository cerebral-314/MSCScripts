#pragma context server

// Converted from highlands_msc/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "highlands_msc/map_startup"]
class HighlandsMscMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	HighlandsMscMapStartup()
	{
		MAP_NAME = "highlands_msc";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void HighlandsMscMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Curse of the Bear Gods: Highlands by Crow");
		SetGlobal("G_MAP_DESC", "These tall mesas hold many secrets and many orcs.");
		SetGlobal("G_MAP_DIFF", "Levels 15-25 / 150-400hp");
		SetGlobal("G_WARN_HP", 150);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HighlandsMscMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
