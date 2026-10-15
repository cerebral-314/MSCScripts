#pragma context server

// Converted from items/item_ring_percept.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_effect_armor.as"
#include "converted/items/base_miscitem.as"

[script "items/item_ring_percept"]
class ItemRingPercept : BaseMiscitemScript, BaseEffectArmor
{
	// Variables declared by included files, with the value they start with in this script
	ItemRingPercept()
	{
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "ring";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		SetModel("none");
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Bloodstone Ring");
		SetDescription("A sinister red stone is mounted in this ring");

		SetViewModel("none");
		SetWorldModel(MODEL_WORLD);
		SetValue(100);
		SetWearable(1, "rightfinger");
		SetHudSprite("trade", "ring");
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		SetModel(MODEL_HANDS);
	}

	// barmor_effect_activate
	void OnBarmorEffectActivate()
	{
		CallExternal(ENT_OWNER, "bloodstone_toggle", 1);
	}

	// barmor_effect_remove
	void OnBarmorEffectRemove()
	{
		CallExternal(ENT_OWNER, "bloodstone_toggle", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
	}

	// game_remove
	void OnGameRemove()
	{
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
	}

	// game_fall
	void OnGameFall()
	{
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
	}

	// game_drop
	void OnGameDrop()
	{
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "barmor_effect_activate") { OnBarmorEffectActivate(); return true; }
		if (name == "barmor_effect_remove") { OnBarmorEffectRemove(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseEffectArmor_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
