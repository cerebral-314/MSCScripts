#pragma context server

// Converted from helena/bandit_boss_chest.script by msc_transpiler.
// Bandit boss only spawns in helena if there are a VERY large number of powerful players present (about 5000hp)

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "helena/bandit_boss_chest"]
class BanditBossChest : BaseTreasurechestScript
{
	// game_spawn
	void BanditBossChest_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PlaySound(0, 10, "amb/quest1.wav"); // alert folks to my presense as I spawn a bit late to avoid edict crashes
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BanditBossChest_OnGameSpawn(playerRace, playerGender);
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(100, 1000));

		OnAddGreatItem();
		OnAddGreatItem();
		OnAddEpicItem();
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
