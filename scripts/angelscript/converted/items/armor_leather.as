#pragma context server

// Converted from items/armor_leather.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_leather"]
class ArmorLeather : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 5;
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "chest";
	int NEW_ARMOR_OFS = 6;

	// Variables declared by included files, with the value they start with in this script
	ArmorLeather()
	{
		ARMOR_TEXT = "You work your way into some leather armor.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "12%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Leather Vest");
		SetDescription("Leather armor, provides minimal protection");
		SetWeight(12);
		SetWearable(1, "chest;arms");
		SetValue(85);

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
