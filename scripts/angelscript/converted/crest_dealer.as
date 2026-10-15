#pragma context server

// Converted from crest_dealer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "crest_dealer"]
class CrestDealer : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_CRESTS = "MY_CRESTS";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Gimmecrest Goblin");
		SetModel("null.mdl");
		SetInvincible(true);
	}

	// game_dynamically_created
	// <playerId> <tokenOfCrests>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_CRESTS = creatorValue2;
		OpenMenu(creatorValue1);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		int count = GetTokenCount(MY_CRESTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBuildCrestMenu();
		}

		CallEventDelayed(10.0f, "end_me");
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		OnEndMe();
	}

	// build_crest_menu
	void OnBuildCrestMenu()
	{
		MenuItem menuItem;

		string crest = GetToken(MY_CRESTS, loopIteration);

		menuItem.title = LegacyFunction("get_item_table", crest, "name");
		menuItem.type = "callback";
		menuItem.callback = "give_crest";
		menuItem.data = crest;
		RegisterMenuItem(menuItem);
	}

	// give_crest
	// <playerId> <crestScriptname>
	void OnGiveCrest(CBasePlayer@ player = null, string crestScript = "")
	{
		CallExternal(GetVar("GAME_MASTER"), "give_item", @player, crestScript);
		DeleteMe();
	}

	// end_me
	void OnEndMe()
	{
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "build_crest_menu") { OnBuildCrestMenu(); return true; }
		if (name == "end_me") { OnEndMe(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_crest") { OnGiveCrest(PlayerParam(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
