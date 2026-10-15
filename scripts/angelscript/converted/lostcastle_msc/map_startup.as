#pragma context server

// Converted from lostcastle_msc/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rain plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "lostcastle_msc/map_startup"]
class LostcastleMscMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	LostcastleMscMapStartup()
	{
		MAP_NAME = "lostcastle_msc";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void LostcastleMscMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Curse of the Bear Gods: Lost Castle by Crow");
		SetGlobal("G_MAP_DESC", "The undead guardians of the Bear Gods dwell in this cursed castle.");
		SetGlobal("G_MAP_DIFF", "Levels 15-25 / 150-400hp");
		SetGlobal("G_WARN_HP", 150);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LostcastleMscMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
