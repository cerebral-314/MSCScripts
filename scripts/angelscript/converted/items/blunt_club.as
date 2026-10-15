#pragma context server

// Converted from items/blunt_club.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_club"]
class BluntClub : BluntBaseTwohandedScript
{
	// Constants
	int ANIM_ATTACK4 = 5;
	int ANIM_ATTACK5 = 6;
	int MODEL_VIEW_IDX = 2;

	// Variables declared by included files, with the value they start with in this script
	BluntClub()
	{
		ANIM_SHEATH = 1;
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_BODY_OFS = "59";
		ANIM_PREFIX = "club";
		MELEE_RANGE = "90";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 100;
		MELEE_DMG_RANGE = 60;
		MELEE_ACCURACY = "50%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("Wooden Club");
		SetDescription("A big wooden club");
		SetWeight(10);
		SetValue(10);
		SetHudSprite("hand", "club");
		SetHudSprite("trade", "73");
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
