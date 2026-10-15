#pragma context server

// Converted from calruin/TC_fangtooth.script by msc_transpiler.
// Thothie - Making arrows non-random in my attempts to fix 'arrows from chest' bug.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "calruin/TC_fangtooth"]
class TcFangtooth : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(3, 9));

		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "health_lpotion", RandomInt(1, 5), 0);
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_fire", 60, 0, 0, 30);
		OnAddrandomitems();
	}

	// addrandomitems
	void OnAddrandomitems()
	{
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "axes_scythe", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "blunt_greatmaul", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "addrandomitems") { OnAddrandomitems(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
