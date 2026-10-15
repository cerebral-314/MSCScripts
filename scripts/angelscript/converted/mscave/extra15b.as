#pragma context server

// Converted from mscave/extra15b.script by msc_transpiler.
// must kill a stone ogre

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/extra15b"]
class Extra15b : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(150, 300));

		OnAddGreatItem();

		if (RandomInt(1, 5) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 5) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 5) == 1)
			OnAddEpicItem();
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
