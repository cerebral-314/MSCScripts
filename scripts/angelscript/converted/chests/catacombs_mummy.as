#pragma context server

// Converted from chests/catacombs_mummy.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/catacombs_mummy"]
class CatacombsMummy : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("blunt_ms3", 4.0f);
		OnTcAddArtifact("blunt_ms2", 5.0f);
		OnTcAddArtifact("blunt_ms1", 6.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddEpicItem();
		OnAddEpicArrows();

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "scroll_turn_undead", 1, 0);

		if (RandomInt(1, 4) == 1)
			OnAddEpicArrows();

		OnAddGold(100.0f * RandomInt(1, 3));
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
