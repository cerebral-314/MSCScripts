#pragma context server

// Converted from a3/nightmare_a3TC1.script by msc_transpiler.
// Treasure Chest #1 in A3 - Near the player start, on a platform

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/nightmare_a3TC1"]
class NightmareA3TC1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(20, 100));

		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "health_apple", 1, 0);
		AddStoreItem(STORENAME, "blunt_warhammer", 1, 0);
		AddStoreItem(STORENAME, "armor_plate", 1, 0);
		AddStoreItem(STORENAME, "scroll2_glow", 1, 0);
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
