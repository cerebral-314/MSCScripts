#pragma context server

// Converted from items/armor_golden.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_golden"]
class ArmorGolden : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 3;
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	int ARMOR_STR_REQ = 25;
	int NEW_ARMOR_OFS = 4;

	// Variables declared by included files, with the value they start with in this script
	ArmorGolden()
	{
		ARMOR_TEXT = "It is as comforting putting this armor on as it is a beauty to the eye.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "60%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Lord Vecilus' Mail");
		SetDescription("This elven armor was once worn by Lord Vecilus");
		SetWeight(210);
		SetWearable(1, "chest|arms|legs");
		SetValue(1200);

		SetHudSprite("trade", "148");
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
