#pragma context server

// Converted from items/armor_helm_elyg.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_elemental_resist.as"
#include "converted/items/armor_base_helmet.as"

[script "items/armor_helm_elyg"]
class ArmorHelmElyg : ArmorBaseHelmetScript, BaseElementalResist
{
	// Constants
	string ARMOR_BODY_HUMAN_FEMALE = "29";
	string SP_ATTRIB = "skill.spellcasting.affliction.ratio";
	string ELM_NAME = "velm1";
	string ELM_TYPE = "poison";

	// Variables (an unset .script variable reads as its own name)
	float ELM_AMT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ArmorHelmElyg()
	{
		ARMOR_MODEL = "armor/p_helmets.mdl";
		ARMOR_BODY = 28;
		ARMOR_TEXT = "You equip the Helm of Venom.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "60%";
		STUN_PROTECTION = 0.5f;
	}

	// elm_activate_effect
	void OnElmActivateEffect()
	{
		BaseElementalResist_OnElmActivateEffect(); // items/base_elemental_resist
		CallExternal(ENT_OWNER, "ext_register_element", "velm2", "acid", ELM_AMT);
	}

	// elm_remove_effect
	void OnElmRemoveEffect()
	{
		BaseElementalResist_OnElmRemoveEffect(); // items/base_elemental_resist
		CallExternal(ENT_OWNER, "ext_register_element", "velm2", "remove");
	}

	// elm_get_resist
	void OnElmGetResist()
	{
		BaseElementalResist_OnElmGetResist(); // items/base_elemental_resist

		ELM_AMT = Float(GetProp(ENT_OWNER, SP_ATTRIB));
		ELM_AMT *= 2.0f;
		ELM_AMT *= 100.0f;
		if (ELM_AMT > 25.0f)
			ELM_AMT = 25.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBaseHelmet_OnGameSpawn(playerRace, playerGender); // items/armor_base_helmet

		SetName("Helm of Venom");
		SetDescription("This battered helm protects the wearer from poisons");
		SetWeight(1);
		SetWearable(1, "head");
		SetValue(1000);

		SetHudSprite("trade", "49");
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
		ArmorBaseHelmet_OnGameWear(race, gender, source); // items/armor_base_helmet
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/p_helmets.mdl");
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
		if (name == "elm_get_resist") { OnElmGetResist(); return true; }
		if (name == "elm_remove_effect") { OnElmRemoveEffect(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| ArmorBaseHelmetScript::DispatchEvent(name, params);
	}
}
