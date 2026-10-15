#pragma context server

// Converted from a3/nightmare_a3TC5.script by msc_transpiler.
// Treasure Chest #5 in A3 - In the cave.  You must kill 4 skeletons.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/nightmare_a3TC5"]
class NightmareA3TC5 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(RandomInt(10, 20));

		// |Store name|  |Item name|  		|Quantity| |cost|
		AddStoreItem(STORENAME, "blunt_maul", RandomInt(0, 1), 0);
		AddStoreItem(STORENAME, "bows_shortbow", RandomInt(0, 1), 0);
		AddStoreItem(STORENAME, "proj_arrow_poison", 30, 0, 0, 15);

		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 5) == 1)
			OnAddGreatItem();
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
