#pragma context server

// Converted from items/armor_dark.script by msc_transpiler.
// Thothie DA fix attempt #4 - File Pipes are not String Seperators (fixed the packs at least)

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_dark"]
class ArmorDark : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 4;
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	int NEW_ARMOR_OFS = 5;

	// Variables declared by included files, with the value they start with in this script
	ArmorDark()
	{
		ARMOR_TEXT = "A stench of evil stings your nostrils.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "50%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Sir Geric's Armor");
		SetDescription("This armor reeks with the soul of Sir Geric");
		SetWeight(120);
		SetWearable(1, "chest;arms;legs");
		SetValue(590);

		SetHudSprite("trade", "149");
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
