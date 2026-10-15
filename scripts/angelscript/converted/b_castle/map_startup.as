#pragma context server

// Converted from b_castle/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "b_castle/map_startup"]
class BCastleMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	BCastleMapStartup()
	{
		MAP_NAME = "b_castle";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void BCastleMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Castle by P.Barnum");
		SetGlobal("G_MAP_DESC", "The warriors of this cursed castle are animated by an ancient magic.");
		SetGlobal("G_MAP_DIFF", "Levels 25-35 / 450-700hp");
		SetGlobal("G_WARN_HP", 450);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BCastleMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
