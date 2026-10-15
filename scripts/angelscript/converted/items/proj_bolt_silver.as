#pragma context server

// Converted from items/proj_bolt_silver.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_bolt_silver"]
class ProjBoltSilver : ProjArrowBaseScript
{
	// Constants
	bool HITSCAN_BOLT = true;
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	ProjBoltSilver()
	{
		PROJ_DAMAGE = "400";
		PROJ_DAMAGE_TYPE = "holy";
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Blessed Bolt");
		SetDescription("A crossbow bolt blessed with enchanted silver to fight the unholy.");
		SetWeight(0.175f);
		SetValue(400);
		SetGravity(0);
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
