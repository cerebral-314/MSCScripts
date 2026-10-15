#pragma context server

// Converted from daragoth/door.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "daragoth/door"]
class Door : ScriptEntity
{
	// alarm
	void OnAlarm()
	{
		LegacyCommand("emitsound", ENT_ME, Vector3(0, 0, 0), 10, 5, "combat");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "alarm") { OnAlarm(); return true; }
		return false;
	}
}
