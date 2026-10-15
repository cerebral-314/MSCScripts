#pragma context server

// Converted from the_wall2/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "the_wall2/map_startup"]
class TheWall2MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	TheWall2MapStartup()
	{
		MAP_NAME = "the_wall2";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void TheWall2MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Wall by Skillasaur");
		SetGlobal("G_MAP_DESC", "Abandoned by the elves, this fortress is now a bastion for the undead.");
		SetGlobal("G_MAP_DIFF", "Levels 40+ / 700+hp");
		SetGlobal("G_WARN_HP", 700);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TheWall2MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
