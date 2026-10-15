#pragma context server

// Converted from challs/challsTC1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "challs/challsTC1"]
class ChallsTC1 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(8, 13));
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "swords_bastardsword", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_regen", 1, 0);

		AddStoreItem(STORENAME, "health_lpotion", 2, 0);
		AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
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
