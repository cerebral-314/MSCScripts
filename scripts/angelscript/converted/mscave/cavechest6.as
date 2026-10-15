#pragma context server

// Converted from mscave/cavechest6.script by msc_transpiler.
// Thothie - fixed chest, slight nerf on 23/Jun/2006 16:10 to stop multi-high end knives in one chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest6"]
class Cavechest6 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));
		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "smallarms_craftedknife2", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "smallarms_craftedknife4", 1, 0);

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "smallarms_craftedknife3", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "smallarms_craftedknife", 1, 0);
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
