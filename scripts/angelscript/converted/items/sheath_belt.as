#pragma context server

// Converted from items/sheath_belt.script by msc_transpiler.
// Back sheath

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_belt"]
class SheathBelt : SheathBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	SheathBelt()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 4;
		CONTAINER_MAXITEMS = 1;
		CONTAINER_ITEM_ACCEPT = "swords";
		MODEL_BODY_OFS = "1";
		CONTAINER_ITEM_REJECT = "item_tk_";
	}

	// unnamed block (first think)
	void SheathBelt_FirstThink()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 4;
		CONTAINER_MAXITEMS = 1;
		CONTAINER_CANCLOSE = false;
		CONTAINER_LOCK_STRENGTH = false;
		CONTAINER_ITEM_ACCEPT = "swords";
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
		SetName("Belt Sword Sheath");
		SetDescription("A leather belt sheath");
		SetWeight(1);
		SetValue(2);
		SetWearable(1, "belt");
		SetHudSprite("trade", "sheath1");
	}

	// sheath_wear
	void OnSheathWear()
	{
		OwnerMessage("You fasten a leather sheath to your belt.");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SheathBelt_FirstThink();
		BaseItemExtras_FirstThink();
	}

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
