#pragma context server

// Converted from ms_wicardoven/chest_voldar.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "ms_wicardoven/chest_voldar"]
class ChestVoldar : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_salamander", 10.0f);
		OnTcAddArtifact("scroll2_summon_fangtooth", 10.0f);
		OnTcAddArtifact("swords_rune_green", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(20, 200));

		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		AddStoreItem(STORENAME, "swords_liceblade", 1, 0);
		AddStoreItem(STORENAME, "swords_poison1", 1, 0);

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
