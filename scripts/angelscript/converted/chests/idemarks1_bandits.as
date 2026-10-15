#pragma context server

// Converted from chests/idemarks1_bandits.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/idemarks1_bandits"]
class Idemarks1Bandits : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(400.0f);

		OnAddGoodItem();
		if (RandomInt(1, 4) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 4) == 1)
			OnAddGoodArrows();
		if (RandomInt(1, 4) == 1)
			OnAddGreatArrows();
		if (RandomInt(1, 4) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 4) == 1)
			OnAddGreatPot();
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
