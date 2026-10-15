#pragma context server

// Converted from items/crest_hod.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_hod"]
class CrestHod : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestHod()
	{
		MODEL_CREST_OFS = 28;
	}

	// crest_spawn
	void OnCrestSpawn()
	{
		SetName("Heroes of Dawn Crest");
		SetDescription("For those who are part of the Heroes of Dawn");
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
