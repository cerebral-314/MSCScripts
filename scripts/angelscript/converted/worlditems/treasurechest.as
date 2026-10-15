#pragma context server

// Converted from worlditems/treasurechest.script by msc_transpiler.
// Thothie - For compatability, but it's virtually empty.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "worlditems/treasurechest"]
class Treasurechest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(420.0f);
		OnAddNoobPot();
		OnAddGoodPot();
		OnAddGreatPot();
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
