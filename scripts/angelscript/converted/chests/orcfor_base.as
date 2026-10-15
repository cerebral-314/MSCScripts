#pragma context server

// Converted from chests/orcfor_base.script by msc_transpiler.
// MAY2011_31 - changed to kinder, simpler system
// - uniques can be gotten on any chest after 6 (7 in some cases)
// - odds increase with each chest found after 6 and player power level

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OrcforBase
{
	// Variables (an unset .script variable reads as its own name)
	float ARTI_CHANCE = 0.55f;
	bool ORCFOR_CHEST_FOUND = false;

	// unnamed block (first think)
	void OrcforBase_FirstThink()
	{
		// base chances in percentage.
		// chance grows linearly as more chests are spawned (up to 9x)
		// setvard ARTI2_CHANCE 0.9 //fire star
		ARTI_CHANCE = 0.55f; // steambow
	}

	// game_spawn
	void OrcforBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		if (!ORCFOR_CHEST_FOUND)
		{
			ORCFOR_CHEST_FOUND = true;
			LegacyCommand("add", "G_GAVE_ARTI1", 1); // using this for chest counter, save a new var
		}

		// max chests you can find before final boss is 8
		// max chests you can find before end is 9
		ARTI_CHANCE = ARTI_CHANCE * Float(GetVar("G_GAVE_ARTI1"));
		OnTcAddArtifact("bows_sxbow", ARTI_CHANCE); // steam xbow
	}

	// chest_additems
	void OrcforBase_OnChestAdditems()
	{
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "blunt_ms1", 1, 0);
		else if (RandomInt(1, 20) == 1)
			AddStoreItem(STORENAME, "blunt_ms2", 1, 0);
		else if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "blunt_ms3", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		OrcforBase_OnGameSpawn(playerRace, playerGender);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OrcforBase_OnChestAdditems();
	}

	// This file's events and timers by their .script names
	bool OrcforBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "chests/orcfor_base"]
shared class OrcforBaseScript : BaseTreasurechestScript, OrcforBase
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcforBase_FirstThink();
		BaseTreasurechest_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OrcforBase_DispatchEvent(name, params)
			|| BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
