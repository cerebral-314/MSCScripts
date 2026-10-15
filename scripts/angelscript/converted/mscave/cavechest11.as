#pragma context server

// Converted from mscave/cavechest11.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest11"]
class Cavechest11 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// |Store name|  |Item name|  	|Quantity| |cost|
		OnAddGold(RandomInt(5, 20));
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);
		AddStoreItem(STORENAME, "smallarms_dirk", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "scroll2_summon_rat", 1, 0);
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
