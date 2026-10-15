#pragma context server

// Converted from items/armor_leather_torn.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_leather_torn"]
class ArmorLeatherTorn : ArmorBaseScript
{
	// Constants
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "chest";
	int NEW_ARMOR_OFS = 6;

	// Variables declared by included files, with the value they start with in this script
	ArmorLeatherTorn()
	{
		ARMOR_TEXT = "You put on the hide armor.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "5%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Hide Armor");
		SetDescription("Basic protective armor made out of animal skins, commonly used by hunters and travelers.");
		SetWeight(12);
		SetWearable(1, "chest|arms");
		SetValue(30);

		SetHudSprite("trade", "155");
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
