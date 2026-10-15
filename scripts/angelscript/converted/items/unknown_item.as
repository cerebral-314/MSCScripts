#pragma context server

// Converted from items/unknown_item.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/unknown_item"]
class UnknownItem : BaseMiscitemScript
{
	// Constants
	string MODEL_HOLD = "misc/p_misc.mdl";

	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Unknown Item");
		SetDescription("This item doesn't exist under the server's current patch");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "miscitem_spawn") { OnMiscitemSpawn(); return true; }
		return BaseMiscitemScript::DispatchEvent(name, params);
	}
}
