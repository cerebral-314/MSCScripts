#pragma context server

// Converted from bloodrose/trigger_monitor.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "bloodrose/trigger_monitor"]
class TriggerMonitor : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ ATHOLO_ID = null;
	bool MON_DONE = false;
	bool COLD_ON = false;
	bool FIRE_ON = false;
	bool POISON_ON = false;
	bool LIGHTNING_ON = false;

	// unnamed block (first think)
	void TriggerMonitor_FirstThink()
	{
		SetGlobal("COLD_TRIG", 0);
		SetGlobal("FIRE_TRIG", 0);
		SetGlobal("LIGHTNING_TRIG", 0);
		SetGlobal("POISON_TRIG", 0);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("ele_monitor");

		SetModel("null.mdl");

		SetInvincible(true);
		SetFly(true);
		SetRoam(false);
		SetMoveSpeed(0);
		SetRace("beloved");
		CallEventDelayed(1.0f, "monitor_triggers");
	}

	// monitor_triggers
	void OnMonitorTriggers()
	{
		// local FOUR_TRIGS 0
		// add FOUR_TRIGS COLD_TRIG
		// add FOUR_TRIGS FIRE_TRIG
		// add FOUR_TRIGS LIGHTNING_TRIG
		// add FOUR_TRIGS POISON_TRIG
		// if ( FOUR_TRIGS == 4 )
		// {
		// setvard ATHOLO_ID $get_by_name(boss_atholo)
		// callexternal ATHOLO_ID vulnerable
		// usetrigger monitor_triggered
		// }
		float fourTrigs = (COLD_ON ? 1.0f : 0.0f) + (FIRE_ON ? 1.0f : 0.0f) + (POISON_ON ? 1.0f : 0.0f);
		fourTrigs += (LIGHTNING_ON ? 1.0f : 0.0f);

		if (fourTrigs == 4.0f)
		{
			@ATHOLO_ID = FindByName("boss_atholo");
			CallExternal(ATHOLO_ID, "vulnerable");
			UseTrigger("monitor_triggered");
			CallExternal("all", "element_trigs_remove");
			MON_DONE = true;
		}

		if (MON_DONE)
			return;
		CallEventDelayed(0.5f, "monitor_triggers");
	}

	// trigger_on
	// PARAM1 = type
	void OnTriggerOn(string type = "")
	{
		if (type == "cold")
			COLD_ON = true;
		if (type == "fire")
			FIRE_ON = true;
		if (type == "poison")
			POISON_ON = true;
		if (type == "lightning")
			LIGHTNING_ON = true;
	}

	// trigger_off
	// PARAM1 = type
	void OnTriggerOff(string type = "")
	{
		if (type == "cold")
			COLD_ON = false;
		if (type == "fire")
			FIRE_ON = false;
		if (type == "poison")
			POISON_ON = false;
		if (type == "lightning")
			LIGHTNING_ON = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TriggerMonitor_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "monitor_triggers") { OnMonitorTriggers(); return true; }
		if (name == "trigger_off") { OnTriggerOff(Param(params, 0)); return true; }
		if (name == "trigger_on") { OnTriggerOn(Param(params, 0)); return true; }
		return false;
	}
}
