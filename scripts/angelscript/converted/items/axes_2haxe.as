#pragma context server

// Converted from items/axes_2haxe.script by msc_transpiler.
// Two handed Axe

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

[script "items/axes_2haxe"]
class Axes2haxe : AxesBaseTwohandedScript
{
	// Constants
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;

	// Variables declared by included files, with the value they start with in this script
	Axes2haxe()
	{
		BASE_LEVEL_REQ = "9";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxes.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "83";
		ANIM_PREFIX = "axe";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.2f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 190;
		MELEE_DMG_RANGE = 150;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "65%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "10%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Two-handed Axe");
		SetDescription("A light two-handed axe");
		SetWeight(50);
		SetValue(135);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "axe");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_2haxes.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
