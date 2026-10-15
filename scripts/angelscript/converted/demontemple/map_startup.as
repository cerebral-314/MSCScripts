#pragma context server

// Converted from demontemple/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "demontemple/map_startup"]
class DemontempleMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	DemontempleMapStartup()
	{
		MAP_NAME = "demontemple";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void DemontempleMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The Demonic Temple by AmIAnnoyingNow");
		SetGlobal("G_MAP_DESC", "You seem to have stumbled on a stronghold of the Kharaztorant cult.");
		SetGlobal("G_MAP_DIFF", "Levels 20-25 / 350-600hp");
		SetGlobal("G_WARN_HP", 350);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DemontempleMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
