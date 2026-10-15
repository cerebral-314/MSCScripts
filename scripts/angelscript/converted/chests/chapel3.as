#pragma context server

// Converted from chests/chapel3.script by msc_transpiler.
// Final chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/chapel3"]
class Chapel3 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(100.0f);
		OnAddNoobItem();
		OnAddNoobItem();
		if (!(ActivePlayerCount() > 1))
			return;
		OnAddNoobItem();
		if (!(ActivePlayerCount() > 2))
			return;
		OnAddGoodItem();
		if (!(ActivePlayerCount() > 3))
			return;
		OnAddGreatItem();
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
