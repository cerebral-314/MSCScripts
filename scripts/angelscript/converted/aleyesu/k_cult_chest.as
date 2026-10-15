#pragma context server

// Converted from aleyesu/k_cult_chest.script by msc_transpiler.
// miniboss chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "aleyesu/k_cult_chest"]
class KCultChest : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGoodItem();
		OnAddGoodItem();
		OnAddGreatItem();

		if (RandomInt(0, 1) == 0)
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
