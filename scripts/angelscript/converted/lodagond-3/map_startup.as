#pragma context server

// Converted from lodagond-3/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "lodagond-3/map_startup"]
class Lodagond3MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Lodagond3MapStartup()
	{
		MAP_NAME = "lodagond-3";
		MAP_WEATHER = "clear;clear;clear;rain";
	}

	// unnamed block (first think)
	void Lodagond3MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Lodagond Skyfortress Part III");
		SetGlobal("G_MAP_DESC", "The arboretum contains a fortress within a fortress.");
		SetGlobal("G_MAP_DIFF", "Levels 35-40 / 700+hp");
		SetGlobal("G_WARN_HP", 700);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Lodagond3MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
