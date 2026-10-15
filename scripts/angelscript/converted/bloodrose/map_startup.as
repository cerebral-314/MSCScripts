#pragma context server

// Converted from bloodrose/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "bloodrose/map_startup"]
class BloodroseMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	BloodroseMapStartup()
	{
		MAP_NAME = "bloodrose";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void BloodroseMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Bloodrose Valley");
		SetGlobal("G_MAP_DESC", "This rose shaped valley nexus connects the northern and southern lands.");
		SetGlobal("G_MAP_DIFF", "Levels 15-40 / 150-700hp");
		SetGlobal("G_WARN_HP", 150);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BloodroseMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
