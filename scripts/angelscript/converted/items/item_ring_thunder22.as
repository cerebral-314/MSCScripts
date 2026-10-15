#pragma context server

// Converted from items/item_ring_thunder22.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_elemental_resist.as"
#include "converted/items/base_miscitem.as"

[script "items/item_ring_thunder22"]
class ItemRingThunder22 : BaseMiscitemScript, BaseElementalResist
{
	// Constants
	string SP_ATTRIB = "skill.spellcasting.lightning.ratio";
	string ELM_NAME = "ringl";
	string ELM_TYPE = "lightning";

	// Variables (an unset .script variable reads as its own name)
	float ELM_AMT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ItemRingThunder22()
	{
		MODEL_BODY_OFS = "27";
		ANIM_PREFIX = "ring";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras

		SetModel("none");
	}

	// elm_get_resist
	void OnElmGetResist()
	{
		BaseElementalResist_OnElmGetResist(); // items/base_elemental_resist

		ELM_AMT = Float(GetProp(ENT_OWNER, SP_ATTRIB));
		ELM_AMT *= 200.0f;
		if (ELM_AMT > 75.0f)
			ELM_AMT = 75.0f;
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Ring of Grounding");
		SetDescription("This ring provides the owner some protection against lightning magics");

		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetValue(1000);
		SetWearable(1, "rightfinger");
		SetHudSprite("trade", "ring");
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		SetModel(MODEL_HANDS);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
	}

	// game_drop
	void OnGameDrop()
	{
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
	}

	// game_remove
	void OnGameRemove()
	{
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
	}

	// game_fall
	void OnGameFall()
	{
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
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
		if (name == "elm_get_resist") { OnElmGetResist(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
