#pragma context server

// Converted from a3/a3TC4.script by msc_transpiler.
// Treasure Chest #4 in A3 - By the portal

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/a3TC4"]
class A3TC4 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));

		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "item_book_old", 1, 0);

		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "blunt_club", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "swords_bastardsword", 1, 0);
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
