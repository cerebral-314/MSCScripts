#pragma context server

// Converted from chests/barnum_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/barnum_final"]
class BarnumFinal : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("swords_volcano", 15.0f);
		OnTcAddArtifact("shields_urdual", 15.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(50.0f * ActivePlayerCount());
		OnChestAddHpotMpot();

		OnAddGoodItem();
		OnAddGoodItem();

		if (RandomInt(1, 2) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 3) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 4) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 4) == 1)
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
