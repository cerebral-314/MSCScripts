#pragma context server

// Converted from items/crest_pirates.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_pirates"]
class CrestPirates : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestPirates()
	{
		MODEL_CREST_OFS = 4;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Crest of The Pirates");
		SetDescription("The crest worn by the members of The Pirates");
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
