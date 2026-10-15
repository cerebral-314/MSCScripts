#pragma context server

// Converted from chests/hunderswamp1_extra.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/hunderswamp1_extra"]
class Hunderswamp1Extra : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		OnTcAddArtifact("smallarms_crep", 10.0f);
		CallEventDelayed(0.1f, "chest_sprite_in");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// callevent add_gold_by_hp MAX_GOLD_AMT
		OnAddEpicItem();

		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
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
