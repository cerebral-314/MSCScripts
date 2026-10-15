#pragma context server

// Converted from chests/deraliasewers_final.script by msc_transpiler.
// Final chest at the end - there are four of these

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/deraliasewers_final"]
class DeraliasewersFinal : BaseTreasurechestScript
{
	// Constants
	string POT_LIST = "mana_speed;mana_immune_poison;mana_immune_cold;mana_immune_fire;mana_demon_blood;mana_gprotection;mana_bravery;mana_fbrand;mana_faura;mana_paura";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		OnTcAddArtifact("armor_helm_elyg", 10.0f);
		OnTcAddArtifact("armor_venom", 15.0f);
		OnTcAddArtifact("blunt_eb", 10.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(500, 2000));
		OnAddEpicArrows();

		if (RandomInt(1, 4) == 1)
			AddStoreItem(STORENAME, "mana_immune_poison", 1, 0);
		if (RandomInt(1, 8) == 1)
			AddStoreItem(STORENAME, "armor_salamander", 1, 0);

		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 8) == 1)
		{
			OnAddGoodItem();
			OnAddGreatItem();
		}

		if (RandomInt(1, 10) == 1)
		{
			OnAddEpicItem();
			OnAddGreatItem();
			OnAddEpicArrows();
		}

		if (RandomInt(1, 10) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
			OnAddEpicItem();
		}

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();

		if (RandomInt(1, 10) == 1)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		OnLAddEpicPotion();
	}

	// l_add_epic_potion
	void OnLAddEpicPotion()
	{
		float nPots = GetTokenCount(POT_LIST) - 1.0f;
		int rndPick = RandomInt(0, int(nPots));
		string rndPot = GetToken(POT_LIST, rndPick);
		AddStoreItem(STORENAME, rndPot, 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "l_add_epic_potion") { OnLAddEpicPotion(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
