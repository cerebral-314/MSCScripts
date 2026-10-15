#pragma context server

// Converted from a3/TC_orcs.script by msc_transpiler.
// Thothie - Do not use random numbers for arrows, you will buggar the store
// Treasure chest after you kill all the orcs in a3 [random quest]

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "a3/TC_orcs"]
class TcOrcs : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		AddStoreItem(STORENAME, "health_mpotion", RandomInt(1, 6), 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "armor_leather", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "proj_arrow_jagged", 15, 0, 0, 15);

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "bows_swiftbow", 1, 0);
		else
			AddStoreItem(STORENAME, "bows_orcbow", 1, 0);
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
