#pragma context server

// Converted from items/armor_rm.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_rm"]
class ArmorRm : ArmorBaseScript
{
	// Constants
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	int NEW_ARMOR_OFS = 18;

	// Variables declared by included files, with the value they start with in this script
	ArmorRm()
	{
		ARMOR_TEXT = "Just testing...";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "00%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Maldora's Robes");
		SetDescription("Someone broke into Maldora's closet");
		SetWeight(10);
		SetWearable(1, "chest;arms;legs");
		SetValue(0);

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
