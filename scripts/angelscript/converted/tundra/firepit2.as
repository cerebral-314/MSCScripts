#pragma context server

// Converted from tundra/firepit2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/tundra/base_firepit.as"

[script "tundra/firepit2"]
class Firepit2 : BaseFirepitScript
{
	// gave_torch
	void OnGaveTorch()
	{
		UseTrigger("fire2");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gave_torch") { OnGaveTorch(); return true; }
		return BaseFirepitScript::DispatchEvent(name, params);
	}
}
