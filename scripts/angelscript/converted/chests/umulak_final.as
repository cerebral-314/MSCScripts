#pragma context server

// Converted from chests/umulak_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/umulak_final"]
class UmulakFinal : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		OnTcAddArtifact("polearms_ph", 12.0f);
		OnTcAddArtifact("bows_telf4", 12.0f);
		OnTcAddArtifact("blunt_lrod11", 20.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(1500.0f);
		OnAddEpicItem();
		OnAddEpicItem();

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);
		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_immune_cold", 1, 0);
		if (RandomInt(1, 16) == 1)
			AddStoreItem(STORENAME, "scroll2_ice_blast", 1, 0);

		if (RandomInt(1, 16) == 1)
			OnAddEpicItem();
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
