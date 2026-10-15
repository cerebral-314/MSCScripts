#pragma context server

// Converted from items/item_hat.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base_helmet.as"

[script "items/item_hat"]
class ItemHat : ArmorBaseHelmetScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemHat()
	{
		ARMOR_MODEL = "armor/p_helmets.mdl";
		ARMOR_BODY = 11;
		ARMOR_TEXT = "You put on the funny hat.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "0%";
		STUN_PROTECTION = 1.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBaseHelmet_OnGameSpawn(playerRace, playerGender); // items/armor_base_helmet

		SetName("Funny Looking Hat");
		SetDescription("A funny looking hat. Who'd wear this thing anyways?");
		SetWeight(1);
		SetWearable(1, "head");
		SetValue(1);

		SetHudSprite("trade", "90");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/p_helmets.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return ArmorBaseHelmetScript::DispatchEvent(name, params);
	}
}
