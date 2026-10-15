#pragma context server

// Converted from chests/undercliffs_chasm.script by msc_transpiler.
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

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class UndercliffsChasm
{
	// Constants
	bool BC_SPRITE_IN = true;

	// game_spawn
	void UndercliffsChasm_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetMonsterClip(false);
	}

	// chest_additems
	void UndercliffsChasm_OnChestAdditems()
	{
		float goldToAdd = Float(ScriptVarOf(CHEST_USER, "PLR_TOTAL_DMG"));
		goldToAdd *= 2.0f;
		goldToAdd *= ActivePlayerCount();
		if (goldToAdd > 25000.0f)
			goldToAdd = 25000.0f;
		OnAddGold(int(goldToAdd));

		int count = RandomInt(1, 2);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAddItemsSelfAdj();
		}
	}

	// add_items_self_adj
	void UndercliffsChasm_OnAddItemsSelfAdj()
	{
		int rand = RandomInt(1, 5);

		if (rand == 1)
			OnAddNoobItem();
		if (rand == 2)
			OnAddGreatItem();
		if (rand == 3)
			OnAddEpicItem();
		if (rand == 4)
		{
			OnAddEpicItem();
			OnAddEpicArrows("15");
		}
		if (rand == 5)
		{
			OnAddEpicItem();
			OnAddEpicArrows("30");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		UndercliffsChasm_OnGameSpawn(playerRace, playerGender);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		UndercliffsChasm_OnChestAdditems();
	}

	void OnAddItemsSelfAdj() { UndercliffsChasm_OnAddItemsSelfAdj(); } // add_items_self_adj

	// This file's events and timers by their .script names
	bool UndercliffsChasm_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_items_self_adj") { OnAddItemsSelfAdj(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/undercliffs_chasm"]
shared class UndercliffsChasmScript : BaseTreasurechestScript, UndercliffsChasm
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return UndercliffsChasm_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
