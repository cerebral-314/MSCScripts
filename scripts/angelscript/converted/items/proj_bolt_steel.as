#pragma context server

// Converted from items/proj_bolt_steel.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_bolt_steel"]
class ProjBoltSteel : ProjArrowBaseScript
{
	// Constants
	bool HITSCAN_BOLT = true;
	bool HEAVY_ONLY = true;
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables (an unset .script variable reads as its own name)
	float HEAVY_BOLT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjBoltSteel()
	{
		PROJ_DAMAGE = "400";
	}

	// unnamed block (first think)
	void ProjBoltSteel_FirstThink()
	{
		HEAVY_BOLT = 0.5f;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Steel Bolt");
		SetDescription("A crossbow bolt made of heavy steel designed for heavier crossbows");
		SetWeight(0.175f);
		SetValue(200);
		SetGravity(2);
		SetGroupable(25);

		@MY_XBOW = ActiveItemOf(ENT_EXPOWNER);
		if (Contains(NameOf(MY_XBOW), "Heavy"))
			SetGravity(0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ProjBoltSteel_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
