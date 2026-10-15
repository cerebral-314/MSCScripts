#pragma context server

// Converted from deralia/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "deralia/map_startup"]
class DeraliaMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	DeraliaMapStartup()
	{
		MAP_NAME = "deralia";
		MAP_WEATHER = "clear;clear;clear;clear;clear;fog_blue";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void DeraliaMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The City of Deralia");
		SetGlobal("G_MAP_DESC", "The Human capital is known as the Jewel of Daragoth.");
		SetGlobal("G_MAP_DIFF", "(Beginner/Safe Area)");
		SetGlobal("G_WARN_HP", 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliaMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
