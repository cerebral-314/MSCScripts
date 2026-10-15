#pragma context server

// Converted from keledrosruins/map_startup.script by msc_transpiler.
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "keledrosruins/map_startup"]
class KeledrosruinsMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	KeledrosruinsMapStartup()
	{
		MAP_NAME = "keledrosruins";
		MAP_WEATHER = "clear;snow;clear;storm;rain;rain";
	}

	// unnamed block (first think)
	void KeledrosruinsMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Keledros Palace");
		SetGlobal("G_MAP_DESC", "The insane wizard Keledros has made his home here. Woe to those who find it.");
		SetGlobal("G_MAP_DIFF", "Levels 20-25 / 250-400hp");
		SetGlobal("G_WARN_HP", 250);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeledrosruinsMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
