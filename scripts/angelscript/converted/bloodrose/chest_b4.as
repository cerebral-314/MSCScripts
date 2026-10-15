#pragma context server

// Converted from bloodrose/chest_b4.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/bloodrose/chest_b_base.as"

[script "bloodrose/chest_b4"]
class ChestB4 : ChestBBaseScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		ChestBBase_OnChestAdditems(); // bloodrose/chest_b_base
		AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);

		OnOfferFelewynSymbol(100);
		OnAddGreatItem();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return ChestBBaseScript::DispatchEvent(name, params);
	}
}
