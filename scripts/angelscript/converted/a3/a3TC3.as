#pragma context server

// Converted from a3/a3TC3.script by msc_transpiler.
// Treasure Chest #3 in A3 - In Olof's basement

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/a3TC3"]
class A3TC3 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));

		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "drink_ale", 2, 0);
		AddStoreItem(STORENAME, "drink_mead", 1, 0);

		// addstoreitem  STORENAME   item_key_rusty    1 	        0
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "swords_skullblade", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "swords_skullblade2", 1, 0);
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
