#pragma context server

// Converted from items/polearms_qs.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/polearms_base.as"

[script "items/polearms_qs"]
class PolearmsQs : PolearmsBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	PolearmsQs()
	{
		BASE_LEVEL_REQ = "0";
		VMODEL_IDX = 1;
		PMODEL_FILE = "weapons/p_weapons3.mdl";
		PMODEL_IDX_FLOOR = 61;
		PMODEL_IDX_HANDS = 62;
		MELEE_ACCURACY = "85%";
		POLE_BACKHAND_DMG = 90;
		POLE_BACKHAND_REPEL = 100;
		POLE_BACKHAND_STUN = true;
		POLE_BACKHAND_STUN_CHANCE = "35%";
	}

	// polearm_spawn
	void OnPolearmSpawn()
	{
		SetName("Quarterstaff");
		SetDescription("A heavy staff reinforced with iron");
		SetWeight(3);
		SetValue(5);
		SetHudSprite("trade", "139");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
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
