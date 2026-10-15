#pragma context server

// Converted from mscave/cavechest10.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest10"]
class Cavechest10 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));
		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "proj_arrow_broadhead", 60, 0, 0, 15);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		if (RandomInt(1, 10) != 0)
			AddStoreItem(STORENAME, "proj_arrow_poison", 30, 0, 0, 30);
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
