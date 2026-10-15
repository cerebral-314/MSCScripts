#pragma context server

// Converted from items/crest_tfl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_tfl"]
class CrestTfl : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestTfl()
	{
		MODEL_CREST_OFS = 21;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Crest of TFL");
		SetDescription("For those who have fallen, and can't get up");
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
