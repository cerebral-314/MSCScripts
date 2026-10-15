#pragma context server

// Converted from the_keep/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "the_keep/map_startup"]
class TheKeepMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	TheKeepMapStartup()
	{
		MAP_NAME = "the_keep";
		MAP_WEATHER = "clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void TheKeepMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Keep");
		SetGlobal("G_MAP_DESC", "The stronghold has been taken over by hearty adventurers that now terrorize the countryside as bandits.");
		SetGlobal("G_MAP_DIFF", "Levels 25-30 / HP 400-600");
		SetGlobal("G_WARN_HP", 400);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TheKeepMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
