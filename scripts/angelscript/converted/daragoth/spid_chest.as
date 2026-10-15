#pragma context server

// Converted from daragoth/spid_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "daragoth/spid_chest"]
class SpidChest : BaseTreasurechestScript
{
	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		BaseTreasurechest_OnGamePlayerused(player); // chests/base_treasurechest

		CallExternal("all", "spider_chest_used");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 25));

		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "drink_mead", 5, 0);
		AddStoreItem(STORENAME, "health_apple", 5, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
