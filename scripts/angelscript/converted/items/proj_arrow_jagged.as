#pragma context server

// Converted from items/proj_arrow_jagged.script by msc_transpiler.
// Thothie - This arrow had no trade sprite
// -The grouping, and possibly the usable flag, were causing these to be unremovable from chests

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_jagged"]
class ProjArrowJagged : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 25;
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowJagged()
	{
		SPRITE_ARROW_TRADE = "silverarrow";
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Jagged Arrow");
		SetDescription("When the target moves, the jags wound it");
		SetWeight(0.15f);
		SetValue(50);
		SetGravity(0.8f);

		// groupable    	25	//Thothie notices: arrows that work, do not have grouping property
		// useable		0//Can't be picked up - Thothie removes thinking maybe part of reason cant get from chests
		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", SPRITE_ARROW_TRADE);
		SetHand("any");
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
