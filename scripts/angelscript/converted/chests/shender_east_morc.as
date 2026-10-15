#pragma context server

// Converted from chests/shender_east_morc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/shender_east_morc"]
class ShenderEastMorc : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		LegacyCommand("add", "G_GAVE_ARTI1", 1);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		float goldAmt = 0.0f;

		if (Float(GetVar("G_GAVE_ARTI1")) == 1.0f)
		{
			OnAddEpicArrows();
			goldAmt = PlayerCount() * 50.0f;
			OnAddGold(goldAmt);
		}
		if (Float(GetVar("G_GAVE_ARTI1")) == 2.0f)
		{
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
			goldAmt = ActivePlayerCount() * 500.0f;
			OnAddGold(goldAmt);
		}
		if (Float(GetVar("G_GAVE_ARTI1")) == 3.0f)
		{
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
			AddStoreItem(STORENAME, "mana_faura", 1, 0);
			if (ActivePlayerCount() > 1)
				AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
			goldAmt = ActivePlayerCount() * 2000.0f;
			OnAddGold(goldAmt);
		}
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
