#pragma context server

// Converted from shender_east/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "shender_east/map_startup"]
class ShenderEastMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	ShenderEastMapStartup()
	{
		MAP_NAME = "shender_east";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void ShenderEastMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "East Shender");
		SetGlobal("G_MAP_DESC", "A frozen wasteland that borders The Wall.");
		SetGlobal("G_MAP_DIFF", "Levels 25-40 / 500-1250hp");
		SetGlobal("G_WARN_HP", 500);

		SetGlobal("G_MORC_CHESTS", 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShenderEastMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
