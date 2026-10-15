#pragma context server

// Converted from monsters/summon/barrier_cl.script by msc_transpiler.
// ========== CLIENT

#include "runtime/ScriptEntity.as"

[script "monsters/summon/barrier_cl"]
class BarrierCl : ScriptEntity
{
	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		return false;
	}
}
