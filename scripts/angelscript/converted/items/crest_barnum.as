#pragma context server

// Converted from items/crest_barnum.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_barnum"]
class CrestBarnum : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestBarnum()
	{
		MODEL_CREST_OFS = 26;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Crest of P. T. Barnum");
		SetDescription("The Greatest Showman on Earth");
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
