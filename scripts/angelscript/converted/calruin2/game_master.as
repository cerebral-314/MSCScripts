#pragma context server

// Converted from calruin2/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "calruin2/game_master"]
class Calruin2GameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float TRIGGER_COUNT = 0.0f;

	// calruin2_trigger_touched
	void OnCalruin2TriggerTouched()
	{
		TRIGGER_COUNT += 1.0f;
		if (!(TRIGGER_COUNT > 1.0f))
			return;
		UseTrigger("combo_on");
		CallEventDelayed(30.0f, "calruin2_reset_triggers");
		TRIGGER_COUNT = 0.0f;
	}

	// calruin2_reset_triggers
	void OnCalruin2ResetTriggers()
	{
		CallExternal("all", "calruin2_trigger_reset");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "calruin2_reset_triggers") { OnCalruin2ResetTriggers(); return true; }
		if (name == "calruin2_trigger_touched") { OnCalruin2TriggerTouched(); return true; }
		return false;
	}
}
