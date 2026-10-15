#pragma context server

// Converted from daragoth/chest_good.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "daragoth/chest_good"]
class DaragothChestGood : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(9, 20));
		// |Store name|	|Item name|      |Quantity|	|cost|
		AddStoreItem(STORENAME, "drink_mead", 5, 0);
		AddStoreItem(STORENAME, "health_apple", 8, 0);
		AddStoreItem(STORENAME, "axes_axe", 1, 0);
		AddStoreItem(STORENAME, "proj_bolt_iron", 25, 0, 0, 25);

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "shields_ironshield", 1, 0);

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "bows_longbow", 1, 0);

		int chance = RandomInt(1, 100);
		if (chance < 17)
		{
			AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
			if (chance >= 10)
				AddStoreItem(STORENAME, "smallarms_huggerdagger", 1, 0);
		}
		if (chance < 10 && chance >= 5)
			AddStoreItem(STORENAME, "smallarms_huggerdagger2", 1, 0);
		if (chance < 5 && chance > 2)
			AddStoreItem(STORENAME, "smallarms_huggerdagger3", 1, 0);
		if (chance <= 2)
			AddStoreItem(STORENAME, "smallarms_huggerdagger4", 1, 0);
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
