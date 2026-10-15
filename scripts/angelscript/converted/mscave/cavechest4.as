#pragma context server

// Converted from mscave/cavechest4.script by msc_transpiler.
// Thothie - Fixed chest, slight nerf on 23/Jun/2006 16:09 to stop multi-high end swords in one chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest4"]
class Cavechest4 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));
		// |Store name|  |Item name|  	|Quantity| |cost|
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "swords_shortsword", 1, 0);
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "axes_axe", 1, 0);
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "axes_battleaxe", 1, 0);
		// addstoreitem  STORENAME		armor_plate		1          0
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "smallarms_dagger", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_katana", 1, 0);
		else if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		else if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
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
