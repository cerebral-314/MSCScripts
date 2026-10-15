#pragma context server

// Converted from edana/eTC1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "edana/eTC1"]
class ETC1 : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	bool HAVE_LETTER = false;

	// game_spawn
	// Mayor's treasure chest
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetUniqueName("mayor_chest");
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "smallarms_knife", 1, 0);
		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "health_mpotion", 1, 0);
		if (RandomInt(1, 2) == 1)
			AddStoreItem(STORENAME, "health_apple", 1, 0);
		OnAddGold(RandomInt(1, 5));

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "armor_leather_torn", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "proj_arrow_broadhead", 30, 0, 0, 15);

		if (HAVE_LETTER)
			return;
		// dbg showletter
		HAVE_LETTER = true;
		AddStoreItem(STORENAME, "item_letter_mayor", 1, 0);
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
