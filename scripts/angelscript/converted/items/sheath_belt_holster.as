#pragma context server

// Converted from items/sheath_belt_holster.script by msc_transpiler.
// Back sheath

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_belt_holster"]
class SheathBeltHolster : SheathBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	SheathBeltHolster()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 30;
		CONTAINER_MAXITEMS = 2;
		CONTAINER_ITEM_ACCEPT = "axes;blunt";
		MODEL_BODY_OFS = "1";
		CONTAINER_ITEM_REJECT = "item_tk_";
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
		SetName("Heavy Weapon Holster");
		SetDescription("A simple thick leather loop for axes and hammers.");
		SetWeight(1);
		SetValue(2);
		SetWearable(1, "belt");
		SetHudSprite("trade", "sheath1");
	}

	// sheath_wear
	void OnSheathWear()
	{
		OwnerMessage("You fasten a holster to your belt.");
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
