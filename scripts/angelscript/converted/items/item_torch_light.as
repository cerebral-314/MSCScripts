#pragma context server

// Converted from items/item_torch_light.script by msc_transpiler.
// Thothie - this script was generating lots of errors due to syntax problems, simplified and fixed

#include "runtime/ScriptEntity.as"
#include "converted/items/base_lighted.as"

[script "items/item_torch_light"]
class ItemTorchLight : BaseLightedScript
{
	// remove_me
	// { worldevent_time
	// debugprint Daystate clglobal.daystate
	// setvard LIGHT_RADIUS 128
	// if ( clglobal.daystate equals night ) setvard LIGHT_RADIUS 256
	// }
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return BaseLightedScript::DispatchEvent(name, params);
	}
}
