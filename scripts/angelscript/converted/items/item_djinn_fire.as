#pragma context server

// Converted from items/item_djinn_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/item_djinn_fire"]
class ItemDjinnFire : ScriptEntity
{
	// Constants
	string SPRITE_FIRE = "fire1_fixed.spr";
	string SPRITE_FIRE_FIXED = "fire1_fixed.spr";
	float LIGHT_RADIUS = 300.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	float LIGHT_PLAYER_SCALE = 0.3f;
	float LIGHT_DROPPED_SCALE = 5.0f;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
	}
}
