#pragma context server

// Converted from items/blunt_calrianmace.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_calrianmace"]
class BluntCalrianmace : BluntBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	int MODEL_VIEW_IDX = 3;

	// Variables declared by included files, with the value they start with in this script
	BluntCalrianmace()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_BODY_OFS = "56";
		ANIM_PREFIX = "warhammer";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 8.0f;
		MELEE_DMG = 230;
		MELEE_DMG_RANGE = 140;
		MELEE_ACCURACY = "75%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Calrian's Mace");
		SetDescription("A one-handed mace previously used by Lord Calrian");
		SetWeight(35);
		SetValue(1000);
		SetHudSprite("hand", "98");
		SetHudSprite("trade", "98");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
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
