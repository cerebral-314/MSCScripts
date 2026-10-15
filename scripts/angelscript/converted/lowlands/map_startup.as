#pragma context server

// Converted from lowlands/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "lowlands/map_startup"]
class LowlandsMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	LowlandsMapStartup()
	{
		MAP_NAME = "lowlands";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void LowlandsMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Curse of the Bear Gods: Lowlands by Crow & Dridje");
		SetGlobal("G_MAP_DESC", "Foglund has been cursed by the Bear Gods. Can you save him?");
		SetGlobal("G_MAP_DIFF", "Levels 15-20 / 200-300hp");
		SetGlobal("G_WARN_HP", 200);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LowlandsMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
