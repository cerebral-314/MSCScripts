#pragma context server

// Converted from nightmare_thornlands/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "nightmare_thornlands/map_startup"]
class NightmareThornlandsMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	NightmareThornlandsMapStartup()
	{
		MAP_NAME = "nightmare_thornlands";
		MAP_WEATHER = "clear;clear;clear;snow;clear;snow";
	}

	// unnamed block (first think)
	void NightmareThornlandsMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Nightmare Thornlands");
		SetGlobal("G_MAP_DESC", "This is the realm of Thornlands as it will be if Lor Malgorand is not stopped.");
		SetGlobal("G_MAP_DIFF", "Levels 30-35 / 400-700hp");
		SetGlobal("G_WARN_HP", 400);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NightmareThornlandsMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
