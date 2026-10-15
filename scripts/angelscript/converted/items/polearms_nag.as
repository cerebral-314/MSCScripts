#pragma context server

// Converted from items/polearms_nag.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_nag"]
class PolearmsNag : PolearmsBaseScript
{
	// Constants
	bool POLE_PRIMARY_SWIPE = true;

	// Variables declared by included files, with the value they start with in this script
	PolearmsNag()
	{
		BASE_LEVEL_REQ = "18";
		VMODEL_IDX = 7;
		PMODEL_FILE = "weapons/p_weapons4.mdl";
		PMODEL_IDX_FLOOR = 9;
		PMODEL_IDX_HANDS = 8;
		MELEE_DMG = 250;
		MELEE_DMG_TYPE = "slash";
		MELEE_ATK_DURATION = 0.9f;
		POLE_MIN_RANGE = 40;
		POLE_MIN_DMG_MULTI = 0.75f;
		POLE_MAX_DMG_MULTI = 1.25f;
		POLE_BLOCK_DELAY = 1.0f;
		POLE_CAN_POKE1 = false;
		POLE_CAN_SWIPE = false;
		POLE_CAN_SPIN = false;
		POLE_BACKHAND_DMG = 150;
		POLE_BACKHAND_ACCURACY = "90%";
		POLE_BACKHAND_STUN = true;
		POLE_BACKHAND_STUN_CHANCE = "100%";
		POLE_BACKHAND_REPEL = 500;
		SOUND_HITWALL1 = "weapons/cbar_hit1.wav";
		SOUND_HITWALL2 = "weapons/cbar_hit2.wav";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Elven Glaive");
		SetDescription("A long handled blade for fighting groups of opponents");
		SetWeight(60);
		SetValue(1500);
		SetHudSprite("trade", "182");
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
