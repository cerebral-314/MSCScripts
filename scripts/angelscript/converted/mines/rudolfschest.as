#pragma context server

// Converted from mines/rudolfschest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mines/rudolfschest"]
class MinesRudolfschest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "blunt_rudolfsmace", 1, 0);
		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "proj_arrow_gholy", 15, 0, 0, 15);
		AddStoreItem(STORENAME, "proj_bolt_wooden", 50, 0, 0, 25);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "proj_bolt_iron", 25, 0, 0, 25);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
