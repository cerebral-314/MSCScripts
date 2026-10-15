#pragma context server

// Converted from chests/lodagond1.script by msc_transpiler.
// Uber Reaver Chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/lodagond1"]
class Lodagond1 : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("smallarms_frozentongueonflagpole", 10.0f);
		OnTcAddArtifact("swords_iceblade", 50.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(100.0f);

		OnChestAddHpotMpot();

		int scrollTome = RandomInt(1, 2);
		if (scrollTome == 1)
			AddStoreItem(STORENAME, "scroll_ice_shield", 1, 0);
		if (scrollTome == 2)
			AddStoreItem(STORENAME, "scroll2_ice_shield", 1, 0);

		AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);
		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 5) == 1)
			OnAddEpicItem();
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
