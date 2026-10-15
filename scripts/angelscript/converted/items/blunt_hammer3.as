#pragma context server

// Converted from items/blunt_hammer3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_hammer3"]
class BluntHammer3 : BluntBaseTwohandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "9";
	int MODEL_VIEW_IDX = 1;

	// Variables declared by included files, with the value they start with in this script
	BluntHammer3()
	{
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_BODY_OFS = "80";
		ANIM_PREFIX = "warhammer";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.3f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 180;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "65%";
		MELEE_PARRY_AUGMENT = "10%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("Heavy War Hammer");
		SetDescription("A large heavy war hammer");
		SetWeight(50);
		SetValue(135);
		// sethudsprite hand hammer
		SetHudSprite("trade", "70");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
