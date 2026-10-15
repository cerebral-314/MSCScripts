#pragma context server

// Converted from edanasewers_old/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "edanasewers_old/map_startup"]
class EdanasewersOldMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	EdanasewersOldMapStartup()
	{
		MAP_NAME = "edanasewers_old";
		MAP_WEATHER = "fog_green;fog_green;fog_green;fog_green;fog_red;fog_red";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void EdanasewersOldMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Sewers of Edana");
		SetGlobal("G_MAP_DESC", "These sewers predate the town above by hundreds of years and are now the haunted remnants of a once great city");
		SetGlobal("G_MAP_DIFF", "Levels 5-10 / 50-100hp");
		SetGlobal("G_WARN_HP", 0); // Map is too low level to consider warning
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EdanasewersOldMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
