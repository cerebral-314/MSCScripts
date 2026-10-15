#pragma context server

// Converted from items/polearms_har.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_har"]
class PolearmsHar : PolearmsBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	PolearmsHar()
	{
		BASE_LEVEL_REQ = "15";
		VMODEL_IDX = 9;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 5;
		PMODEL_IDX_HANDS = 4;
		MELEE_DMG = 220;
		MELEE_RANGE = "120";
		MELEE_DMG_TYPE = "pierce";
		MELEE_ACCURACY = "95%";
		POLE_MIN_RANGE = 70;
		POLE_MAX_DMG_MULTI = 1.75f;
		POLE_CAN_SWIPE = false;
		POLE_CAN_BLOCK = false;
		POLE_CAN_SPIN = false;
		POLE_CAN_REPEL = false;
		POLE_CAN_BACKHAND = false;
		POLE_CAN_THROW = true;
		SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
		SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
		POLE_THROW_POWER = 800;
		POLE_THOW_PROJECTILE = "proj_pole_harpoon";
		POLE_THROW_RECHARGE_TIME = 2.0f;
		POLE_THROW_MAX_CHARGE_TIME = 4.0f;
		SOUND_THROW = "weapons/swinghuge.wav";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Harpoon");
		SetDescription("A heavy throwing spear");
		SetWeight(10);
		SetValue(1000);
		SetHudSprite("trade", "186");
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
