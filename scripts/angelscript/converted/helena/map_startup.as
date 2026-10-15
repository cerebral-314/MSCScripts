#pragma context server

// Converted from helena/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "helena/map_startup"]
class HelenaMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	HelenaMapStartup()
	{
		MAP_NAME = "helena";
		MAP_WEATHER = "clear;clear;clear;rain;rain;rain";
	}

	// unnamed block (first think)
	void HelenaMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Town of Helena");
		SetGlobal("G_MAP_DESC", "This provincial village is in constant danger of attack.");
		SetGlobal("G_MAP_DIFF", "Levels 10-15 / 100-250hp");
		SetGlobal("G_WARN_HP", 100);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HelenaMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
