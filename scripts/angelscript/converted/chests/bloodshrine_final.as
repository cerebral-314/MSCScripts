#pragma context server

// Converted from chests/bloodshrine_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/bloodshrine_final"]
class BloodshrineFinal : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("polearms_a", 8.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(1000.0f * ActivePlayerCount());

		AddStoreItem(STORENAME, "proj_arrow_holy", 30, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_gholy", 30, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_bolt_silver", 30, 0, 0, 30);

		int gamePlayers = ActivePlayerCount();

		OnAddEpicItem();

		if (RandomInt(1, 3) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 5) == 1)
			OnAddEpicItem();

		OnAddEpicPot();

		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORENAME, "mana_sb", 1, 0);
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
