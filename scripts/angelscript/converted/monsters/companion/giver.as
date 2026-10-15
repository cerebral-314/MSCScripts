#pragma context server

// Converted from monsters/companion/giver.script by msc_transpiler.
// Dishes out items, by Thothie

#include "runtime/ScriptEntity.as"

[script "monsters/companion/giver"]
class Giver : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool NO_SPAWN_STUCK_CHECK = false;
	string MY_OWNER = "MY_OWNER";
	string ITEM_TO_GRANT = "ITEM_TO_GRANT";

	// unnamed block (first think)
	void Giver_FirstThink()
	{
		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		ITEM_TO_GRANT = creatorValue2;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("none");
		SetRace("beloved");
		CallEventDelayed(0.5f, "grant_item"); // needs about this much time
	}

	// grant_item
	void OnGrantItem()
	{
		Offer(MY_OWNER, ITEM_TO_GRANT, MY_OWNER);
		CallEventDelayed(1.0f, "me_vanish");
	}

	// me_vanish
	void OnMeVanish()
	{
		SetAlive(false);
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Giver_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "grant_item") { OnGrantItem(); return true; }
		if (name == "me_vanish") { OnMeVanish(); return true; }
		return false;
	}
}
