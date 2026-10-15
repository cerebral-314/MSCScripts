#pragma context server

// Converted from items/item_eh.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

[script "items/item_eh"]
class ItemEh : BaseMiscitemScript
{
	// miscitem_spawn
	void OnMiscitemSpawn()
	{
		SetName("Efreeti Heart");
		SetDescription("The heart of a being containing a fire elemental");
		SetValue(0);
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
