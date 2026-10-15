#pragma context server

// Converted from chests/rand_good_new.script by msc_transpiler.
// Creates one random good item for each player with qualifying HP, plus some pots and gold

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/rand_good_new"]
class RandGoodNew : BaseTreasurechestScript
{
	// Constants
	string ITEM_EVENT = "add_good_item";
	int HP_REQ = 200;
	int MAX_GOLD_AMT = 50;

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGoldByHp();
		CallEventOrDelay(ITEM_EVENT, 100, HP_REQ);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnItemEvent() {} // ITEM_EVENT
	void OnAddGoldByHp() {} // add_gold_by_hp

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
