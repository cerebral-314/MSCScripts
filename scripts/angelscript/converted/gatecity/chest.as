#pragma context server

// Converted from gatecity/chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "gatecity/chest"]
class GatecityChest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 12));
		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);
		AddStoreItem(STORENAME, "axes_axe", 1, 0);
		AddStoreItem(STORENAME, "swords_longsword", 1, 0);
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "scroll_summon_rat", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "sheath_back_snakeskin", 1, 0);
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
