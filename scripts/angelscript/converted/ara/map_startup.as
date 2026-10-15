#pragma context server

// Converted from ara/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ara/map_startup"]
class AraMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	AraMapStartup()
	{
		MAP_NAME = "ara";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void AraMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Occupied Ara by J");
		SetGlobal("G_MAP_DESC", "The port town of Ara has fallen to an army of Orcs!");
		SetGlobal("G_MAP_DIFF", "Levels 25-30 / 400-600hp");
		SetGlobal("G_WARN_HP", 400);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AraMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
