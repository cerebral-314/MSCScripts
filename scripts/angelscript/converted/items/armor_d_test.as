#pragma context server

// Converted from items/armor_d_test.script by msc_transpiler.
// Thothie DA fix attempt #4 - File Pipes are not String Seperators (fixed the packs at least)

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_d_test"]
class ArmorDTest : ArmorBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	ArmorDTest()
	{
		ARMOR_TEXT = "No one tosses a dwarf.";
		BARMOR_TYPE = "dwarf_normal";
		BARMOR_PROTECTION = "10%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Dwarf Test");
		SetDescription("Testing the submodel system");
		SetWeight(120);
		SetWearable(1, "chest;arms;legs");
		SetValue(590);

		SetHudSprite("trade", "armor3");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return ArmorBaseScript::DispatchEvent(name, params);
	}
}
