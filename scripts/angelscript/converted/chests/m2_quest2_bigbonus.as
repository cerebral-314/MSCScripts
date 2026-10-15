#pragma context server

// Converted from chests/m2_quest2_bigbonus.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/m2_quest2_bigbonus"]
class M2Quest2Bigbonus : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddNoobItem();
		OnAddNoobItem();
		OnAddGoodItem();
		OnAddGoodItem();
		OnAddGoodItem();
		OnAddGoodItem();
		if (ActivePlayerCount() > 2)
			OnAddGreatItem();
		if (ActivePlayerCount() > 4)
			OnAddGreatItem();
		OnAddGold(200.0f);
		AddStoreItem(STORENAME, "proj_arrow_blunt", 45, 0, 0, 15);
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
