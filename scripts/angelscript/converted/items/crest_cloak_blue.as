#pragma context server

// Converted from items/crest_cloak_blue.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/crest_cloak_blue"]
class CrestCloakBlue : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 13;
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	int NEW_ARMOR_OFS = 13;

	// Variables declared by included files, with the value they start with in this script
	CrestCloakBlue()
	{
		ARMOR_TEXT = "You feel the Orochiness.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "0%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Jacket of Orochi 3.0");
		SetDescription("Feel the re-re-revised Orochiness");
		SetWeight(0);
		SetWearable(1, "neck");
		SetValue(1);

		SetHudSprite("trade", "crestedana");
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
