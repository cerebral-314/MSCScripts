#pragma context server

// Converted from a3/a3TC2.script by msc_transpiler.
// Treasure Chest #2 in A3 - Lies at a pool

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/a3TC2"]
class A3TC2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(17, 30));

		// |Store name|  |Item name|  		|Quantity| |cost|
		AddStoreItem(STORENAME, "axes_axe", 1, 0);
		AddStoreItem(STORENAME, "health_lpotion", 1, 0);
		float arrowQuant = 30.0f * RandomInt(1, 2);
		AddStoreItem(STORENAME, "proj_arrow_silvertipped", arrowQuant, 0, 0, 30);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "pack_archersquiver", 1, 0);
		if (RandomInt(1, 5) == 1)
			OnAddNoobItem();
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
