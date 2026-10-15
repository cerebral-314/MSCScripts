#pragma context server

// Converted from items/armor_mongol.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_mongol"]
class ArmorMongol : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 1;
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	int NEW_ARMOR_OFS = 2;

	// Variables declared by included files, with the value they start with in this script
	ArmorMongol()
	{
		ARMOR_TEXT = "You strap on some banded mail armor.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "30%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Suit of Banded Mail");
		SetDescription("This is an old set of banded armor");
		SetWeight(90);
		SetWearable(1, "chest|arms|legs");
		SetValue(350);

		SetHudSprite("trade", "armor2");
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
