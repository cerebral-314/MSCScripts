#pragma context server

// Converted from chests/lodagond2.script by msc_transpiler.
// Sorc chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/lodagond2"]
class Lodagond2 : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		SetName("Lodagond Chest 2");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(300.0f);
		OnChestAddHpotMpot();

		AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);
		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();
		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 12) == 1)
		{
			int scrollTome = RandomInt(1, 2);
			if (scrollTome == 1)
				AddStoreItem(STORENAME, "scroll_lightning_storm", 1, 0);
			if (scrollTome == 2)
				AddStoreItem(STORENAME, "scroll2_lightning_storm", 1, 0);
		}

		if (RandomInt(1, 6) == 1)
		{
			OnAddEpicItem();
			AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		}
		if (RandomInt(1, 7) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 9) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
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
