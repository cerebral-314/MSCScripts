#pragma context server

// Converted from chests/hunderswamp1_final.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/hunderswamp1_final"]
class Hunderswamp1Final : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetProp(ENT_ME, "scale", 2.0f);
		SetWidth(40);
		SetHeight(60);

		OnTcAddArtifact("blunt_staff_a", 8.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddGreatItem();
		if (RandomInt(1, 8) == 1)
			OnAddGreatItem();

		OnAddGold(RandomInt(3000, 5000));

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "mana_sb", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "armor_helm_gray", 1, 0);

		if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "swords_rune_green", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "scroll2_acid_xolt", 1, 0);
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
