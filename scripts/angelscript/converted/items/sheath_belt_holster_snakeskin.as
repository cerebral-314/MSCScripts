#pragma context server

// Converted from items/sheath_belt_holster_snakeskin.script by msc_transpiler.
// Back sheath

#include "runtime/ScriptEntity.as"
#include "converted/items/sheath_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SheathBeltHolsterSnakeskin
{
	// Constants
	string CONTAINER_TYPE = "sheath";
	int CONTAINER_SPACE = 30;
	int CONTAINER_MAXITEMS = 6;
	bool CONTAINER_CANCLOSE = false;
	bool CONTAINER_LOCK_STRENGTH = false;
	string CONTAINER_ITEM_ACCEPT = "axes;blunt";
	string CONTAINER_ITEM_REJECT = "item_tk_";
	string MODEL_BODY_OFS = "1";

	// sheath_spawn
	void SheathBeltHolsterSnakeskin_OnSheathSpawn()
	{
		SetName("Snakeskin Heavy Holster");
		SetDescription("A series of snakeskin loops for axes and hammers");
		SetWeight(1);
		SetValue(25);
		SetWearable(1, "belt");
		SetHudSprite("trade", "sheath1");
	}

	// pack_deploy
	void SheathBeltHolsterSnakeskin_OnPackDeploy()
	{
		SetViewModel("none");
	}

	// sheath_wear
	void SheathBeltHolsterSnakeskin_OnSheathWear()
	{
		OwnerMessage("You fasten some large snakeskin loops to your belt.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// pack_deploy
	void OnPackDeploy()
	{
		SheathBase_OnPackDeploy(); // items/sheath_base
		SheathBeltHolsterSnakeskin_OnPackDeploy();
	}

	void OnSheathSpawn() { SheathBeltHolsterSnakeskin_OnSheathSpawn(); } // sheath_spawn
	void OnSheathWear() { SheathBeltHolsterSnakeskin_OnSheathWear(); } // sheath_wear

	// This file's events and timers by their .script names
	bool SheathBeltHolsterSnakeskin_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "pack_deploy") { OnPackDeploy(); return true; }
		if (name == "sheath_spawn") { OnSheathSpawn(); return true; }
		if (name == "sheath_wear") { OnSheathWear(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/sheath_belt_holster_snakeskin"]
shared class SheathBeltHolsterSnakeskinScript : SheathBaseScript, SheathBeltHolsterSnakeskin
{
	// Variables declared by included files, with the value they start with in this script
	SheathBeltHolsterSnakeskinScript()
	{
		CONTAINER_TYPE = "sheath";
		CONTAINER_SPACE = 30;
		CONTAINER_MAXITEMS = 6;
		CONTAINER_ITEM_ACCEPT = "axes;blunt";
		CONTAINER_ITEM_REJECT = "item_tk_";
		MODEL_BODY_OFS = "1";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SheathBeltHolsterSnakeskin_DispatchEvent(name, params)
			|| SheathBaseScript::DispatchEvent(name, params);
	}
}
