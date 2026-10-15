#pragma context server

// Converted from items/proj_arrow_silvertipped.script by msc_transpiler.
// Silver-tipped Arrow

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_silvertipped"]
class ProjArrowSilvertipped : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "6";
	int PROJ_STICK_DURATION = 45;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "20%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowSilvertipped()
	{
		ARROW_EXPIRE_DELAY = 5;
		SPRITE_ARROW_TRADE = "silverarrow";
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Elven Arrow");
		SetDescription("Light, elven arrows. Long distance in trade for poor damage");
		SetWeight(0.1f);
		SetValue(3);
		SetGravity(0.5f);
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
