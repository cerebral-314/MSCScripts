#pragma context server

// Converted from items/blunt_hammer2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_hammer2"]
class BluntHammer2 : BluntBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "3";
	int MODEL_VIEW_IDX = 2;

	// Variables declared by included files, with the value they start with in this script
	BluntHammer2()
	{
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_BODY_OFS = "65";
		ANIM_PREFIX = "hammer";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.2f;
		MELEE_ENERGY = 0.4f;
		MELEE_DMG = 120;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "70%";
		MELEE_PARRY_AUGMENT = "5%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Heavy Hammer");
		SetDescription("A large heavy Hammer");
		SetWeight(30);
		SetValue(15);
		// sethudsprite hand hammer
		SetHudSprite("trade", "26");
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
