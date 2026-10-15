#pragma context server

// Converted from items/proj_arrow_blunt.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_blunt"]
class ProjArrowBlunt : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 3;
	bool PROJ_STICK_ON_WALL_NEW = true;
	bool PROJ_REMOVE_ON_USE = true;
	int ARROW_STICK_DURATION = 25;
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowBlunt()
	{
		SPRITE_ARROW_TRADE = "broadarrow";
		PROJ_DAMAGE_TYPE = "blunt";
		ARROW_EXPIRE_DELAY = 120;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Climbing Arrow");
		SetDescription("An sturdy arrow with a forked iron tip for use as a piton");
		SetWeight(0.25f);
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
