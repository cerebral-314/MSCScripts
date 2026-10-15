#pragma context server

// Converted from items/blunt_ms3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_ms3"]
class BluntMs3 : BluntBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";
	int MODEL_VIEW_IDX = 7;

	// Variables declared by included files, with the value they start with in this script
	BluntMs3()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "87";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 8.0f;
		MELEE_DMG = 250;
		MELEE_DMG_RANGE = 140;
		MELEE_ACCURACY = "80%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Fine Morning Star");
		SetDescription("A masterfully crafted morning star");
		SetWeight(35);
		SetValue(1500);
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
