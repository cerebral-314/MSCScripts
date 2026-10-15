#pragma context server

// Converted from items/blunt_warhammer.script by msc_transpiler.
// Warhammer, re-added by Thothie, basing on Maul
// - No clue why we took this script out
// - we have a model AND a trade sprite already included! ><
// Magnus Damli -- As of August 2007
// The Dwarf equivialent to the human Mace.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_warhammer"]
class BluntWarhammer : BluntBaseTwohandedScript
{
	// Constants
	int MODEL_VIEW_IDX = 1;
	string BASE_LEVEL_REQ = "6";

	// Variables declared by included files, with the value they start with in this script
	BluntWarhammer()
	{
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_BODY_OFS = "80";
		ANIM_PREFIX = "warhammer";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.2f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 150;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "70%";
		MELEE_PARRY_AUGMENT = "5%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("War Hammer");
		SetDescription("A heavy war hammer");
		SetWeight(30);
		SetValue(45);
		SetHudSprite("hand", "70");
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
