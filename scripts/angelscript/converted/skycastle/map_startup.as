#pragma context server

// Converted from skycastle/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "skycastle/map_startup"]
class SkycastleMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	SkycastleMapStartup()
	{
		MAP_NAME = "skycastle";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void SkycastleMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Curse of the Bear Gods: Sky Castle by Crow");
		SetGlobal("G_MAP_DESC", "The once hollowed home of the fallen Bear Gods.");
		SetGlobal("G_MAP_DIFF", "Levels 20-35 / 300-500hp");
		SetGlobal("G_WARN_HP", 300);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkycastleMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
