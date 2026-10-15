#pragma context server

// Converted from aluhandra/sorc_loot.script by msc_transpiler.
// final boss chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "aluhandra/sorc_loot"]
class SorcLoot : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_pheonix55", 8.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(100, 600));

		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		AddStoreItem(STORENAME, "item_charm_w2", 1, 0);

		OnAddEpicItem();
		OnAddEpicItem();
		OnAddGreatItem();

		OnAddEpicItem();
		OnAddEpicItem();

		AddStoreItem(STORENAME, "mana_speed", 1, 0);
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
