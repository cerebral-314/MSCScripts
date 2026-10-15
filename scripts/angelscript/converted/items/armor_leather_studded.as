#pragma context server

// Converted from items/armor_leather_studded.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_leather_studded"]
class ArmorLeatherStudded : ArmorBaseScript
{
	// Constants
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "chest";
	int NEW_ARMOR_OFS = 7;

	// Variables declared by included files, with the value they start with in this script
	ArmorLeatherStudded()
	{
		ARMOR_TEXT = "You work your way into some studded leather armor.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "23%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Studded Leather Vest");
		SetDescription("The studded leather armor has lots of nails spread around the vest.");
		SetWeight(28);
		SetWearable(1, "chest|arms");
		SetValue(190);

		SetHudSprite("trade", "156");
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
