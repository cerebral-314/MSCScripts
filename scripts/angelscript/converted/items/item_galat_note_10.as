#pragma context server

// Converted from items/item_galat_note_10.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_galat_note_10"]
class ItemGalatNote10 : BaseMiscitemScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemGalatNote10()
	{
		MODEL_WORLD = "garbagegibs.mdl";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem

		SetName("Galat Bank Note (10gp)");
		SetDescription("An official bank note for 10 gold peices");
		SetHudSprite("trade", "letter");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("garbagegibs.mdl");
		Precache("misc/p_misc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
