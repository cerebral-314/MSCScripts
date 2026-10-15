#pragma context server

// Converted from cleicert/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "cleicert/map_startup"]
class CleicertMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	CleicertMapStartup()
	{
		MAP_NAME = "cleicert";
		MAP_WEATHER = "clear";
	}

	// unnamed block (first think)
	void CleicertMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "The cleicert Temple by Dridje");
		SetGlobal("G_MAP_DESC", "This elemental temple imprisons a great evil.");
		SetGlobal("G_MAP_DIFF", "Levels 25-35 / 400-700hp");
		SetGlobal("G_WARN_HP", 400);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		CleicertMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
