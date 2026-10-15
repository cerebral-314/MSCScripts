#pragma context server

// Converted from chests/undercliffs_temple.script by msc_transpiler.
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

[script "chests/undercliffs_temple"]
class UndercliffsTemple : BaseTreasurechestScript
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
		float goldToAdd = Float(ScriptVarOf(CHEST_USER, "PLR_TOTAL_DMG"));
		goldToAdd *= 2.0f;
		goldToAdd *= ActivePlayerCount();
		if (goldToAdd > 25000.0f)
			goldToAdd = 25000.0f;
		OnAddGold(int(goldToAdd));

		OnOfferFelewynSymbol(25);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "proj_arrow_holy", 15, 0, 0, 15);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "proj_arrow_gholy", 15, 0, 0, 15);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
		AddStoreItem(STORENAME, "swords_spiderblade", 1, 0);

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
			OnAddGreatItem();
		if (rand == 2)
			OnAddEpicItem();
		if (rand == 3)
		{
			OnAddEpicItem();
			OnAddGoodPot();
		}
		if (rand == 4)
		{
			OnAddEpicItem();
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
