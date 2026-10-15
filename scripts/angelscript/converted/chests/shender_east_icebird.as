#pragma context server

// Converted from chests/shender_east_icebird.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/shender_east_icebird"]
class ShenderEastIcebird : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	string BC_FARTIFACTS = "BC_FARTIFACTS";

	// unnamed block (first think)
	void ShenderEastIcebird_FirstThink()
	{
		BC_FARTIFACTS = "mana_faura;mana_fbrand;scroll_ice_blast";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Icewing Chest");

		OnTcAddArtifact("mana_faura", 50.0f);
		OnTcAddArtifact("mana_fbrand", 50.0f);
		OnTcAddArtifact("scroll_ice_blast", 15.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (Float(Eval("game.players.totalhp")) >= 2000.0f)
		{
			for (int i = 0; i < 2; i++)
			{
				loopIteration = i;
				OnAddEpics();
			}
		}
		OnAddEpicItem();

		int count = ActivePlayerCount();
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAddGreats();
		}
		OnAddGold(500.0f);
	}

	// add_greats
	void OnAddGreats()
	{
		OnAddGreatItem();
	}

	// add_epics
	void OnAddEpics()
	{
		OnAddEpicItem();
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShenderEastIcebird_FirstThink();
		BaseTreasurechest_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_epics") { OnAddEpics(); return true; }
		if (name == "add_greats") { OnAddGreats(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
