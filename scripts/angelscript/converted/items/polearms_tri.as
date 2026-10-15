#pragma context server

// Converted from items/polearms_tri.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_tri"]
class PolearmsTri : PolearmsBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	PolearmsTri()
	{
		BASE_LEVEL_REQ = "11";
		VMODEL_IDX = 6;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 11;
		PMODEL_IDX_HANDS = 10;
		MELEE_DMG = 200;
		MELEE_RANGE = "110";
		MELEE_DMG_TYPE = "pierce";
		POLE_CAN_SWIPE = false;
		POLE_CAN_SPIN = false;
		POLE_CAN_BACKHAND = false;
		POLE_CAN_POWER_THROW = true;
		POLE_THROW_POWER = 800;
		POLE_THOW_PROJECTILE = "proj_pole_trident";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Trident");
		SetDescription("A three pronged military fork");
		SetWeight(10);
		SetValue(400);
		SetHudSprite("trade", "183");
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
