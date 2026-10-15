#pragma context server

// Converted from chests/ice_main.script by msc_transpiler.
// ms_snow ice queen chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/ice_main"]
class IceMain : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("bows_frost", 10.0f);
		OnTcAddArtifact("armor_helm_gaz2", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(546.0f);

		// addstoreitem STORENAME ITEMNAME QUANITY SELL_PRICE_ADJUSTMENT(integer%) BUYPRICE_ADJUSTMENT(multiplier%) #IN_BUNDLE
		AddStoreItem(STORENAME, "proj_arrow_frost", 120, 0, 0, 60);
		AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);

		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		if (RandomInt(0, 1) != 0)
			AddStoreItem(STORENAME, "swords_liceblade", 1, 0);

		AddStoreItem(STORENAME, "mana_forget", 1, 0);

		if (RandomInt(1, 100) <= 2)
			AddStoreItem(STORENAME, "scroll2_ice_blast", 1, 0);

		int scrollTome = RandomInt(1, 2);
		if (scrollTome == 1)
			AddStoreItem(STORENAME, "scroll_ice_shield", 1, 0);
		if (scrollTome == 2)
			AddStoreItem(STORENAME, "scroll2_ice_shield", 1, 0);

		if (RandomInt(1, 100) <= 10)
		{
			scrollTome = RandomInt(1, 2);
			if (scrollTome == 1)
				AddStoreItem(STORENAME, "scroll_blizzard", 1, 0);
			if (scrollTome == 2)
				AddStoreItem(STORENAME, "scroll2_blizzard", 1, 0);
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
