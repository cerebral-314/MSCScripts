#pragma context server

// Converted from items/armor_leather_gaz1.script by msc_transpiler.
// Thothie DA fix attempt #4 - File Pipes are not String Seperators (fixed the packs at least)

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_leather_gaz1"]
class ArmorLeatherGaz1 : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest2.mdl";
	int ARMOR_GROUP = 4;
	int ARMOR_BODY = 4;
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	int NEW_ARMOR_OFS = 14;

	// Variables declared by included files, with the value they start with in this script
	ArmorLeatherGaz1()
	{
		ARMOR_TEXT = "You don the gladiator armor.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "45%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Gladiator Armor");
		SetDescription("The spiked set of banded leather");
		SetWeight(30);
		SetWearable(1, "chest|arms");
		SetValue(190);

		SetHudSprite("trade", "159");
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
