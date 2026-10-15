#pragma context server

// Converted from chests/phlames_blacksmith.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/phlames_blacksmith"]
class PhlamesBlacksmith : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Treasure Chest");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		string goldText = Eval("game.players.totalhp");
		int gold = Int(goldText);
		if (gold < 2000)
			gold = 2000;
		OnAddGold(gold);

		OnAddEpicItem();

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "blunt_darkmaul", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "blunt_gauntlets_fire", 1, 0);

		if (RandomInt(1, 15) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 5) == 1)
			OnAddEpicItem();

		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "blunt_fs", 1, 0);

		if (RandomInt(1, 20) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);

		if (RandomInt(1, 20) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_faura", 1, 0);
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
