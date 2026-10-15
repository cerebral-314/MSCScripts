#pragma context server

// Converted from items/crest_tdk.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_tdk"]
class CrestTdk : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestTdk()
	{
		MODEL_CREST_OFS = 29;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("The Dragonknight Crest");
		SetDescription("Official Crest of the Dragonknights");
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
