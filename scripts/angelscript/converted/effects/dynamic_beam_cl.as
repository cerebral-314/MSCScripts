#pragma context server

// Converted from effects/dynamic_beam_cl.script by msc_transpiler.
// beam that can be positioned client side

#include "runtime/ScriptEntity.as"

[script "effects/dynamic_beam_cl"]
class DynamicBeamCl : ScriptEntity
{
	// effect_die
	void OnEffectDie()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		return false;
	}
}
