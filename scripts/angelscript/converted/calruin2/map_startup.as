#pragma context server

// Converted from calruin2/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "calruin2/map_startup"]
class Calruin2MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Calruin2MapStartup()
	{
		MAP_NAME = "calruin2";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void Calruin2MapStartup_FirstThink()
	{
		SetGlobal("global.map.allownight", 0);

		SetGlobal("G_MAP_NAME", "The Calrian Ruins");
		SetGlobal("G_MAP_DESC", "This ruined temple is host to a great evil.");
		SetGlobal("G_MAP_DIFF", "Levels 20-30 / HP 200-500");
		SetGlobal("G_WARN_HP", 200);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Calruin2MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
