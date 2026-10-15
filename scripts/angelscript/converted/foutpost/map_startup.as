#pragma context server

// Converted from foutpost/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "foutpost/map_startup"]
class FoutpostMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	FoutpostMapStartup()
	{
		MAP_NAME = "foutpost";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void FoutpostMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Forgotten Outpost by Evil Squirrel");
		SetGlobal("G_MAP_DESC", "This outpost holds by a thread against an impending orc invasion");
		SetGlobal("G_MAP_DIFF", "Levels 25-35 / 300-700hp");
		SetGlobal("G_WARN_HP", 300);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FoutpostMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
