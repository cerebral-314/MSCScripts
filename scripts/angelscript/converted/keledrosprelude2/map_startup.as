#pragma context server

// Converted from keledrosprelude2/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "keledrosprelude2/map_startup"]
class Keledrosprelude2MapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	Keledrosprelude2MapStartup()
	{
		MAP_NAME = "keledrosprelude";
		MAP_WEATHER = "clear;clear;clear;clear;rain;rain";
	}

	// unnamed block (first think)
	void Keledrosprelude2MapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "A Dangerous Pass");
		SetGlobal("G_MAP_DESC", "Bandits raid travelers along this pass so frequently that only the bravest of tradesmen still use it.");
		SetGlobal("G_MAP_DIFF", "Levels 15-25 / 150-400hp");
		SetGlobal("G_WARN_HP", 150);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Keledrosprelude2MapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
