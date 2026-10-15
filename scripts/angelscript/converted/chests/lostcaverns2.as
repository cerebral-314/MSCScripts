#pragma context server

// Converted from chests/lostcaverns2.script by msc_transpiler.
// miniboss chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/lostcaverns2"]
class Lostcaverns2 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(400.0f);

		OnAddGoodItem();
		OnAddGoodItem();

		OnAddGreatItem();

		if (!(ActivePlayerCount() > 1))
			return;

		OnAddGreatItem();

		if (!(ActivePlayerCount() > 2))
			return;
		OnAddGreatItem();

		if (!(ActivePlayerCount() > 3))
			return;
		OnAddGreatItem();
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
