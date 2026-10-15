#pragma context server

// Converted from items/item_log.script by msc_transpiler.
// Thothie - Playing with fire... wood.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_log"]
class ItemLog : BaseMiscitemScript
{
	// Constants
	string TORCH_LIGHT_SCRIPT = "items/item_torch_light";

	// Variables (an unset .script variable reads as its own name)
	string SCRIPT_ID = "SCRIPT_ID";

	// Variables declared by included files, with the value they start with in this script
	ItemLog()
	{
		MODEL_WORLD = "misc/item_log.mdl";
		MODEL_HANDS = "misc/item_log.mdl";
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem

		// applyeffect ent_me effects/dot_fire 999 $get(ent_owner,id) 0
		ClientEvent("persist", "all", TORCH_LIGHT_SCRIPT, IndexOf(ENT_ME), 1);
		SCRIPT_ID = LastClientScriptId();
	}

	// game_pickup
	void OnGamePickup()
	{
		BaseMiscitem_OnGamePickup(); // items/base_miscitem

		// callexternal effects/dot_fire effect_die
		ClientEvent("remove", "all", SCRIPT_ID);
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Firewood");
		SetDescription("Some high quality firewood");
		SetWeight(7);
		SetValue(5);
		SetHudSprite("trade", "log");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/item_log.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
