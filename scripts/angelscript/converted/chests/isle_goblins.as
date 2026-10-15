#pragma context server

// Converted from chests/isle_goblins.script by msc_transpiler.
// Goblin chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/isle_goblins"]
class IsleGoblins : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(100.0f);

		if (RandomInt(1, 2) == 1)
			OnAddNoobItem();
		if (RandomInt(1, 2) == 1)
			OnAddNoobItem();
		if (RandomInt(1, 2) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 2) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 2) == 1)
			OnAddGoodItem();

		int rndArrow = RandomInt(1, 4);
		if (rndArrow == 1)
			AddStoreItem(STORENAME, "proj_arrow_broadhead", 60, 0, 0, 60);
		if (rndArrow == 2)
			AddStoreItem(STORENAME, "proj_arrow_fire", 60, 0, 0, 60);
		if (rndArrow == 3)
			AddStoreItem(STORENAME, "proj_arrow_jagged", 60, 0, 0, 60);
		if (rndArrow == 4)
			AddStoreItem(STORENAME, "proj_arrow_poison", 60, 0, 0, 60);
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
