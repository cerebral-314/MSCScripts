#pragma context server

// Converted from items/ring_light2.script by msc_transpiler.
// Thothie - Wrong model offset, and no MODEL_VIEW defined no setmodelbody in drop

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"
#include "converted/items/base_effect_armor.as"

[script "items/ring_light2"]
class RingLight2 : BaseMiscitemScript, BaseEffectArmor
{
	// Variables (an unset .script variable reads as its own name)
	bool LIGHT_ON = false;

	// Variables declared by included files, with the value they start with in this script
	RingLight2()
	{
		MODEL_VIEW = "misc/p_misc.mdl";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "ring";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor

		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		if (LIGHT_ON)
			return;
		OnLightOn();
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!IsWorn(ENT_ME))
			return;
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		if (LIGHT_ON)
			return;
		OnLightOn();
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor

		SetModel("none");
	}

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Felewyn's Light");
		SetDescription("This sigil of Felewyn shall bring light on your path forever.");

		SetWeight(0);
		SetValue(1000);
		SetWearable(1, "rightfinger");
		SetHudSprite("trade", "ring");
	}

	// game_newowner
	void OnGameNewowner()
	{
		float body = ItemHandIndex() + 1.0f;
	}

	// barmor_effect_activate
	void OnBarmorEffectActivate()
	{
		if (LIGHT_ON)
			return;
		OnLightOn();
	}

	// barmor_effect_remove
	void OnBarmorEffectRemove()
	{
		if (!LIGHT_ON)
			return;
		OnLightOff();
	}

	// game_fall
	void OnGameFall()
	{
		SetModel(MODEL_WORLD);
		SetModelBody(0, Int(MODEL_BODY_OFS));

		if (!LIGHT_ON)
			return;
		OnLightOff();
	}

	// light_on
	void OnLightOn()
	{
		if (!IsWorn(ENT_ME))
			return;
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_HAS_GLOW"))) // dont fux with existing glow
			return;
		LIGHT_ON = true;
		CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "new", IndexOf(ENT_OWNER), Vector3(255, 255, 128), 192);
	}

	// light_off
	void OnLightOff()
	{
		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_HAS_GLOW"))) // dont fux with existing glow
			return;
		CallExternal(GetVar("GAME_MASTER"), "gm_light_update", "remove", IndexOf(ENT_OWNER), Vector3(255, 255, 128), 192);
		LIGHT_ON = false;
	}

	// ext_restore_item_lights
	void OnExtRestoreItemLights()
	{
		OnLightOn();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
	}

	// game_remove
	void OnGameRemove()
	{
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "barmor_effect_activate") { OnBarmorEffectActivate(); return true; }
		if (name == "barmor_effect_remove") { OnBarmorEffectRemove(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "ext_restore_item_lights") { OnExtRestoreItemLights(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_newowner") { OnGameNewowner(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "light_off") { OnLightOff(); return true; }
		if (name == "light_on") { OnLightOn(); return true; }
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseEffectArmor_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
