#pragma context server

// Converted from items/shields_wooden.script by msc_transpiler.
// Thothie - Wooden Shield, from Buckler

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_wooden"]
class ShieldsWooden : ShieldsBaseScript
{
	// Constants
	string SHIELD_MAXHEALTH = "200";

	// Variables (an unset .script variable reads as its own name)
	string SHIELD_HEALTH = "SHIELD_HEALTH";

	// Variables declared by included files, with the value they start with in this script
	ShieldsWooden()
	{
		PARRY_MULTI = 1.25f;
		SHIELD_BASE_PARRY = 5;
		NOPUSH_CHANCE = "25%";
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_VIEW_IDX = 1;
		MODEL_BODY_OFS = "61";
		MELEE_ENERGY = 0.5f;
		MELEE_ACCURACY = "30%";
		BLOCK_CHANCE_UP = 90;
		DMG_BLOCK_UP = 0.6f;
		BLOCK_CHANCE_DOWN = 15;
		SOUND_BLOCK = "debris/wood2.wav";
	}

	// unnamed block (first think)
	void ShieldsWooden_FirstThink()
	{
		SHIELD_HEALTH = "200";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source); // items/shields_base

		OwnerMessage("You sling a wooden shield over your shoulder.");
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Wooden Shield");
		SetDescription("A poor defense, but still better than your forearm.");
		SetWeight(15);
		SetValue(35);
		LegacyCommand("quality", 60);
		SetHudSprite("hand", "ironshield");
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
		ShieldsWooden_FirstThink();
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
