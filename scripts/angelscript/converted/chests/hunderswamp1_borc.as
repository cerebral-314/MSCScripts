#pragma context server

// Converted from chests/hunderswamp1_borc.script by msc_transpiler.
// Creates one random epic item for each player with qualifying HP, plus some pots and gold

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/hunderswamp1_borc"]
class Hunderswamp1Borc : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		CallEventDelayed(0.1f, "chest_sprite_in");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// callevent add_gold_by_hp MAX_GOLD_AMT
		OnAddEpicItem();
		OnAddEpicItem();
	}

	// chest_sprite_in
	void OnChestSpriteIn()
	{
		BaseTreasurechest_OnChestSpriteIn(); // chests/base_treasurechest
		SetSolid("trigger");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "chest_sprite_in") { OnChestSpriteIn(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
