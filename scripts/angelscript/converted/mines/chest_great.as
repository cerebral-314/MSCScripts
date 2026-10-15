#pragma context server

// Converted from mines/chest_great.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mines/chest_great"]
class MinesChestGreat : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// |Store name|  |Item name|      |Quantity| |cost|
		OnAddGold(RandomInt(5, 25));

		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "health_apple", 1, 0);

		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORENAME, "blunt_hammer1", 1, 0);

		int chance = RandomInt(1, 100);
		if (chance < 5)
			AddStoreItem(STORENAME, "swords_katana4", 1, 0);
		else if (chance < 10)
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
		else if (chance < 25)
			AddStoreItem(STORENAME, "swords_katana2", 1, 0);
		else if (chance < 50)
			AddStoreItem(STORENAME, "swords_katana", 1, 0);
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
