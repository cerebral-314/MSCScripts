#pragma context server

// Converted from items/sheath_blunt_snakeskin.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_blunt_snakeskin"]
class SheathBluntSnakeskin : SheathBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	SheathBluntSnakeskin()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 50;
		CONTAINER_MAXITEMS = 6;
		CONTAINER_ITEM_ACCEPT = "blunt";
		CONTAINER_ITEM_REJECT = "item_tk_";
		MODEL_BODY_OFS = "4";
	}

	// sheath_spawn
	void OnSheathSpawn()
	{
		SetName("Snakeskin Hammer Holster");
		SetDescription("A series of snakeskin loops designed for holding blunt weapons");
		SetWeight(1);
		SetValue(50);
		SetWearable(1, "belt");
		SetHudSprite("trade", "sheath1");
	}

	// sheath_wear
	void OnSheathWear()
	{
		OwnerMessage("You fasten a set of large snakeskin loops to your belt.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "sheath_spawn") { OnSheathSpawn(); return true; }
		if (name == "sheath_wear") { OnSheathWear(); return true; }
		return SheathBaseScript::DispatchEvent(name, params);
	}
}
