#pragma context server

// Converted from lodagond-2/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "lodagond-2/map_startup"]
class Lodagond2MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Lodagond2MapStartup()
	{
		MAP_NAME = "lodagond-2";
		MAP_WEATHER = "clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void Lodagond2MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Lodagond Skyfortress Part II");
		SetGlobal("G_MAP_DESC", "Deeper into the fortress you go...");
		SetGlobal("G_MAP_DIFF", "Levels 35-40 / 700+hp");
		SetGlobal("G_WARN_HP", 700);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Lodagond2MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
