#pragma context server

// Converted from items/armor_paura.script by msc_transpiler.
// Thothie - Acid Plate Armor from armor_faura

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"
#include "converted/items/base_elemental_resist.as"

[script "items/armor_paura"]
class ArmorPaura : ArmorBaseScript, BaseElementalResist
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest2.mdl";
	int ARMOR_GROUP = 4;
	int ARMOR_BODY = 7;
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	string ELM_NAME = "aarmr";
	string ELM_TYPE = "poison";
	float ELM_AMT = 50.0f;
	int ARMOR_STR_REQ = 30;
	string SOUND_GAS_ON = "ambience/steamburst1.wav";
	int NEW_ARMOR_OFS = 17;

	// Variables (an unset .script variable reads as its own name)
	bool PHOENIX_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ArmorPaura()
	{
		ARMOR_TEXT = "You assemble the the acid plate armor.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "50%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Acid Plate");
		SetDescription("Enchanted plate mail scorched by acid.");
		SetWeight(180);
		SetWearable(1, "chest;arms;legs");
		SetValue(1000);

		SetHudSprite("trade", "154");
	}

	// elm_activate_effect
	void OnElmActivateEffect()
	{
		float ownerSkill = SkillOf(ENT_OWNER, "spellcasting.affliction");
		if (ownerSkill < 20.0f)
			PlayerMessageDark(ENT_OWNER, "You lack the affliction skill to activate this armor's magic.");
		if (!(ownerSkill >= 20.0f))
			return;
		PHOENIX_ACTIVE = true;
		CallExternal(ENT_OWNER, "ext_register_element", ELM_NAME, ELM_TYPE, ELM_AMT);
		CallEventDelayed(0.1f, "secondary_element_activate");
	}

	// secondary_element_activate
	void OnSecondaryElementActivate()
	{
		CallExternal(ENT_OWNER, "ext_register_element", "aarmb", "acid", "80");
		CallEventDelayed(0.1f, "activate_aura");
	}

	// activate_aura
	void OnActivateAura()
	{
		float auraDot = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.3f;
		CallExternal(ENT_OWNER, "ext_poison_aura_activate", auraDot, 64);
		PlaySound(3, 10, SOUND_GAS_ON);
	}

	// elm_remove_effect
	void OnElmRemoveEffect()
	{
		if (!PHOENIX_ACTIVE)
			return;
		PHOENIX_ACTIVE = false;
		if (!(SkillOf(ENT_OWNER, "spellcasting.affliction") >= 20.0f))
			return;
		CallExternal(ENT_OWNER, "ext_register_element", ELM_NAME, "remove");
		CallEventDelayed(0.1f, "secondary_element_remove");
	}

	// secondary_element_remove
	void OnSecondaryElementRemove()
	{
		CallExternal(ENT_OWNER, "ext_register_element", "aarmb", "remove");
		CallEventDelayed(0.1f, "remove_aura");
	}

	// remove_aura
	void OnRemoveAura()
	{
		// remove sound
		CallExternal(ENT_OWNER, "ext_poison_aura_remove");
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("misc/p_misc.mdl");
		Precache("armor/p_armorvest_new.mdl");
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
		if (name == "activate_aura") { OnActivateAura(); return true; }
		if (name == "elm_activate_effect") { OnElmActivateEffect(); return true; }
		if (name == "elm_remove_effect") { OnElmRemoveEffect(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_aura") { OnRemoveAura(); return true; }
		if (name == "secondary_element_activate") { OnSecondaryElementActivate(); return true; }
		if (name == "secondary_element_remove") { OnSecondaryElementRemove(); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| ArmorBaseScript::DispatchEvent(name, params);
	}
}
