#pragma context server

// Converted from chests/skycastle1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/skycastle1"]
class Skycastle1 : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_golden", 10.0f);
		OnTcAddArtifact("blunt_gauntlets_demon", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(1000.0f);

		// addstoreitem <storename> <item> <amt> <cost%> <buy_ratio> <bundle_size>
		AddStoreItem(STORENAME, "skin_bear", 50, 0);
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "armor_plate", 1, 0);
		AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "scroll_ice_shield", 1, 0);

		float hArrows = ActivePlayerCount() * 15.0f;

		OnAddEpicItem();
		OnAddEpicItem();
		AddStoreItem(STORENAME, "proj_arrow_gholy", hArrows, 0, 0, 15);
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
