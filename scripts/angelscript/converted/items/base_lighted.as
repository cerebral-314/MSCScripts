#pragma context server

// Converted from items/base_lighted.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseLighted
{
	// Constants
	string SPRITE_FIRE = "fire1_fixed.spr";
	string SPRITE_FIRE_FIXED = "fire1_fixed.spr";
	string LIGHT_COLOR = "LIGHT_COLOR";
	float LIGHT_PLAYER_SCALE = 0.3f;
	float LIGHT_DROPPED_SCALE = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	float LIGHT_RADIUS = 0.0f;

	// unnamed block (first think)
	void BaseLighted_FirstThink()
	{
		LIGHT_RADIUS = 192.0f;
	}

	// game_putinpack
	void BaseLighted_OnGamePutinpack()
	{
		ClientEffect("all", GetVar("LAST_TORCH_LIGHT"));
		ClientEffect("remove", "all", GetVar("LAST_TORCH_LIGHT"));
	}

	// game_removefromowner
	void BaseLighted_OnGameRemovefromowner()
	{
		ClientEffect("all", GetVar("LAST_TORCH_LIGHT"));
		ClientEffect("remove", "all", GetVar("LAST_TORCH_LIGHT"));
	}

	// game_newowner
	void BaseLighted_OnGameNewowner()
	{
		ClientEffect("all", GetVar("LAST_TORCH_LIGHT"));
		ClientEffect("remove", "all", GetVar("LAST_TORCH_LIGHT"));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePutinpack() { BaseLighted_OnGamePutinpack(); } // game_putinpack
	void OnGameRemovefromowner() { BaseLighted_OnGameRemovefromowner(); } // game_removefromowner
	void OnGameNewowner() { BaseLighted_OnGameNewowner(); } // game_newowner

	// This file's events and timers by their .script names
	bool BaseLighted_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_newowner") { OnGameNewowner(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_lighted"]
shared class BaseLightedScript : ScriptEntity, BaseLighted
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseLighted_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseLighted_DispatchEvent(name, params);
	}
}
