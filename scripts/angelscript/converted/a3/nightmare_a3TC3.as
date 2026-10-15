#pragma context server

// Converted from a3/nightmare_a3TC3.script by msc_transpiler.
// Treasure Chest #3 in A3 - In Olof's basement

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/nightmare_a3TC3"]
class NightmareA3TC3 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// |Store name|  |Item name|  	|Quantity| |cost|
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "drink_ale", 1, 0);
		AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
		AddStoreItem(STORENAME, "swords_skullblade4", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "scroll2_turn_undead", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "scroll2_summon_undead", 1, 0);
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
