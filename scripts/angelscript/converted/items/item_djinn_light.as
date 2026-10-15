#pragma context server

// Converted from items/item_djinn_light.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/item_djinn_light"]
class ItemDjinnLight : ScriptEntity
{
	// Constants
	string SPRITE_FIRE = "bluejet1.spr";
	string SPRITE_FIRE_FIXED = "bluejet1.spr";
	float LIGHT_RADIUS = 300.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	float LIGHT_PLAYER_SCALE = 0.3f;
	float LIGHT_DROPPED_SCALE = 6.0f;

	// game_precache
	void OnGamePrecache()
	{
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("bluejet1.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return false;
	}
}
