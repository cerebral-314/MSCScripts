#pragma context server

// Converted from items/shields_lironshield.script by msc_transpiler.
// Iron shield

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_lironshield"]
class ShieldsLironshield : ShieldsBaseScript
{
	// Constants
	string SHIELD_MAXHEALTH = "4000";

	// Variables (an unset .script variable reads as its own name)
	string SHIELD_HEALTH = "SHIELD_HEALTH";

	// Variables declared by included files, with the value they start with in this script
	ShieldsLironshield()
	{
		NOPUSH_CHANCE = "100%";
		PARRY_MULTI = 2.5f;
		SHIELD_BASE_PARRY = 40;
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_BODY_OFS = "65";
		MELEE_ENERGY = 8.0f;
		MELEE_ACCURACY = "75%";
		BLOCK_CHANCE_UP = 100;
		DMG_BLOCK_UP = 0.30f;
		BLOCK_CHANCE_DOWN = 25;
		SOUND_BLOCK = "debris/bustmetal1.wav";
	}

	// unnamed block (first think)
	void ShieldsLironshield_FirstThink()
	{
		SHIELD_HEALTH = "4000";
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Large Iron Shield");
		SetDescription("A large Iron shield");
		SetWeight(60);
		SetValue(2200);
		LegacyCommand("quality", 600);
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
		ShieldsLironshield_FirstThink();
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
		if (name == "shield_spawn") { OnShieldSpawn(); return true; }
		return ShieldsBaseScript::DispatchEvent(name, params);
	}
}
