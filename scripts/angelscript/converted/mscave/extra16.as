#pragma context server

// Converted from mscave/extra16.script by msc_transpiler.
// requires killing a fairly sploitable orc brawler

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/extra16"]
class Extra16 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(50, 80));

		OnAddGreatItem();

		if (RandomInt(1, 3) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 3) == 1)
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
