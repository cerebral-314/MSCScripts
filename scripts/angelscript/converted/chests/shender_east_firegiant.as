#pragma context server

// Converted from chests/shender_east_firegiant.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/shender_east_firegiant"]
class ShenderEastFiregiant : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Fire Giant Chest");
		LegacyCommand("add", "G_GAVE_TOME7", 1); // using this as global end-chest tracker for this map

		OnTcAddArtifact("blunt_bf", 8.0f);
		OnTcAddArtifact("blunt_bt", 8.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (RandomInt(1, 16) <= 1)
			AddStoreItem(STORENAME, "shields_f", 1, 0);

		OnAddEpicItem();
		int count = ActivePlayerCount();
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAddEpics();
		}
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGold(500.0f);

		if (Float(Eval("game.players.totalhp")) > 2000.0f) // meaner spiders
			OnAddEpicItem();
	}

	// add_epics
	void OnAddEpics()
	{
		OnAddEpicItem();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_epics") { OnAddEpics(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
