#pragma context server

// Converted from chests/lodagond4_array.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/lodagond4_array"]
class Lodagond4Array : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("smallarms_frozentongueonflagpole", 100.0f);
		OnTcAddArtifact("bows_thornbow", 100.0f);
		OnTcAddArtifact("scroll2_lightning_chain", 100.0f);
		OnTcAddArtifact("blunt_mithral", 100.0f);
		OnTcAddArtifact("mana_leadfoot", 100.0f);
		OnTcAddArtifact("armor_belmont", 100.0f);
		OnTcAddArtifact("armor_helm_gaz2", 100.0f);
		OnTcAddArtifact("swords_frostblade55", 100.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(800, 1400));

		AddStoreItem(STORENAME, "item_crystal_reloc", 1, 0);

		// 4+ players makes these inevitable
		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_resist_cold", 1, 0);
		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_resist_fire", 1, 0);
		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_protection", 1, 0);

		// 4 players makes these 33% each
		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "mana_gprotection", 1, 0);
		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "mana_speed", 1, 0);
		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);

		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "mana_gprotection", 1, 0);
		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "mana_speed", 1, 0);
		if (RandomInt(1, 12) == 1)
			AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
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
