#pragma context server

// Converted from chests/olympus.script by msc_transpiler.
// Thanatos

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/olympus"]
class Olympus : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("polearms_ti", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f);
		OnAddEpicItem();
		OnAddEpicItem();

		OnAddEpicArrows("15");
		OnAddGreatArrows("15");
		OnAddEpicArrows("15");
		OnAddGreatArrows("15");

		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 20) == 1)
		{
			OnAddEpicArrows("15");
			OnAddGreatArrows("15");
			AddStoreItem(STORENAME, "armor_venom", 1, 0);
		}

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "item_charm_w2", 1, 0);

		if (Float(Eval("game.players.totalhp")) > 4000.0f) // compesnation for bigger scorps
			OnAddEpicItem();

		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "polearms_hal", 1, 0);

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
