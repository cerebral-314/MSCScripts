#pragma context server

// Converted from chests/rand_good.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/rand_good"]
class RandGood : BaseTreasurechestScript
{
	// Constants
	string ITEM_EVENT = "add_good_item";

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		OnAddGold(10.0f);
		CallEventOrDelay(ITEM_EVENT, 100);

		int nPlayers = ActivePlayerCount();
		if (!(nPlayers > 1))
			return;
		if (nPlayers > 4)
			nPlayers = 4;
		for (int i = 0; i < nPlayers; i++)
		{
			loopIteration = i;
			OnAddExtraItems();
		}
	}

	// add_extra_items
	void OnAddExtraItems()
	{
		CallEventOrDelay(ITEM_EVENT, 100);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnItemEvent() {} // ITEM_EVENT

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_extra_items") { OnAddExtraItems(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
