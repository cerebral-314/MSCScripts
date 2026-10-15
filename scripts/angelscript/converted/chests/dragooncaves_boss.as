#pragma context server

// Converted from chests/dragooncaves_boss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/dragooncaves_boss"]
class DragooncavesBoss : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("polearms_dra", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f * ActivePlayerCount());

		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddEpicItem();
		OnAddEpicItem();

		if (RandomInt(1, 20) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 20) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 20) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 20) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 20) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "blunt_ms2", 1, 0);
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "blunt_ms3", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "scroll_turn_undead", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "scroll_ice_xolt", 1, 0);
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
