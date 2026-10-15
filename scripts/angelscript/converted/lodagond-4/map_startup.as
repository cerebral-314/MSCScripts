#pragma context server

// Converted from lodagond-4/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "lodagond-4/map_startup"]
class Lodagond4MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Lodagond4MapStartup()
	{
		MAP_NAME = "lodagond-4";
		MAP_WEATHER = "clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void Lodagond4MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Lodagond Skyfortress Part IV");
		SetGlobal("G_MAP_DESC", "Onto the final battle...");
		SetGlobal("G_MAP_DIFF", "Levels 35-40 / 700+hp");
		SetGlobal("G_WARN_HP", 700);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Lodagond4MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
