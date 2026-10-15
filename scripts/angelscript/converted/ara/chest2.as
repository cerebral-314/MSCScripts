#pragma context server

// Converted from ara/chest2.script by msc_transpiler.
// rat chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "ara/chest2"]
class AraChest2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(10, 100));

		OnAddGoodItem();

		if (RandomInt(0, 1) != 0)
			OnAddGoodItem();
		if (RandomInt(0, 1) != 0)
			OnAddGoodItem();

		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 4) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 4) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 5) == 1)
			OnAddGreatItem();

		if (RandomInt(1, 6) == 1)
			OnAddGreatItem();

		if (RandomInt(1, 7) == 1)
			OnAddGreatItem();
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
