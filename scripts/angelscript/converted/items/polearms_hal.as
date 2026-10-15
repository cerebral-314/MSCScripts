#pragma context server

// Converted from items/polearms_hal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_hal"]
class PolearmsHal : PolearmsBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	PolearmsHal()
	{
		BASE_LEVEL_REQ = "9";
		VMODEL_IDX = 10;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 3;
		PMODEL_IDX_HANDS = 2;
		MELEE_DMG = 200;
		MELEE_RANGE = "120";
		MELEE_DMG_TYPE = "pierce";
		POLE_MAX_DMG_MULTI = 2.0f;
		POLE_CAN_SPIN = false;
		POLE_SWIPE_DMG = 190;
		POLE_SWIPE_DMG_TYPE = "slash";
		POLE_SWIPE_RANGE = 80;
		POLE_SWIPE_ACCURACY = "70%";
		VANIM_SWIPE2 = 7;
		POLE_BACKHAND_DMG = 200;
		POLE_BACKHAND_ACCURACY = "90%";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Halberd");
		SetDescription("The dynamic military stand by");
		SetWeight(30);
		SetValue(50);
		SetHudSprite("trade", "179");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_polearms.mdl");
		Precache("weapons/polearm_spin.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "polearm_spawn") { OnPolearmSpawn(); return true; }
		return PolearmsBaseScript::DispatchEvent(name, params);
	}
}
