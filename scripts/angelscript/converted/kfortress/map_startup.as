#pragma context server

// Converted from kfortress/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "kfortress/map_startup"]
class KfortressMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	KfortressMapStartup()
	{
		MAP_NAME = "kfortress";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void KfortressMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Kharaztorant Fortress");
		SetGlobal("G_MAP_DESC", "You've found what is rumored to be a fortress of the dragon worshipper's cult");
		SetGlobal("G_MAP_DIFF", "Levels 30-40 / 600-800hp");
		SetGlobal("G_WARN_HP", 600);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KfortressMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
