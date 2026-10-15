#pragma context server

// Converted from chests/ara.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Ara
{

	// game_spawn
	void Ara_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// already common in one of the loot tables....
		// callevent tc_add_artifact armor_leather_gaz1 80
		OnTcAddArtifact("armor_helm_undead", 12.0f);
	}

	// chest_additems
	void Ara_OnChestAdditems()
	{
		OnAddGold(50.0f * ActivePlayerCount());
		OnChestAddHpotMpot();

		OnAddGoodItem();
		OnAddGreatItem();

		if (RandomInt(1, 6) == 1)
			OnAddGreatItem();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		Ara_OnGameSpawn(playerRace, playerGender);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		Ara_OnChestAdditems();
	}

	// This file's events and timers by their .script names
	bool Ara_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/ara"]
shared class AraScript : BaseTreasurechestScript, Ara
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Ara_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
