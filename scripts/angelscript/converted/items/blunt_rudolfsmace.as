#pragma context server

// Converted from items/blunt_rudolfsmace.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_rudolfsmace"]
class BluntRudolfsmace : BluntBaseOnehandedScript
{
	// Constants
	int MODEL_VIEW_IDX = 3;

	// Variables declared by included files, with the value they start with in this script
	BluntRudolfsmace()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_BODY_OFS = "56";
		ANIM_PREFIX = "mace";
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 110;
		MELEE_ACCURACY = "75%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Odd Mace");
		SetDescription("An odd one-handed mace");
		SetWeight(35);
		SetValue(30);
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
