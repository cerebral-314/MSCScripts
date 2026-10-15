#pragma context server

// Converted from daragoth/chest_great.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "daragoth/chest_great"]
class DaragothChestGreat : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(25, 35));

		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "scroll_ice_shield", 1, 0);
		AddStoreItem(STORENAME, "health_mpotion", 2, 0);

		if (RandomInt(1, 8) == 1)
		{
			AddStoreItem(STORENAME, "swords_skullblade4", 1, 0);
			AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
		}

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "armor_plate", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "shields_lironshield", 1, 0);
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
