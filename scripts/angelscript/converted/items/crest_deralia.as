#pragma context server

// Converted from items/crest_deralia.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_deralia"]
class CrestDeralia : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestDeralia()
	{
		MODEL_CREST_OFS = 20;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Crest of Deralia");
		SetValue(50000);
		SetDescription("Crest worn by the wealthiest the aristocrats of Deralia");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "crest_spawn") { OnCrestSpawn(); return true; }
		return BaseCrestScript::DispatchEvent(name, params);
	}
}
