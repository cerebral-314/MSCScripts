#pragma context server

// Converted from helena/OTTC1.script by msc_transpiler.
// Thothie - Compatibility

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "helena/OTTC1"]
class Ottc1 : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_golden", 2.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(55, 100));
		// |Store name| |Item name| |Quantity| |cost|
		AddStoreItem(STORENAME, "crest_gag", 1, 0);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "scroll_ice_shield", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "health_spotion", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "swords_longsword", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "armor_plate", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "sheath_belt_snakeskin", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "armor_knights", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "armor_helm_golden", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "smallarms_huggerdagger4", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "smallarms_craftedknife4", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "blunt_gauntlets_serpant", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "swords_skullblade4", 1, 0);
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
