#pragma context server

// Converted from chests/keledros.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/keledros"]
class ChestsKeledros : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("scroll_lightning_storm", 100.0f);
		OnTcAddArtifact("scroll_volcano", 100.0f);
		OnTcAddArtifact("scroll_fire_wall", 100.0f);
		OnTcAddArtifact("scroll_fire_ball", 100.0f);
		OnTcAddArtifact("scroll_blizzard", 100.0f);

		OnTcAddArtifact("scroll2_lightning_storm", 100.0f);
		OnTcAddArtifact("scroll2_volcano", 100.0f);
		OnTcAddArtifact("scroll2_fire_wall", 100.0f);
		OnTcAddArtifact("scroll2_fire_ball", 100.0f);
		OnTcAddArtifact("scroll2_blizzard", 100.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(100.0f);
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
