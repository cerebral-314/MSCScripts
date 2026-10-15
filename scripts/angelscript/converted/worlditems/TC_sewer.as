#pragma context server

// Converted from worlditems/TC_sewer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "worlditems/TC_sewer"]
class TcSewer : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(3, 20));
		OnAddNoobItem();

		// |Store name|  |Item name|  		|Quantity| |cost|
		AddStoreItem(STORENAME, "blunt_maul", RandomInt(0, 1), 0);
		AddStoreItem(STORENAME, "bows_shortbow", RandomInt(0, 1), 0);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "proj_arrow_broadhead", 60, 0, 0, 60);
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
