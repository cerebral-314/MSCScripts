#pragma context server

// Converted from mscave/cavechest5.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest5"]
class Cavechest5 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));
		// |Store name|  |Item name|  	|Quantity| |cost|
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "swords_longsword", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "axes_smallaxe", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "blunt_maul", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "pack_archersquiver", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "bows_longbow", 1, 0);
		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "bows_swiftbow", 1, 0);
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
