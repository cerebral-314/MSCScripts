#pragma context server

// Converted from chests/undercrypts_t2.script by msc_transpiler.
// Creates one random item for each player based on HP, plus some pots and gold

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/undercrypts_t2"]
class UndercryptsT2 : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetMonsterClip(false);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		float minItemLevel = 0.0f;
		int upgradeChance = 0;
		string itemEvent = "ITEM_EVENT";

		OnAddGold(200.0f);

		if (MaxHealthOf(CHEST_USER) < 10.0f)
		{
			minItemLevel = 0.0f;
			upgradeChance = 0;
		}
		if (MaxHealthOf(CHEST_USER) >= 50.0f)
		{
			minItemLevel = 0.0f;
			upgradeChance = 5;
		}
		if (MaxHealthOf(CHEST_USER) >= 100.0f)
		{
			minItemLevel = 1.0f;
			upgradeChance = 10;
		}
		if (MaxHealthOf(CHEST_USER) >= 400.0f)
		{
			minItemLevel = 1.0f;
			upgradeChance = 20;
		}
		if (MaxHealthOf(CHEST_USER) >= 600.0f)
		{
			minItemLevel = 1.0f;
			upgradeChance = 50;
		}
		if (MaxHealthOf(CHEST_USER) >= 800.0f)
		{
			minItemLevel = 2.0f;
			upgradeChance = 75;
		}
		if (MaxHealthOf(CHEST_USER) >= 1000.0f)
		{
			minItemLevel = 3.0f;
			upgradeChance = 0;
		}

		if (RandomInt(1, 100) <= upgradeChance)
			minItemLevel += 1.0f;
		if (RandomInt(1, 100) <= upgradeChance)
			minItemLevel += 1.0f;

		if (minItemLevel > 3.0f)
			minItemLevel = 3.0f;

		if (minItemLevel == 0.0f)
			itemEvent = "add_noob_item";
		if (minItemLevel == 1.0f)
			itemEvent = "add_good_item";
		if (minItemLevel == 2.0f)
			itemEvent = "add_great_item";
		if (minItemLevel == 3.0f)
			itemEvent = "add_epic_item";

		CallEventOrDelay(itemEvent, 100);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnItemEvent() {} // ITEM_EVENT

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
