#pragma context server

// Converted from chests/phlames_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/phlames_final"]
class PhlamesFinal : BaseTreasurechestScript
{
	// Constants
	string SOME_POTS = "mana_paura;mana_faura;mana_fbrand;mana_font;mana_immune_cold;mana_resist_cold;mana_immune_lightning";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Treasure Chest");

		OnTcAddArtifact("blunt_staff_f", 7.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(500.0f);
		AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		AddStoreItem(STORENAME, "item_gwond", 1, 0);
		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "item_charm_w3", 1, 0);
		AddStoreItem(STORENAME, "item_eh", 1, 0);

		OnOfferFelewynSymbol(100);

		OnAddEpicItem();

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "blunt_gauntlets_demon", 1, 0);

		if (RandomInt(1, 20) == 1)
			OnPowshunsIGotPowshuns();

		OnAddEpicItem();
		OnAddEpicItem();

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "polearms_nag", 1, 0);

		if (RandomInt(1, 15) == 1)
			AddStoreItem(STORENAME, "armor_fireliz", 1, 0);

		if (RandomInt(1, 15) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 25) == 1)
			AddStoreItem(STORENAME, "bows_firebird", 1, 0);

		if (RandomInt(1, 15) == 1)
			OnPowshunsIGotPowshuns();
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "axes_dragon", 1, 0);

		if (RandomInt(1, 15) == 1)
			OnAddEpicItem();
		OnAddEpicArrows("60");

		if (RandomInt(1, 8) == 1)
			OnPowshunsIGotPowshuns();
	}

	// powshuns_i_got_powshuns
	void OnPowshunsIGotPowshuns()
	{
		float nPots = GetTokenCount(SOME_POTS) - 1.0f;
		int rndPotIdx = RandomInt(Int(SOME_POTS), int(nPots));
		string rndPot = GetToken(SOME_POTS, rndPotIdx);
		AddStoreItem(STORENAME, rndPot, 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "powshuns_i_got_powshuns") { OnPowshunsIGotPowshuns(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
