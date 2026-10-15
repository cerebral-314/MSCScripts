#pragma context server

// Converted from chests/cleicert.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/cleicert"]
class Cleicert : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("axes_gthunder11", 10.0f);
		OnTcAddArtifact("item_ring_thunder22", 10.0f);
		OnTcAddArtifact("blunt_lrod11", 14.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(600, 1200));
		OnChestAddHpotMpot();

		AddStoreItem(STORENAME, "mana_immune_lightning", 1, 0);

		int quantity = RandomInt(15, 100);
		AddStoreItem(STORENAME, "proj_arrow_lightning", quantity, 0, 0, quantity);

		if (RandomInt(1, 3) == 1)
		{
			OnAddGreatPot();
			OnAddGreatArrows();
		}

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "axes_thunder11", 1, 0);

		OnOfferFelewynSymbol(50);
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
