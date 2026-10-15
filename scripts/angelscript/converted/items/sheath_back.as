#pragma context server

// Converted from items/sheath_back.script by msc_transpiler.
// Back sheath

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_back"]
class SheathBack : SheathBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	SheathBack()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 4;
		CONTAINER_MAXITEMS = 1;
		CONTAINER_ITEM_ACCEPT = "swords;polearms";
		CONTAINER_ITEM_REJECT = "item_tk_";
		MODEL_BODY_OFS = "3";
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
		SetName("Back Sword Sheath");
		SetDescription("A leather sheath, designed to be worn across the back.");
		SetWeight(1);
		SetValue(4);
		SetWearable(1, "back");
		SetHudSprite("trade", "sheath2");
	}

	// sheath_wear
	void OnSheathWear()
	{
		OwnerMessage("You strap a leather sheath across your back.");
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
