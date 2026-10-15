#pragma context server

// Converted from calruin/treasure_picker.script by msc_transpiler.
// Treasure picker for Calruin2 by Thothie

#include "runtime/ScriptEntity.as"

[script "calruin/treasure_picker"]
class TreasurePicker : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string TREASURE_CHOICE = "TREASURE_CHOICE";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Treasure Picker");
		SetInvincible(true);
		SetSolid("none");
		SetRoam(false);
		SetModel("none");

		int tresChoice = RandomInt(1, 100);

		// 50% dark granite maul
		if (tresChoice > 50)
		{
			InfoMessage("all", "CRITICAL_ITEM_DROPPED", "The hellforge has summoned forth a Granite Maul");
			TREASURE_CHOICE = "blunt_granitemaul";
		}
		else if (tresChoice <= 15) // 15% Raven Mace
		{
			InfoMessage("all", "CRITICAL_ITEM_DROPPED", "The hellforge has summoned forth a Raven Mace");
			TREASURE_CHOICE = "blunt_ravenmace";
		}
		else
		{
			// 35% Dark Maul
			if (tresChoice > 15)
			{
				InfoMessage("all", "CRITICAL_ITEM_DROPPED", "The hellforge has summoned forth a Dark Maul");
				TREASURE_CHOICE = "blunt_darkmaul";
			}
		}

		CallEventDelayed(0.1f, "create_treasure");
	}

	// create_treasure
	void OnCreateTreasure(string value = "", string scriptName = "")
	{
		CreateItem(TREASURE_CHOICE, OriginOf(ENT_ME));
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "create_treasure") { OnCreateTreasure(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
