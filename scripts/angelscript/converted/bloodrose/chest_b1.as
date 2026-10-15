#pragma context server

// Converted from bloodrose/chest_b1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/bloodrose/chest_b_base.as"

[script "bloodrose/chest_b1"]
class ChestB1 : ChestBBaseScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("item_log_magic", 100.0f);
		OnTcAddArtifact("swords_rune_green", 30.0f);
		OnTcAddArtifact("shields_rune", 30.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		ChestBBase_OnChestAdditems(); // bloodrose/chest_b_base
		AddStoreItem(STORENAME, "mana_speed", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return ChestBBaseScript::DispatchEvent(name, params);
	}
}
