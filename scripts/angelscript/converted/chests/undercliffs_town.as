#pragma context server

// Converted from chests/undercliffs_town.script by msc_transpiler.
// chests/undercliffs_chasm (minor) (pickchance:50%)
// chests/undercliffs_sekrat (unique) (pickchance:100%) [ie. "ravager chest"]
// chests/undercliffs_town (major) (pickchance:100%)
// chests/undercliffs_chasmkill (minor) (pickchance:50%)
// chests/undercliffs_temple (medium) (trapchance:100%,lockchance:100%)
// chests/undercliffs_boss1a (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss1b (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss1c
// chests/undercliffs_boss2a (unique) (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss2b (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss2c
// chests/undercliffs_boss3a (unique) (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss3b (pickchance:25%,trapchance:50%,lockchance:50%)
// chests/undercliffs_boss3c
// paramseg: set_req_pick;50;set_chance_trapped;50;set_chance_haspick;25;set_chest_glow

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/undercliffs_town"]
class UndercliffsTown : BaseTreasurechestScript
{
	// Constants
	bool BC_SPRITE_IN = true;

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
		AddStoreItem(STORENAME, "health_apple", RandomInt(1, 5), 0);
		float goldToAdd = Float(ScriptVarOf(CHEST_USER, "PLR_TOTAL_DMG"));
		goldToAdd *= 2.0f;
		goldToAdd *= ActivePlayerCount();
		if (goldToAdd > 25000.0f)
			goldToAdd = 25000.0f;
		OnAddGold(int(goldToAdd));

		AddStoreItem(STORENAME, "item_gwond", 1, 0);
		AddStoreItem(STORENAME, "item_galat_note_100", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_blunt", 15, 0, 0, 15);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "item_charm_w1", 1, 0);
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "item_charm_w2", 1, 0);
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "swords_wolvesbane", 1, 0);

		int count = RandomInt(1, 2);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAddItemsSelfAdj();
		}
	}

	// add_items_self_adj
	void OnAddItemsSelfAdj()
	{
		int rand = RandomInt(1, 5);

		if (rand == 1)
		{
			OnAddGreatItem();
			OnAddGoodPot();
		}
		if (rand == 2)
		{
			OnAddEpicItem();
			OnAddGoodPot();
			OnAddGreatPot();
		}
		if (rand == 3)
		{
			OnAddEpicItem();
			OnAddGreatPot();
			OnAddEpicPot();
		}
		if (rand == 4)
		{
			OnAddEpicItem();
			OnAddEpicArrows("15");
			OnAddEpicPot();
		}
		if (rand == 5)
		{
			OnAddEpicItem();
			OnAddEpicArrows("30");
			OnAddGreatPot();
			OnAddEpicPot();
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_items_self_adj") { OnAddItemsSelfAdj(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
