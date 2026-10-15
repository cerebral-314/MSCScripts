#pragma context server

// Converted from chests/ice_boss.script by msc_transpiler.
// ms_snow - morc chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/ice_boss"]
class IceBoss : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("swords_iceblade", 25.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		// addstoreitem STORENAME ITEMNAME QUANITY SELL_PRICE_ADJUSTMENT(integer%) BUYPRICE_ADJUSTMENT(multiplier%) #IN_BUNDLE
		OnAddGold(RandomInt(200, 400));
		OnChestAddHpotMpot();

		AddStoreItem(STORENAME, "proj_arrow_frost", 120, 0, 0, 120);
		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "scroll_ice_shield", 1, 0);
		else if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "scroll2_ice_shield", 1, 0);

		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "swords_liceblade", 1, 0);
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
