#pragma context server

// Converted from chests/shender_east_telf.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/shender_east_telf"]
class ShenderEastTelf : BaseTreasurechestScript
{
	// unnamed block (first think)
	void ShenderEastTelf_FirstThink()
	{
		CHEST_LOCKED = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Fedrosh's Lockbox");
		SetUniqueName("telf_chest");

		OnTcAddArtifact("smallarms_crec", 17.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (RandomInt(1, 16) <= ActivePlayerCount())
			AddStoreItem(STORENAME, "swords_katana4", 1, 0);

		OnAddEpicItem();
		int count = ActivePlayerCount();
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAddEpics();
		}
		if (Float(Eval("game.players.totalhp")) >= 2000.0f)
		{
			for (int i = 0; i < 2; i++)
			{
				loopIteration = i;
				OnAddEpics();
			}
		}
		if (Float(Eval("game.players.totalhp")) >= 4000.0f)
		{
			for (int i = 0; i < 4; i++)
			{
				loopIteration = i;
				OnAddEpics();
			}
		}
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatPot();
		OnAddEpicPot();
	}

	// ext_unlock
	void OnExtUnlock()
	{
		BaseTreasurechest_OnExtUnlock(); // chests/base_treasurechest
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 255), 64, 90.0f);
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
		ShenderEastTelf_FirstThink();
		BaseTreasurechest_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_epics") { OnAddEpics(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "ext_unlock") { OnExtUnlock(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
