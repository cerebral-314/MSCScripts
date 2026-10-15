#pragma context server

// Converted from a3/a3TC1.script by msc_transpiler.
// Treasure Chest #1 in A3 - Near the player start, on a platform

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class A3TC1
{

	// game_spawn
	void A3TC1_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnTcAddArtifact("health_lpotion", 25.0f);
		OnTcAddArtifact("armor_leather_torn", 50.0f);
	}

	// chest_additems
	void A3TC1_OnChestAdditems()
	{
		OnAddGold(RandomInt(4, 15));

		// |Store name|  |Item name|      |Quantity| |cost|
		AddStoreItem(STORENAME, "item_torch", 1, 0);
		AddStoreItem(STORENAME, "health_apple", RandomInt(1, 2), 0);

		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORENAME, "blunt_hammer1", 1, 0);

		if (RandomInt(1, 6) == 1)
			AddStoreItem(STORENAME, "smallarms_dirk", 1, 0);

		if (RandomInt(1, 20) == 1)
			OnAddNoobItem();
		if (RandomInt(1, 20) == 1)
			OnAddNoobItem();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		A3TC1_OnGameSpawn(playerRace, playerGender);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		A3TC1_OnChestAdditems();
	}

	// This file's events and timers by their .script names
	bool A3TC1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "a3/a3TC1"]
shared class A3TC1Script : BaseTreasurechestScript, A3TC1
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return A3TC1_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
