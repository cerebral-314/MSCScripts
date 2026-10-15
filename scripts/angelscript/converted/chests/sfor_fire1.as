#pragma context server

// Converted from chests/sfor_fire1.script by msc_transpiler.
// dropped in sfor after killing 4 shadow wolves (req. high end players present)
// - placeholder, hoping for wolf's bane sword and potion later

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SforFire1
{

	// game_spawn
	void SforFire1_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnTcAddArtifact("smallarms_flamelick", 4.0f);
	}

	// chest_additems
	void SforFire1_OnChestAdditems()
	{
		OnAddGold(50.0f);

		AddStoreItem(STORENAME, "health_mpotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);

		OnAddNoobItem();
		OnAddNoobItem();
		OnAddNoobItem();

		if (RandomInt(1, 8) == 1)
			OnAddGoodItem();

		if (RandomInt(1, 8) == 1)
			OnAddGreatItem();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SforFire1_OnGameSpawn(playerRace, playerGender);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		SforFire1_OnChestAdditems();
	}

	// This file's events and timers by their .script names
	bool SforFire1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/sfor_fire1"]
shared class SforFire1Script : BaseTreasurechestScript, SforFire1
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SforFire1_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
