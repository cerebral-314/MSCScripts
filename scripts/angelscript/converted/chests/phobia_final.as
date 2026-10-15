#pragma context server

// Converted from chests/phobia_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/phobia_final"]
class PhobiaFinal : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("scroll2_summon_bear1", 5.0f);
		OnTcAddArtifact("scroll2_conjure_venom_claws", 10.0f);
		OnTcAddArtifact("scroll_conjure_venom_claws", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddEpicItem();
		OnAddEpicItem();
		OnAddGoodArrows();
		OnAddEpicArrows();

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "mana_sb", 1, 0);
		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "swords_novablade12", 1, 0);
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
