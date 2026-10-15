#pragma context server

// Converted from ms_wicardoven/map_startup.script by msc_transpiler.
// Map settings

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "ms_wicardoven/map_startup"]
class MsWicardovenMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	MsWicardovenMapStartup()
	{
		MAP_NAME = "ms_wicardoven";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
		MAP_ALLOWNIGHT = false;
	}

	// unnamed block (first think)
	void MsWicardovenMapStartup_FirstThink()
	{
		SetGlobal("G_MAP_NAME", "Wicard Oven");
		SetGlobal("G_MAP_DESC", "This ancient orc stronghold has recently seen its masters return.");
		SetGlobal("G_MAP_DIFF", "Levels 20-30 / HP 300-600");
		SetGlobal("G_WARN_HP", 300);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MsWicardovenMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}
}
