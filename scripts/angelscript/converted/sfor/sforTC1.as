#pragma context server

// Converted from sfor/sforTC1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "sfor/sforTC1"]
class SforTC1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 50));

		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "item_ring", 1, 0);
		// addstoreitem  STORENAME     armor_leather_studded 	1        0
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);

		if (RandomInt(1, 4) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 4) == 1)
			OnAddGreatItem();

		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "proj_bolt_steel", 25, 0, 0, 25);
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
