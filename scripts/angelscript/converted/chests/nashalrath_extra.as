#pragma context server

// Converted from chests/nashalrath_extra.script by msc_transpiler.
// Extra side passage chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/nashalrath_extra"]
class NashalrathExtra : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(2000.0f);
		OnChestAddHpotMpot();
		OnAddGoodItem();
		OnAddGreatItem();

		OnAddEpicArrows("15");
		OnAddGreatArrows("15");
		OnAddNoobArrows("15");

		AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
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
