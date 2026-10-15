#pragma context server

// Converted from bloodrose/trigger_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/bloodrose/trigger_base.as"

[script "bloodrose/trigger_lightning"]
class TriggerLightning : BloodroseTriggerBaseScript
{
	// Constants
	string MAX_HP = "9999";

	// Variables declared by included files, with the value they start with in this script
	TriggerLightning()
	{
		ELEMENT_TYPE = "lightning";
		RESET_DELAY = 20.0f;
	}

	// unnamed block (first think)
	void TriggerLightning_FirstThink()
	{
		SetGlobal("LIGHTNING_TRIG", 0);
	}

	// trigger_spawn
	void OnTriggerSpawn()
	{
		SetName("Elemental Shard of Lightning");

		SetDamageTaken("lightning", 1);
		SetDamageTaken("fire", 0);
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
		TriggerLightning_FirstThink();
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
