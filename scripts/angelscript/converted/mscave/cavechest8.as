#pragma context server

// Converted from mscave/cavechest8.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest8"]
class Cavechest8 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));
		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "health_mpotion", 1, 0);
		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "swords_nkatana", 1, 0);
		AddStoreItem(STORENAME, "item_log", 1, 0);

		if (RandomInt(1, 25) == 1)
			OnAddGreatItem();

		if (RandomInt(1, 50) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 50) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 50) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 50) == 1)
			OnAddEpicArrows();
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
