#pragma context server

// Converted from items/proj_arrow_wooden.script by msc_transpiler.
// Wooden Arrow

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_wooden"]
class ProjArrowWooden : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "0";
	int ARROW_STICK_DURATION = 10;
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "20%";

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Wooden Arrow");
		SetDescription("A wooden arrow");
		SetWeight(0.1f);
		SetValue(1);
		SetGravity(0.7f);
		SetGroupable(25);
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
