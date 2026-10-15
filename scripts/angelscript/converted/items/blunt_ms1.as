#pragma context server

// Converted from items/blunt_ms1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_ms1"]
class BluntMs1 : BluntBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "10";
	int MODEL_VIEW_IDX = 7;

	// Variables declared by included files, with the value they start with in this script
	BluntMs1()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "87";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 8.0f;
		MELEE_DMG = 200;
		MELEE_DMG_RANGE = 140;
		MELEE_ACCURACY = "70%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Rusty Morning Star");
		SetDescription("This morning star has seen better days");
		SetWeight(35);
		SetValue(750);
		SetHudSprite("hand", "mace");
		SetHudSprite("trade", "187");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
