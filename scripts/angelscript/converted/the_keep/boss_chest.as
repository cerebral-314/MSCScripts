#pragma context server

// Converted from the_keep/boss_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "the_keep/boss_chest"]
class BossChest : BaseTreasurechestScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 1.0f)
		{
			OnTcAddArtifact("smallarms_flamelick", 20.0f);
			OnTcAddArtifact("smallarms_bone_blade", 20.0f);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 2.0f)
		{
			OnTcAddArtifact("blunt_darkmaul", 20.0f);
			OnTcAddArtifact("blunt_ms1", 100.0f);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 3.0f)
		{
			OnTcAddArtifact("axes_runeaxe", 20.0f);
			OnTcAddArtifact("axes_greataxe", 30.0f);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 4.0f)
		{
			OnTcAddArtifact("swords_liceblade", 100.0f);
			OnTcAddArtifact("swords_iceblade", 30.0f);
			OnTcAddArtifact("swords_giceblade", 20.0f);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 5.0f)
		{
			OnTcAddArtifact("bows_crossbow_light", 30.0f);
			OnTcAddArtifact("bows_swiftbow", 100.0f);
			OnTcAddArtifact("bows_orion1", 20.0f);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 6.0f)
		{
			OnTcAddArtifact("swords_novablade12", 20.0f);
			OnTcAddArtifact("swords_skullblade4", 40.0f);
		}
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(250, 400)); // add gold pouches to chest

		if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 1.0f)
		{
			AddStoreItem(STORENAME, "smallarms_dagger", 1, 0);
			AddStoreItem(STORENAME, "smallarms_huggerdagger4", 1, 0);
			if (RandomInt(0, 1) != 0)
				AddStoreItem(STORENAME, "smallarms_craftedknife4", 1, 0);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 2.0f)
		{
			AddStoreItem(STORENAME, "blunt_mace", 1, 0);
			AddStoreItem(STORENAME, "blunt_granitemaul", 1, 0);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 3.0f)
		{
			AddStoreItem(STORENAME, "axes_rsmallaxe", 1, 0);
			AddStoreItem(STORENAME, "axes_doubleaxe", 1, 0);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 4.0f)
		{
			AddStoreItem(STORENAME, "swords_katana3", 1, 0);
			AddStoreItem(STORENAME, "swords_poison1", 1, 0);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 5.0f)
		{
			AddStoreItem(STORENAME, "bows_treebow", 1, 0);
		}
		else if (Float(GetVar("G_BANDIT_BOSS_TYPE")) == 6.0f)
		{
			AddStoreItem(STORENAME, "swords_bastardsword", 1, 0);
			AddStoreItem(STORENAME, "mana_resist_fire", "TC_NPLAYERS_QUART", 0);
			if (RandomInt(0, 1) != 0)
				AddStoreItem(STORENAME, "mana_immune_fire", 1, 0);
		}

		// |Store name|  	|Item name| 	|Quant|	|cost|	|0?|	|Stack?|
		AddStoreItem(STORENAME, "health_spotion", 1, 0);
		AddStoreItem(STORENAME, "mana_mpotion", 1, 0);

		if (RandomInt(1, 3) == 1)
			OnAddGoodItem();
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
