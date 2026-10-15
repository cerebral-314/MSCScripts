#pragma context server

// Converted from a3/nightmare_a3TC2.script by msc_transpiler.
// Treasure Chest #2 in A3 - Lies at a pool

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/nightmare_a3TC2"]
class NightmareA3TC2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(20, 100));

		// |Store name|  |Item name|  		|Quantity| |cost|
		AddStoreItem(STORENAME, "pack_archersquiver", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_poison", 30, 0, 0, 15);

		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "proj_arrow_gpoison", 15, 0, 0, 15);
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
