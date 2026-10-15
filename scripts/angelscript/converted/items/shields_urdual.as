#pragma context server

// Converted from items/shields_urdual.script by msc_transpiler.
// Clunky shield of the beat bag

#include "runtime/ScriptEntity.as"
#include "converted/items/shields_base.as"

[script "items/shields_urdual"]
class ShieldsUrdual : ShieldsBaseScript
{
	// Constants
	string SHIELD_MAXHEALTH = "infinite";
	int EFFECT_RANGE = 150;

	// Variables (an unset .script variable reads as its own name)
	string SHIELD_HEALTH = "SHIELD_HEALTH";

	// Variables declared by included files, with the value they start with in this script
	ShieldsUrdual()
	{
		NOPUSH_CHANCE = "75%";
		PARRY_MULTI = 3.0f;
		SHIELD_BASE_PARRY = 40;
		MODEL_VIEW = "viewmodels/v_shields.mdl";
		MODEL_VIEW_IDX = 3;
		MODEL_BODY_OFS = "73";
		MELEE_ENERGY = 1.0f;
		MELEE_ACCURACY = "150%";
		BLOCK_CHANCE_UP = 100;
		DMG_BLOCK_UP = 0.05f;
		BLOCK_CHANCE_DOWN = 50;
		SHIELD_IMMORTAL = true;
		SOUND_BLOCK = "doors/doorstop5.wav";
	}

	// unnamed block (first think)
	void ShieldsUrdual_FirstThink()
	{
		SHIELD_HEALTH = "infinite";
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
		ShieldsBase_OnGameWear(race, gender, source); // items/shields_base
		OwnerMessage("You heft an Urdulian Shield onto your back.");
	}

	// bweapon_effect_activate
	// Slow activate
	void OnBweaponEffectActivate()
	{
		BaseItemExtras_OnBweaponEffectActivate(); // items/base_item_extras

		if (!Truthy(Eval("game.item.wielded")))
			return;
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		string scriptflag = ItemNameOf(ENT_ME);
		CallExternal(ENT_OWNER, "plr_change_speed", -1, 0.75f, scriptflag);
	}

	// bweapon_effect_remove
	// Remove slow effect
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		ShieldsBase_OnBweaponEffectRemove(reason); // items/shields_base
		string scriptflag = ItemNameOf(ENT_ME);
		CallExternal(ENT_OWNER, "plr_update_speed_effects", "remove", scriptflag);
	}

	// shield_spawn
	void OnShieldSpawn()
	{
		SetName("Urdulian Shield");
		SetDescription("A massive shield forged from the seal of a fallen temple of Urdual");
		SetWeight(200);
		SetValue(5000);
		LegacyCommand("quality", 2000);
		SetHudSprite("hand", "165");
		SetHudSprite("trade", "165");
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
		ShieldsUrdual_FirstThink();
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
		if (name == "bweapon_effect_activate") { OnBweaponEffectActivate(); return true; }
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "shield_spawn") { OnShieldSpawn(); return true; }
		return ShieldsBaseScript::DispatchEvent(name, params);
	}
}
