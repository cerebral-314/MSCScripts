#pragma context server

// Converted from calruin/chest_qspider.script by msc_transpiler.
// Thothie - DrKill says Arrows must be in multiples of 15, but this seems not to be the issue
// -Scewing with it...

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "calruin/chest_qspider"]
class ChestQspider : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(4, 10));
		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "health_lpotion", RandomInt(1, 5), 0);
		AddStoreItem(STORENAME, "item_torch", RandomInt(1, 2), 0);
		AddStoreItem(STORENAME, "swords_scimitar", 1, 0);
		AddStoreItem(STORENAME, "pack_archersquiver", 1, 0);
		AddStoreItem(STORENAME, "bows_longbow", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_jagged", 30, 0, 0, 15);

		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "bows_swiftbow", 1, 0);

		if (RandomInt(1, 25) != 1)
			return;
		AddStoreItem(STORENAME, "proj_arrow_gholy", 15, 0, 0, 15);
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
