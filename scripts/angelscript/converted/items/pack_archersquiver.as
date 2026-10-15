#pragma context server

// Converted from items/pack_archersquiver.script by msc_transpiler.
// Quiver for crossbow bolts
// 9:47 PM 2/16/2005

#include "runtime/ScriptEntity.as"
#include "converted/items/pack_quiver.as"

[script "items/pack_archersquiver"]
class PackArchersquiver : PackQuiverScript
{
	// Variables declared by included files, with the value they start with in this script
	PackArchersquiver()
	{
		ANIM_IDLE = "0";
		MODEL_VIEW = "weapons/bows/quiver_rview.mdl";
		CONTAINER_SPACE = 600;
		CONTAINER_MAXITEMS = 16;
		CONTAINER_ITEM_ACCEPT = "arrow;bolt;bows;crossbow";
	}

	// pack_spawn
	void OnPackSpawn()
	{
		PackQuiver_OnPackSpawn(); // items/pack_quiver

		SetName("Quiver of the Archer");
		SetDescription("A large quiver for all sorts of projectiles");
		SetWeight(4);
		SetValue(25);
		SetWearable(1, "back");
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
