#pragma context server

// Converted from items/pack_xbowquiver.script by msc_transpiler.
// Quiver for crossbow bolts
// 9:47 PM 2/16/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_quiver.as"

[script "items/pack_xbowquiver"]
class PackXbowquiver : PackQuiverScript
{
	// Variables declared by included files, with the value they start with in this script
	PackXbowquiver()
	{
		ANIM_IDLE = "0";
		MODEL_VIEW = "weapons/bows/quiver_rview.mdl";
		CONTAINER_ITEM_ACCEPT = "bolt";
	}

	// pack_spawn
	void OnPackSpawn()
	{
		PackQuiver_OnPackSpawn(); // items/pack_quiver

		SetName("Quiver of Bolts");
		SetDescription("This quiver holds only crossbow bolts");
		SetWeight(1);
		SetValue(80);
		SetWearable(1, "back");
		SetHudSprite("hand", "quiver");
		SetHudSprite("trade", "quiver");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/quiver_floor.mdl");
		Precache("weapons/bows/quiver_rview.mdl");
		Precache("weapons/bows/quiver_hands.mdl");
		Precache("weapons/bows/quiver_spine3.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "pack_spawn") { OnPackSpawn(); return true; }
		return PackQuiverScript::DispatchEvent(name, params);
	}
}
