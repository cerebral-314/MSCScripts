#pragma context server

// Converted from bloodrose/trigger_cold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/bloodrose/trigger_base.as"

[script "bloodrose/trigger_cold"]
class TriggerCold : BloodroseTriggerBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	TriggerCold()
	{
		ELEMENT_TYPE = "cold";
	}

	// unnamed block (first think)
	void TriggerCold_FirstThink()
	{
		SetGlobal("COLD_TRIG", 0);
	}

	// trigger_spawn
	void OnTriggerSpawn()
	{
		SetName("Elemental Shard of Ice");

		SetDamageTaken("lightning", 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("acid", 0);

		SetDamageTaken("slash", 0);
		SetDamageTaken("blunt", 0);
		SetDamageTaken("pierce", 0);
		SetDamageTaken("holy", 0);
	}

	// freeze_solid
	void OnFreezeSolid()
	{
		TRIG_DELAY = true;
		SetGlobal("COLD_TRIG", 1);

		CallEventDelayed(RESET_DELAY, "trig_reset");
		UseTrigger(TRIGGER_STRING);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnResetDelay() {} // RESET_DELAY

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TriggerCold_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "freeze_solid") { OnFreezeSolid(); return true; }
		if (name == "trigger_spawn") { OnTriggerSpawn(); return true; }
		return BloodroseTriggerBaseScript::DispatchEvent(name, params);
	}
}
