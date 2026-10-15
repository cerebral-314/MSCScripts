#pragma context server

// Converted from items/armor_fireliz.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"
#include "converted/items/base_elemental_resist.as"

[script "items/armor_fireliz"]
class ArmorFireliz : ArmorBaseScript, BaseElementalResist
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 7;
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "chest";
	string ELM_NAME = "firel";
	string ELM_TYPE = "fire";
	float ELM_AMT = 75.0f;
	int NEW_ARMOR_OFS = 8;

	// Variables declared by included files, with the value they start with in this script
	ArmorFireliz()
	{
		ARMOR_TEXT = "You work your way into some fire lizard skins.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "45%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Fire Lizard Skin");
		SetDescription("This armor is carved from the hide of a Fire Lizard");
		SetWeight(28);
		SetWearable(1, "chest|arms");
		SetValue(190);

		SetHudSprite("trade", "157");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
		ArmorBase_OnGameDeploy(); // items/armor_base
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		ArmorBase_OnExtActivateItems(playerId); // items/armor_base
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBase_OnGameWear(race, gender, source); // items/armor_base
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
	}

	// game_remove
	void OnGameRemove()
	{
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseItemExtras_FirstThink();
		BaseElementalResist_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| ArmorBaseScript::DispatchEvent(name, params);
	}
}
