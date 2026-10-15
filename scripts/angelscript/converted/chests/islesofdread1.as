#pragma context server

// Converted from chests/islesofdread1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/islesofdread1"]
class Islesofdread1 : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_paura", 5.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(1000.0f);
		if (RandomInt(1, 4) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 4) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 4) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 4) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 4) == 1)
			OnAddGoodItem();
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
