#pragma context server

// Converted from dridmars_scripts_WIP/foutpost/map_startup.script by msc_transpiler.
// Thothie mscave almost entirely underground - no rail plzktnx
// Setup the map's weather

#include "runtime/ScriptEntity.as"
#include "converted/worlditems/map_startup.as"

[script "dridmars_scripts_WIP/foutpost/map_startup"]
class DridmarsScriptsWipFoutpostMapStartup : WorlditemsMapStartupScript
{
	// Variables declared by included files, with the value they start with in this script
	DridmarsScriptsWipFoutpostMapStartup()
	{
		MAP_NAME = "foutpost";
		MAP_WEATHER = "clear;clear;clear;clear;clear;clear";
	}

	// unnamed block (first think)
	void DridmarsScriptsWipFoutpostMapStartup_FirstThink()
	{
		SetGlobal("MAP_CON", 1);

		SetGlobal("G_MAP_NAME", "The Forgotten Outpost by Evil Squirrel");
		SetGlobal("G_MAP_DESC", "This outpost holds by a thread against an impending orc invasion");
		SetGlobal("G_MAP_DIFF", "Levels 25-35 / 300-700hp");
		SetGlobal("G_WARN_HP", 300);

		CallEventDelayed(1.0f, "deralia_spawn");
	}

	// deralia_spawn
	void OnDeraliaSpawn()
	{
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DridmarsScriptsWipFoutpostMapStartup_FirstThink();
		WorlditemsMapStartup_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "deralia_spawn") { OnDeraliaSpawn(); return true; }
		return WorlditemsMapStartupScript::DispatchEvent(name, params);
	}
}
