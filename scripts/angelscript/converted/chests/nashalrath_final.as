#pragma context server

// Converted from chests/nashalrath_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/nashalrath_final"]
class NashalrathFinal : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	bool DID_FIRST_OPEN = false;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("shields_f", 8.0f);
		OnTcAddArtifact("swords_vb", 8.0f);
		OnTcAddArtifact("swords_gb", 8.0f);

		SetName("Jaminporlant's Generosity (multi)");
		SetProp(ENT_ME, "scale", 2.0f);
	}

	// tc_open
	void OnTcOpen(CBasePlayer@ player = null)
	{
		BaseTreasurechest_OnTcOpen(player); // chests/base_treasurechest

		if (!DID_FIRST_OPEN)
		{
			DID_FIRST_OPEN = true;
			CallExternal(FindByName("gdragon_img"), "ext_exit_sequence");
		}
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(5000.0f);

		OnAddEpicItem();
		OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();

		AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);

		if (RandomInt(1, 24) == 1)
			AddStoreItem(STORENAME, "armor_faura", 1, 0);

		if (RandomInt(1, 24) == 1)
			AddStoreItem(STORENAME, "item_charm_w2", 1, 0);

		if (RandomInt(1, 24) == 1)
			AddStoreItem(STORENAME, GetRandomToken("smallarms_cre;smallarms_cre;smallarms_crel;smallarms_cref"), 1, 0);

		if (Float(Eval("game.players.totalhp")) > 4000.0f)
		{
			OnAddEpicItem();
			OnAddEpicItem();
		}

		OnAddGreatItem();
		OnAddGreatItem();
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
		if (name == "tc_open") { OnTcOpen(PlayerParam(params, 0)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
