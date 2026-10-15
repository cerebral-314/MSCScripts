#pragma context server

// Converted from items/proj_arrow_broadhead.script by msc_transpiler.
// Broadhead arrow
// 2:50 PM 2/11/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_broadhead"]
class ProjArrowBroadhead : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowBroadhead()
	{
		SPRITE_ARROW_TRADE = "broadarrow";
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Iron Arrow");
		SetDescription("Great damage in trade for short range");
		SetWeight(0.125f);
		SetValue(5);
		SetGravity(0.85f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
