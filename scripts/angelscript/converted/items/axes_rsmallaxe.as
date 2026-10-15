#pragma context server

// Converted from items/axes_rsmallaxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_onehanded.as"

[script "items/axes_rsmallaxe"]
class AxesRsmallaxe : AxesBaseOnehandedScript
{
	// Variables declared by included files, with the value they start with in this script
	AxesRsmallaxe()
	{
		MODEL_VIEW = "viewmodels/v_1haxes.mdl";
		MODEL_VIEW_IDX = 1;
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "98";
		ANIM_PREFIX = "rustedaxe";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 100;
		MELEE_DMG_RANGE = 80;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "70%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "5%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Rusted Axe");
		SetDescription("The rusted core makes the axe lighter and easier to swing, but less damaging");
		SetWeight(10);
		SetValue(3);
		SetHudSprite("hand", "176");
		SetHudSprite("trade", "176");
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
