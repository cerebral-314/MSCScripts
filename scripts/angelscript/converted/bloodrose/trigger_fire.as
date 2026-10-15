#pragma context server

// Converted from bloodrose/trigger_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/bloodrose/trigger_base.as"

[script "bloodrose/trigger_fire"]
class TriggerFire : BloodroseTriggerBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	TriggerFire()
	{
		ELEMENT_TYPE = "fire";
	}

	// unnamed block (first think)
	void TriggerFire_FirstThink()
	{
		SetGlobal("FIRE_TRIG", 0);
	}

	// trigger_spawn
	void OnTriggerSpawn()
	{
		SetName("Elemental Shard of Fire");

		SetDamageTaken("lightning", 0);
		SetDamageTaken("fire", 1);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("acid", 0);

		SetDamageTaken("slash", 0);
		SetDamageTaken("blunt", 0);
		SetDamageTaken("pierce", 0);
		SetDamageTaken("holy", 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TriggerFire_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "trigger_spawn") { OnTriggerSpawn(); return true; }
		return BloodroseTriggerBaseScript::DispatchEvent(name, params);
	}
}
