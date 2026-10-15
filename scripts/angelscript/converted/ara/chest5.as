#pragma context server

// Converted from ara/chest5.script by msc_transpiler.
// Thothie - for the xbows, so we have some place to get them, should we ever get them working

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "ara/chest5"]
class AraChest5 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		AddStoreItem(STORENAME, "proj_bolt_wooden", 50, 0, 0, 50);
		AddStoreItem(STORENAME, "proj_bolt_iron", 50, 0, 0, 50);
		AddStoreItem(STORENAME, "proj_bolt_silver", 50, 0, 0, 50);
		AddStoreItem(STORENAME, "proj_bolt_fire", 50, 0, 0, 50);
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
