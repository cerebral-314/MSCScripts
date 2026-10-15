#pragma context server

// Converted from items/polearms_sp.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_sp"]
class PolearmsSp : PolearmsBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	PolearmsSp()
	{
		BASE_LEVEL_REQ = "3";
		VMODEL_IDX = 8;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 7;
		PMODEL_IDX_HANDS = 6;
		MELEE_DMG = 160;
		MELEE_RANGE = "110";
		MELEE_DMG_TYPE = "pierce";
		POLE_MIN_RANGE = 70;
		POLE_MAX_DMG_MULTI = 1.65f;
		POLE_CAN_SWIPE = false;
		POLE_CAN_BLOCK = false;
		POLE_CAN_SPIN = false;
		POLE_CAN_REPEL = false;
		POLE_CAN_BACKHAND = false;
		POLE_CAN_THROW = true;
		SOUND_HITWALL1 = "weapons/dagger/daggermetal1.wav";
		SOUND_HITWALL2 = "weapons/dagger/daggermetal2.wav";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Spear");
		SetDescription("A sturdy throwing spear");
		SetWeight(10);
		SetValue(20);
		SetHudSprite("trade", "181");
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
