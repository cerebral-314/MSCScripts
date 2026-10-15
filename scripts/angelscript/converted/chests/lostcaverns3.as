#pragma context server

// Converted from chests/lostcaverns3.script by msc_transpiler.
// final boss chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/lostcaverns3"]
class Lostcaverns3 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnOfferFelewynSymbol(50);

		OnAddGold(200.0f);

		OnAddGoodItem();
		OnAddGoodItem();
		OnAddGreatItem();
		OnAddEpicItem();

		if (!(ActivePlayerCount() > 1))
			return;

		OnAddGreatItem();
		OnAddEpicItem();

		if (!(ActivePlayerCount() > 2))
			return;
		OnAddGreatItem();

		if (!(ActivePlayerCount() > 3))
			return;
		OnAddGreatItem();
		OnAddGreatItem();
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
