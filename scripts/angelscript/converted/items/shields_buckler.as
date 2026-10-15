#pragma context server

// Converted from items/shields_buckler.script by msc_transpiler.
// Buckler

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_buckler"]
class ShieldsBuckler : ShieldsBaseScript
{
	// Constants
	string SHIELD_MAXHEALTH = "500";

	// Variables (an unset .script variable reads as its own name)
	string SHIELD_HEALTH = "SHIELD_HEALTH";

	// Variables declared by included files, with the value they start with in this script
	ShieldsBuckler()
	{
		NOPUSH_CHANCE = "25%";
		PARRY_MULTI = 1.3f;
		SHIELD_BASE_PARRY = 10;
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_VIEW_IDX = 1;
		MODEL_BODY_OFS = "61";
		MELEE_ENERGY = 15.0f;
		MELEE_ACCURACY = "90%";
		BLOCK_CHANCE_UP = 100;
		DMG_BLOCK_UP = 0.4f;
		BLOCK_CHANCE_DOWN = 15;
		SOUND_BLOCK = "debris/metal3.wav";
	}

	// unnamed block (first think)
	void ShieldsBuckler_FirstThink()
	{
		SHIELD_HEALTH = "500";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source); // items/shields_base

		OwnerMessage("You sling a training shield over your shoulder.");
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Training shield");
		SetDescription("A light shield for deflecting blows");
		SetWeight(10);
		SetValue(50);
		LegacyCommand("quality", 60);
		// sethudsprite hand ironshield
		SetHudSprite("trade", "178");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_shields.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShieldsBuckler_FirstThink();
		ShieldsBase_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "shield_spawn") { OnShieldSpawn(); return true; }
		return ShieldsBaseScript::DispatchEvent(name, params);
	}
}
