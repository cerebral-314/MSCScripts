#pragma context server

// Converted from chests/chapel1.script by msc_transpiler.
// Chest near orc archers

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/chapel1"]
class Chapel1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(10.0f);
		OnAddNoobItem();

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "proj_arrow_fire", 30, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_broadhead", 30, 0, 0, 30);

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "proj_arrow_holy", 30, 0, 0, 30);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "bows_longbow", 1, 0);
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
