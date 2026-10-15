#pragma context server

// Converted from items/proj_arrow_generic.script by msc_transpiler.
// Thothie - This arrow had no trade sprite
// -The grouping, and possibly the usable flag, were causing these to be unremovable from chests
// Blunt wooden Arrow -- the free newbie arrow

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_generic"]
class ProjArrowGeneric : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	int ARROW_BODY_OFS = 0;
	int ARROW_STICK_DURATION = 10;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowGeneric()
	{
		ARROW_EXPIRE_DELAY = 5;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Arrow");
		SetDescription("A crudely made arrow");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.75f);
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
