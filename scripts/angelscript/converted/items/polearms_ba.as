#pragma context server

// Converted from items/polearms_ba.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_ba"]
class PolearmsBa : PolearmsBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	PolearmsBa()
	{
		BASE_LEVEL_REQ = "6";
		VMODEL_IDX = 11;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 1;
		MELEE_DMG = 140;
		MELEE_RANGE = "110";
		MELEE_DMG_TYPE = "slash";
		POLE_CAN_SPIN = false;
		POLE_SWIPE_DMG = 190;
		POLE_SWIPE_DMG_TYPE = "slash";
		POLE_SWIPE_RANGE = 80;
		POLE_SWIPE_ACCURACY = "80%";
		VANIM_SWIPE2 = 7;
		POLE_BACKHAND_DMG = 80;
		POLE_BACKHAND_ACCURACY = "90%";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Bardiche");
		SetDescription("A polearm with a large cresent blade");
		SetWeight(30);
		SetValue(20);
		SetHudSprite("trade", "77");
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
