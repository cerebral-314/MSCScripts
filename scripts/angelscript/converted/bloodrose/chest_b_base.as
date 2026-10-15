#pragma context server

// Converted from bloodrose/chest_b_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ChestBBase
{

	// chest_additems
	void ChestBBase_OnChestAdditems()
	{
		OnAddGold(RandomInt(80, 100));

		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "item_log", 1, 0);
		AddStoreItem(STORENAME, "item_crystal_return", 1, 0);

		OnAddGreatItem();
		OnAddEpicArrows("30");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		ChestBBase_OnChestAdditems();
	}

	// This file's events and timers by their .script names
	bool ChestBBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "bloodrose/chest_b_base"]
shared class ChestBBaseScript : BaseTreasurechestScript, ChestBBase
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ChestBBase_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
