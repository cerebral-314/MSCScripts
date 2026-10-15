#pragma context server

// Converted from chests/fmines_spider.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/fmines_spider"]
class FminesSpider : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("smallarms_cre", 5.0f);
		OnTcAddArtifact("armor_faura", 5.0f);
		OnTcAddArtifact("armor_helm_gaz2", 5.0f);
		OnTcAddArtifact("armor_helm_gray", 5.0f);
		OnTcAddArtifact("armor_helm_undead", 5.0f);
		OnTcAddArtifact("armor_paura", 5.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		float goldToAdd = Float(GetProp(CHEST_USER, "scriptvar'PLR_TOTAL_DMG'"));
		goldToAdd *= ActivePlayerCount();
		goldToAdd *= 10.0f;
		OnAddGold(goldToAdd);

		OnAddEpicArrows();
		OnAddEpicArrows();

		if (RandomInt(1, 3) == 1)
			OnAddEpicArrows();

		// unlikely to be below this level, more likely orcfor_final_easy
		if (RandomInt(1, 4) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 5) == 1)
		{
			OnAddEpicItem();
			OnAddEpicItem();
			OnAddEpicArrows();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 6) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_paura", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_faura", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "mana_font", 1, 0);

		OnOfferFelewynSymbol(10);
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
