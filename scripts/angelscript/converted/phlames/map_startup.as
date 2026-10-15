#pragma context server

// Converted from phlames/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "phlames/map_startup"]
class PhlamesMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	PhlamesMapStartup()
	{
		MAP_NAME = "phlames";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void PhlamesMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Phlames Fortress by Caluminium");
		SetGlobal("G_MAP_DESC", "The occupants of this Fortress make great use of the fire influence within.");
		SetGlobal("G_MAP_DIFF", "Levels 35-45 / HP 800+");
		SetGlobal("G_WARN_HP", 800);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed2.spr");
		Precache("fire1_fixed.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PhlamesMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
