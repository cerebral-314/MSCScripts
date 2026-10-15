#pragma context server

// Converted from chests/phlames_reaver.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/phlames_reaver"]
class PhlamesReaver : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Treasure Chest");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f);

		OnAddEpicArrows();
		OnAddEpicItem();

		if (RandomInt(1, 3) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 3) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 3) == 1)
			OnAddEpicArrows();

		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "item_charm_w3", 1, 0);
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_faura", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "item_charm_w2", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_immune_lightning", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "smallarms_k_fire", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
