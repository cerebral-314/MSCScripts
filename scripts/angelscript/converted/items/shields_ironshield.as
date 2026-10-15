#pragma context server

// Converted from items/shields_ironshield.script by msc_transpiler.
// Thothie - long awaited "make sheilds useful" patch up

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_ironshield"]
class ShieldsIronshield : ShieldsBaseScript
{
	// Constants
	string SHIELD_MAXHEALTH = "1000";

	// Variables (an unset .script variable reads as its own name)
	string SHIELD_HEALTH = "SHIELD_HEALTH";

	// Variables declared by included files, with the value they start with in this script
	ShieldsIronshield()
	{
		NOPUSH_CHANCE = "50%";
		PARRY_MULTI = 1.75f;
		SHIELD_BASE_PARRY = 20;
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_BODY_OFS = "65";
		MELEE_ENERGY = 4.0f;
		MELEE_ACCURACY = "50%";
		BLOCK_CHANCE_UP = 100;
		DMG_BLOCK_UP = 0.35f;
		BLOCK_CHANCE_DOWN = 20;
		SOUND_BLOCK = "body/armour2.wav";
	}

	// unnamed block (first think)
	void ShieldsIronshield_FirstThink()
	{
		SHIELD_HEALTH = "1000";
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source); // items/shields_base

		OwnerMessage("You sling an iron shield over your shoulder.");
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Iron Shield");
		SetDescription("An Iron shield");
		SetWeight(40);
		SetValue(600);
		LegacyCommand("quality", 150);
		SetHudSprite("hand", "ironshield");
		SetHudSprite("trade", "ironshield");
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
		ShieldsIronshield_FirstThink();
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
