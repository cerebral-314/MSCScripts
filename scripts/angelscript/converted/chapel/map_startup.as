#pragma context server

// Converted from chapel/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "chapel/map_startup"]
class ChapelMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	ChapelMapStartup()
	{
		MAP_NAME = "chapel";
		MAP_WEATHER = "clear;clear;clear;storm;clear;rain";
	}

	// unnamed block (first think)
	void ChapelMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Chapel by CSS");
		SetGlobal("G_MAP_DESC", "Winding wildlands conceal a fallen temple.");
		SetGlobal("G_MAP_DIFF", "Levels 5-15 / 35-200hp");
		SetGlobal("G_WARN_HP", 0); // enemies are not powerful enough to warrant a warning
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ChapelMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
