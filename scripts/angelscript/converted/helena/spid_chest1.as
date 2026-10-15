#pragma context server

// Converted from helena/spid_chest1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "helena/spid_chest1"]
class SpidChest1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(25, 100));

		OnAddNoobItem();
		OnAddNoobItem();

		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 5) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_prot_spiders", 1, 0);
		if (RandomInt(1, 5) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "swords_spiderblade", 1, 0);
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
