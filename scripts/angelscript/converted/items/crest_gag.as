#pragma context server

// Converted from items/crest_gag.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_gag"]
class CrestGag : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestGag()
	{
		MODEL_CREST_OFS = 13;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Crest of Helena");
		SetDescription("Congratulations! You survived Helena! :P");
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
