#pragma context server

// Converted from daragoth/scorp_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "daragoth/scorp_chest"]
class ScorpChest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(50, 300));
		AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
		AddStoreItem(STORENAME, "smallarms_royaldagger", 1, 0);
		AddStoreItem(STORENAME, "blunt_greatmaul", 1, 0);
		AddStoreItem(STORENAME, "axes_poison1", 1, 0);

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "mana_protection", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "armor_helm_knight", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
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
