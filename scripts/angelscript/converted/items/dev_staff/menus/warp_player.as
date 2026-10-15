#pragma context server

// Converted from items/dev_staff/menus/warp_player.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class WarpPlayer
{
	// Variables (an unset .script variable reads as its own name)
	int TELEPORT_MODE = 3;

	// unnamed block (first think)
	void WarpPlayer_FirstThink()
	{
		ArrayCreate("A_PLAYERS");
		TELEPORT_MODE = 3;
	}

	// menu_tele_mode
	void WarpPlayer_OnMenuTeleMode()
	{
		MenuItem menuItem;

		menuItem.title = "Go to player";
		menuItem.type = "callback";
		menuItem.callback = "set_tele_mode";
		menuItem.data = "0";

		menuItem.title = "Bring player here";
		menuItem.type = "callback";
		menuItem.callback = "set_tele_mode";
		menuItem.data = "1";
	}

	// set_tele_mode
	void WarpPlayer_OnSetTeleMode(string value = "", int teleportMode = 0)
	{
		TELEPORT_MODE = teleportMode;
		OnSetMenuType(0, "16");
	}

	// menu_tele_player
	void WarpPlayer_OnMenuTelePlayer()
	{
		LegacyCommand("getplayersarray", "A_PLAYERS");
		int count = GetArrayCount("A_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAddPlayerToMenu();
		}
	}

	// add_player_to_menu
	void WarpPlayer_OnAddPlayerToMenu()
	{
		MenuItem menuItem;

		string player = GetArray("A_PLAYERS", Text(loopIteration));
		if (player != MY_OWNER)
		{
			menuItem.title = NameOf(player);
			menuItem.type = "callback";
			menuItem.callback = "teleport_player";
			menuItem.data = player;
		}
	}

	// teleport_player
	void WarpPlayer_OnTeleportPlayer(string value = "", string target = "")
	{
		if (TELEPORT_MODE == 0)
			SetOrigin(MY_OWNER, OriginOf(target));
		else
			SetOrigin(target, OriginOf(MY_OWNER));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMenuTeleMode() { WarpPlayer_OnMenuTeleMode(); } // menu_tele_mode
	void OnSetTeleMode(string value = "", int teleportMode = 0) { WarpPlayer_OnSetTeleMode(value, teleportMode); } // set_tele_mode
	void OnMenuTelePlayer() { WarpPlayer_OnMenuTelePlayer(); } // menu_tele_player
	void OnAddPlayerToMenu() { WarpPlayer_OnAddPlayerToMenu(); } // add_player_to_menu
	void OnTeleportPlayer(string value = "", string target = "") { WarpPlayer_OnTeleportPlayer(value, target); } // teleport_player
	void OnSetMenuType(int value = 0, string menuType = "") {} // set_menu_type

	// This file's events and timers by their .script names
	bool WarpPlayer_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_player_to_menu") { OnAddPlayerToMenu(); return true; }
		if (name == "menu_tele_mode") { OnMenuTeleMode(); return true; }
		if (name == "menu_tele_player") { OnMenuTelePlayer(); return true; }
		if (name == "set_tele_mode") { OnSetTeleMode(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "teleport_player") { OnTeleportPlayer(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/menus/warp_player"]
shared class WarpPlayerScript : ScriptEntity, WarpPlayer
{
	// Variables every script that includes this file declares
	string AFF_1 = "AFF_1";
	string AFF_2 = "AFF_2";
	string AFF_3 = "AFF_3";
	bool LISTENING_FOR_TRIGGER = false;
	string MENU_TYPE = "MENU_TYPE";
	string MY_ITEM = "MY_ITEM";
	string MY_OWNER = "MY_OWNER";
	string RECENT_TRIGGERS = "RECENT_TRIGGERS";
	float STARTED_LISTENING = 0.0f;
	string TRIG_QUEST = "TRIG_QUEST";
	string WAYPOINT_QUEST = "WAYPOINT_QUEST";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WarpPlayer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return WarpPlayer_DispatchEvent(name, params);
	}
}
