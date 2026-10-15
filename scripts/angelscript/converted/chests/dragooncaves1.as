#pragma context server

// Converted from chests/dragooncaves1.script by msc_transpiler.
// tunnels

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/dragooncaves1"]
class Dragooncaves1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(150.0f);

		OnAddGreatItem();
		OnAddNoobItem();
		OnAddGoodItem();
		OnAddGreatItem();
		OnAddGreatItem();
		if (RandomInt(1, 20) == 1)
			OnAddEpicItem();

		OnAddGreatArrows();
		OnAddEpicArrows();
		if (RandomInt(1, 20) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 20) == 1)
			OnAddEpicArrows();
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
