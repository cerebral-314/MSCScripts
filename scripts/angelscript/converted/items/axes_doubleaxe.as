#pragma context server

// Converted from items/axes_doubleaxe.script by msc_transpiler.
// Thothie - wrong trade sprite
// Double Axe

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_onehanded.as"

[script "items/axes_doubleaxe"]
class AxesDoubleaxe : AxesBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "12";

	// Variables declared by included files, with the value they start with in this script
	AxesDoubleaxe()
	{
		MODEL_VIEW = "viewmodels/v_1haxes.mdl";
		MODEL_VIEW_IDX = 3;
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "89";
		ANIM_PREFIX = "smallaxe";
		MELEE_RANGE = "35";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.4f;
		MELEE_DMG = 140;
		MELEE_DMG_RANGE = 75;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "80%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Dwarven Axe");
		SetDescription("A double-bladed one-handed Axe");
		SetWeight(10);
		SetValue(250);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "177"); // Thothie - doubleaxe is non-exstant sprite, causes crash
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1haxes.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseOnehandedScript::DispatchEvent(name, params);
	}
}
