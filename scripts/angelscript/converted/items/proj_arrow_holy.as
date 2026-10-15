#pragma context server

// Converted from items/proj_arrow_holy.script by msc_transpiler.
// Holy Arrow by Thothie (from Poison Arrow)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_holy"]
class ProjArrowHoly : ProjArrowBaseScript
{
	// Constants
	string CLFX_ARROW = "1";
	string MODEL_BODY_OFS = "0";
	int ARROW_STICK_DURATION = 5;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "50%";

	// Variables declared by included files, with the value they start with in this script
	ProjArrowHoly()
	{
		SPRITE_ARROW_TRADE = "firearrow";
		PROJ_DAMAGE_TYPE = "holy";
		PROJ_DAMAGE = "300";
		ARROW_EXPIRE_DELAY = 5;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Holy Arrow");
		SetDescription("An arrow imbued with divine energies");
		SetWeight(0.125f);
		SetValue(300);
		SetGravity(0.8f);
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
