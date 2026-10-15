#pragma context server

// Converted from lodagond-1/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "lodagond-1/map_startup"]
class Lodagond1MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Lodagond1MapStartup()
	{
		MAP_NAME = "lodagond-1";
		MAP_WEATHER = "clear;clear;clear;snow;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void Lodagond1MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Lodagond Skyfortress Part I");
		SetGlobal("G_MAP_DESC", "You managed to access Maldora's floating fortress... but can you survive?");
		SetGlobal("G_MAP_DIFF", "Levels 35-40 / 700+hp");
		SetGlobal("G_WARN_HP", 700);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Lodagond1MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
