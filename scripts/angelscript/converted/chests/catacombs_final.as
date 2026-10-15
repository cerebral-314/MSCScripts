#pragma context server

// Converted from chests/catacombs_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/catacombs_final"]
class CatacombsFinal : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("scroll_summon_guard", 5.0f);
		OnTcAddArtifact("scroll_summon_bear1", 5.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGreatItem();
		OnAddGreatArrows();
		OnAddEpicItem();

		if (RandomInt(1, 100) <= 3) // Fine morning star
			AddStoreItem(STORENAME, "blunt_ms3", 1, 0);
		if (RandomInt(1, 100) <= 5) // Morning star
			AddStoreItem(STORENAME, "blunt_ms2", 1, 0);
		if (RandomInt(1, 100) <= 8) // Rusty morning star
			AddStoreItem(STORENAME, "blunt_ms1", 1, 0);

		if (RandomInt(1, 100) <= 8)
			AddStoreItem(STORENAME, "scroll_summon_fangtooth", 1, 0);

		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "scroll_acid_xolt", 1, 0);
		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "scroll_poison_cloud", 1, 0);
		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "scroll_ice_blast", 1, 0);
		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "scroll_ice_xolt", 1, 0);
		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "scroll_healing_circle", 1, 0);

		// --xtra items
		if (RandomInt(1, 2) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 3) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 4) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 5) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		OnAddGold(500.0f * RandomInt(1, 3));
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
