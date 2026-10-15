#pragma context server

// Converted from items/gold_pouch_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GoldPouchBase
{
	// Constants
	string GOLD_AMT = "10";
	string SOUND_GOLD = "misc/gold.wav";

	// Variables (an unset .script variable reads as its own name)
	string GOLD_VALUE = "GOLD_VALUE";

	// game_spawn
	void GoldPouchBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Pouch of " + GOLD_AMT + " coins");
		SetDescription("You find some gold coins...");
		SetViewModel("none");
		SetWorldModel("none");
		SetModel("none");
		SetWeight(0);
		SetHudSprite("trade", "gold");
		SetAnimExtension("blunt");

		GOLD_VALUE = GOLD_AMT;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { GoldPouchBase_OnGameSpawn(playerRace, playerGender); } // game_spawn

	// This file's events and timers by their .script names
	bool GoldPouchBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/gold_pouch_base"]
shared class GoldPouchBaseScript : ScriptEntity, GoldPouchBase
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GoldPouchBase_DispatchEvent(name, params);
	}
}
