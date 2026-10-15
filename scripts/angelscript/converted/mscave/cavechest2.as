#pragma context server

// Converted from mscave/cavechest2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest2"]
class Cavechest2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));

		// |Store name|  |Item name|  	|Quantity| |cost|
		// addstoreitem  STORENAME armor_leather_studded 	 1          0
		AddStoreItem(STORENAME, "sheath_belt", 1, 0);
		AddStoreItem(STORENAME, "smallarms_dagger", 1, 0);
		if (RandomInt(1, 3) != 1)
			return;
		AddStoreItem(STORENAME, "sheath_spellbook", 1, 0);
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
