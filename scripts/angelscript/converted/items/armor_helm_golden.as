#pragma context server

// Converted from items/armor_helm_golden.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base_helmet.as"

[script "items/armor_helm_golden"]
class ArmorHelmGolden : ArmorBaseHelmetScript
{
	// Variables declared by included files, with the value they start with in this script
	ArmorHelmGolden()
	{
		ARMOR_MODEL = "armor/p_helmets.mdl";
		ARMOR_BODY = 3;
		ARMOR_TEXT = "You put on the golden platemail helmet.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "60%";
		STUN_PROTECTION = 0.65f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBaseHelmet_OnGameSpawn(playerRace, playerGender); // items/armor_base_helmet

		SetName("Golden Platemail Helmet");
		SetDescription("A golden platemail helmet");
		SetWeight(20);
		SetWearable(1, "head");
		SetValue(2500);

		SetHudSprite("trade", "84");
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
