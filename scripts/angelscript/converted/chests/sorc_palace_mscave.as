#pragma context server

// Converted from chests/sorc_palace_mscave.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/sorc_palace_mscave"]
class SorcPalaceMscave : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		OnTcAddArtifact("scroll_lightning_disc", 5.0f);
		OnTcAddArtifact("scroll2_lightning_disc", 5.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f);
		OnAddEpicItem();
		OnAddEpicItem();
		OnOfferFelewynSymbol(25);

		OnAddEpicArrows("30");
		OnAddEpicArrows("30");

		if (Float(Eval("game.players.totalhp")) > 2000.0f)
		{
			OnAddEpicItem();
			OnAddEpicItem();
		}

		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();

		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "item_charm_w2", 1, 0);
		if (RandomInt(1, 16) == 1)
			AddStoreItem(STORENAME, "armor_faura", 1, 0);
		if (RandomInt(1, 16) == 1)
			AddStoreItem(STORENAME, "armor_paura", 1, 0);

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "mana_immune_lightning", 1, 0);
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
