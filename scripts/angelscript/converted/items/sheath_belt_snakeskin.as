#pragma context server

// Converted from items/sheath_belt_snakeskin.script by msc_transpiler.
// Back sheath

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_belt_snakeskin"]
class SheathBeltSnakeskin : SheathBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	SheathBeltSnakeskin()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 30;
		CONTAINER_MAXITEMS = 6;
		CONTAINER_ITEM_ACCEPT = "swords";
		CONTAINER_ITEM_REJECT = "item_tk_";
		MODEL_BODY_OFS = "1";
	}

	// pack_deploy
	void OnPackDeploy()
	{
		SheathBase_OnPackDeploy(); // items/sheath_base

		SetViewModel("none");
	}

	// sheath_spawn
	void OnSheathSpawn()
	{
		SetName("Snakeskin Sword Sheath");
		SetDescription("A bundle of strong snakeskin tubes, easily affixed to a belt");
		SetWeight(1);
		SetValue(50);
		SetWearable(1, "belt");
		SetHudSprite("trade", "sheath1");
	}

	// sheath_wear
	void OnSheathWear()
	{
		OwnerMessage("You fasten some snakeskin tubes to your belt.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "pack_deploy") { OnPackDeploy(); return true; }
		if (name == "sheath_spawn") { OnSheathSpawn(); return true; }
		if (name == "sheath_wear") { OnSheathWear(); return true; }
		return SheathBaseScript::DispatchEvent(name, params);
	}
}
