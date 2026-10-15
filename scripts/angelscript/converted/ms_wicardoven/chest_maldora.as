#pragma context server

// Converted from ms_wicardoven/chest_maldora.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "ms_wicardoven/chest_maldora"]
class ChestMaldora : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_fireliz", 10.0f);
		OnTcAddArtifact("scroll2_summon_guard", 4.0f);
		OnTcAddArtifact("armor_pheonix55", 4.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(100, 1000));

		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		AddStoreItem(STORENAME, "mana_vampire", 1, 0);
		AddStoreItem(STORENAME, "mana_protection", 1, 0);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "mana_speed", 1, 0);

		if (RandomInt(1, 3) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 3) == 1)
			OnAddGreatItem();
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
