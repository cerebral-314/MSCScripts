#pragma context server

// Converted from chests/hemlock_crulak.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/hemlock_crulak"]
class HemlockCrulak : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(4000, 5000));

		if (Truthy(ItemExists(CHEST_USER, "item_ring_ryza")) && GetQuestData(CHEST_USER, "manaring") == "0" && !Truthy(ItemExists(CHEST_USER, "item_ring_ryza_gem2")))
			AddStoreItem(STORENAME, "item_ring_ryza_gem2", 1, 0);

		OnAddGreatItem();
		OnAddEpicItem();
		OnAddEpicItem();
		OnAddEpicItem();

		OnAddEpicArrows();
		OnAddEpicArrows();
		if (RandomInt(1, 5) <= 1)
			OnAddEpicArrows();
		if (RandomInt(1, 5) <= 1)
			OnAddEpicArrows();
		if (RandomInt(1, 5) <= 1)
			OnAddEpicArrows();

		OnAddEpicPot();
		OnAddEpicPot();
		if (RandomInt(1, 5) <= 1)
			OnAddEpicPot();
		if (RandomInt(1, 5) <= 1)
			OnAddEpicPot();
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
