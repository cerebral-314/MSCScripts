#pragma context server

// Converted from keledrosprelude/troll_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "keledrosprelude/troll_chest"]
class TrollChest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(50, 100));
		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "health_mpotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "scroll2_frost_xolt", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_iceblade", 1, 0);

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "scroll2_blizzard", 1, 0);
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
