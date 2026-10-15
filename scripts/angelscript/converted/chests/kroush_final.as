#pragma context server

// Converted from chests/kroush_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/kroush_final"]
class KroushFinal : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("smallarms_frozentongueonflagpole", 10.0f);
		OnTcAddArtifact("armor_helm_gaz2", 10.0f);
		OnTcAddArtifact("scroll_ice_lance", 10.0f);
		OnTcAddArtifact("scroll2_ice_lance", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (Truthy(ItemExists(CHEST_USER, "item_ring_ryza")) && GetQuestData(CHEST_USER, "manaring") == "0" && !Truthy(ItemExists(CHEST_USER, "item_ring_ryza_gem1")))
			AddStoreItem(STORENAME, "item_ring_ryza_gem1", 1, 0);

		OnAddGold(RandomInt(999, 2001));

		OnAddEpicArrows();
		OnAddEpicArrows();
		OnAddEpicItem();
		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);
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
