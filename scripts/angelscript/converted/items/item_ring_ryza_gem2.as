#pragma context server

// Converted from items/item_ring_ryza_gem2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_ring_ryza_gem2"]
class ItemRingRyzaGem2 : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemRingRyzaGem2()
	{
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "ring";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras

		SetModel("none");
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Focusing Stone");
		SetDescription("Its radiance channels and focuses raw leyline energies.");

		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetValue(420);
		SetHudSprite("trade", "228");
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		SetModel(MODEL_HANDS);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
