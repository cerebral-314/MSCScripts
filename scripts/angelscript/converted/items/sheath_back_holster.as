#pragma context server

// Converted from items/sheath_back_holster.script by msc_transpiler.
// Back sheath

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

[script "items/sheath_back_holster"]
class SheathBackHolster : SheathBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	SheathBackHolster()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 30;
		CONTAINER_MAXITEMS = 16;
		CONTAINER_ITEM_ACCEPT = "blunt;axes;swords;smallarms;bows;crossbow;polearms;gauntlet_";
		CONTAINER_ITEM_REJECT = "item_tk_";
		MODEL_BODY_OFS = "3";
	}

	// unnamed block (first think)
	void SheathBackHolster_FirstThink()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 30;
		CONTAINER_MAXITEMS = 16;
		CONTAINER_CANCLOSE = false;
		CONTAINER_LOCK_STRENGTH = false;
		CONTAINER_ITEM_ACCEPT = "blunt;axes;swords;smallarms;bows;crossbow;polearms;gauntlet_";
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
		SetName("Weapons Strap");
		SetDescription("A leather back strap with loops to hang a large array of weapons.");
		SetWeight(0);
		SetValue(25);
		SetWearable(1, "back");
		SetHudSprite("trade", "sheath2");
	}

	// sheath_wear
	void OnSheathWear()
	{
		OwnerMessage("You loop a large leather strap across your back.");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SheathBackHolster_FirstThink();
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
