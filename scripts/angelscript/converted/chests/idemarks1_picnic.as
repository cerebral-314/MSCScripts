#pragma context server

// Converted from chests/idemarks1_picnic.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/idemarks1_picnic"]
class Idemarks1Picnic : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(400.0f);

		OnAddGreatItem();

		if (RandomInt(1, 3) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 3) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 3) == 1)
			OnAddEpicArrows();
		AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);

		AddStoreItem(STORENAME, "polearms_nag", 1, 0);
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
