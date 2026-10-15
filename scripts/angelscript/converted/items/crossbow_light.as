#pragma context server

// Converted from items/crossbow_light.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/health_apple.as"

[script "items/crossbow_light"]
class CrossbowLight : HealthAppleScript
{
	// Variables declared by included files, with the value they start with in this script
	CrossbowLight()
	{
		DRINK_AMOUNT = 1;
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		HealthApple_OnDrinkSpawn(); // items/health_apple
		SetName("Cheater's Crossbow");
		SetDescription("Eat this, cheaters");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "drink_spawn") { OnDrinkSpawn(); return true; }
		return HealthAppleScript::DispatchEvent(name, params);
	}
}
