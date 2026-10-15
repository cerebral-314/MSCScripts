#pragma context server

// Converted from chests/m2_quest2_extra.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/m2_quest2_extra"]
class M2Quest2Extra : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		OnAddNoobItem();
		OnAddGoodItem();
		int nplayers = ActivePlayerCount();
		if (nplayers > 2)
			OnAddGreatItem();
		if (nplayers > 4)
			OnAddGreatItem();
		if (RandomInt(1, 5) < nplayers)
			OnAddNoobArrows();
		float goldAmt = nplayers * 25.0f;
		OnAddGold(goldAmt);
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
