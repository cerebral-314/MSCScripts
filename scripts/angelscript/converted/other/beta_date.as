#pragma context server

// Converted from other/beta_date.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "other/beta_date"]
class OtherBetaDate : ScriptEntity
{
	// }
	void OnUnnamed()
	{
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "}") { OnUnnamed(); return true; }
		return false;
	}
}
