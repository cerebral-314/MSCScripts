#pragma context server

// Converted from outpost/final_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "outpost/final_chest"]
class OutpostFinalChest : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		CBaseEntity@ superId = FindByName("outpost_super");
		if (!Exists(superId))
		{
			DeleteEntity(ENT_ME);
			return;
		}

		OnTcAddArtifact("scroll_lightning_chain", 15.0f);
		OnTcAddArtifact("scroll2_lightning_chain", 15.0f);
		OnTcAddArtifact("mana_forget", 15.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(200, 1000)); // add gold pouches to chest

		AddStoreItem(STORENAME, "mana_demon_blood", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "item_log", 1, 0);

		AddStoreItem(STORENAME, "proj_arrow_silvertipped", 30, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_jagged", 30, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_fire", 60, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_poison", 30, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_frost", 60, 0, 0, 30);
		AddStoreItem(STORENAME, "proj_arrow_holy", 30, 0, 0, 30);

		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "proj_arrow_gholy", 30, 0, 0, 30);

		AddStoreItem(STORENAME, "proj_bolt_fire", 50, 0, 0, 50);
		AddStoreItem(STORENAME, "proj_bolt_iron", 100, 0, 0, 50);
		AddStoreItem(STORENAME, "proj_bolt_silver", 25, 0, 0, 25);
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
