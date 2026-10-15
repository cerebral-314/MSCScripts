#pragma context server

// Converted from items/armor_belmont.script by msc_transpiler.
// Thothie DA fix attempt #4 - File Pipes are not String Seperators (fixed the packs at least)

#include "runtime/ScriptEntity.as"
#include "converted/items/base_elemental_resist.as"
#include "converted/items/armor_base.as"

[script "items/armor_belmont"]
class ArmorBelmont : ArmorBaseScript, BaseElementalResist
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest2.mdl";
	int ARMOR_GROUP = 4;
	int ARMOR_BODY = 0;
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	bool REG_SPECIAL_EFFECT = true;
	bool BER_ACTIVATE_WHILE_WORN = true;
	int ARMOR_STR_REQ = 40;
	int NEW_ARMOR_OFS = 10;

	// Variables (an unset .script variable reads as its own name)
	bool EFFECT_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ArmorBelmont()
	{
		ARMOR_TEXT = "You don the Armor of Bravery.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "40%";
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		ArmorBase_OnExtActivateItems(playerId); // items/armor_base
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		EFFECT_ACTIVE = false;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Armor of Bravery");
		SetDescription("The bloodstains tell tales of brave warriors fallen in battle.");
		SetWeight(120);
		SetWearable(1, "chest;arms;legs");
		SetValue(590);

		SetHudSprite("trade", "150");
	}

	// elm_activate_effect
	void OnElmActivateEffect()
	{
		if (!IsWorn(ENT_ME))
			return;
		if (EFFECT_ACTIVE)
			return;
		PlayerMessageGreen(ENT_OWNER, "You are now... stylin'...");
		EFFECT_ACTIVE = true;
	}

	// elm_remove_effect
	void OnElmRemoveEffect()
	{
		EFFECT_ACTIVE = false;
		PlayerMessageDark(ENT_OWNER, "You feel normal.");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
	}

	// game_drop
	void OnGameDrop()
	{
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
	}

	// game_remove
	void OnGameRemove()
	{
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
	}

	// game_fall
	void OnGameFall()
	{
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
		ArmorBase_OnGameDeploy(); // items/armor_base
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBase_OnGameWear(race, gender, source); // items/armor_base
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseElementalResist_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "elm_activate_effect") { OnElmActivateEffect(); return true; }
		if (name == "elm_remove_effect") { OnElmRemoveEffect(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| ArmorBaseScript::DispatchEvent(name, params);
	}
}
