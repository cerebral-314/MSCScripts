#pragma context server

// Converted from chests/idemarks1_dayvans_gold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/idemarks1_dayvans_gold"]
class Idemarks1DayvansGold : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(RandomInt(850, 2000));

		AddStoreItem(STORENAME, "item_crystal_return", 1, 0);

		if (RandomInt(1, 15) == 1)
		{
			AddStoreItem(STORENAME, "scroll_turn_undead", 1, 0);
			AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);
		}
		else
		{
			AddStoreItem(STORENAME, "scroll2_turn_undead", 1, 0);
		}

		OnAddEpicItem();
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
