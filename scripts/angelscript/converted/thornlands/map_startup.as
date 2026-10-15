#pragma context server

// Converted from thornlands/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "thornlands/map_startup"]
class ThornlandsMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	ThornlandsMapStartup()
	{
		MAP_NAME = "thornlands";
		MAP_WEATHER = "clear;clear;clear;storm;clear;rain";
	}

	// unnamed block (first think)
	void ThornlandsMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Thornlands");
		SetGlobal("G_MAP_DESC", "These untamed plains and mesas form crossroads to many lands");
		SetGlobal("G_MAP_DIFF", "Levels 5-10 / 35-150hp");
		SetGlobal("G_WARN_HP", 35);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ThornlandsMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
