#pragma context server

// Converted from items/dev_staff/menus/player.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ItemsDevStaffMenusPlayer
{

	// menu_playerlist
	void ItemsDevStaffMenusPlayer_OnMenuPlayerlist()
	{
		MenuItem menuItem;

		menuItem.title = "Loreldian Soup (Godmode)";
		menuItem.type = "callback";
		menuItem.callback = "toggle_soup";

		menuItem.title = "Invisibility Potion (Notarget)";
		menuItem.type = "callback";
		menuItem.callback = "toggle_notarget";

		menuItem.title = "Set Levels";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "6";

		menuItem.title = "Add Gold";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "7";

		menuItem.title = "Set Respawn Here";
		menuItem.type = "callback";
		menuItem.callback = "set_respawn";
	}

	// toggle_soup
	void ItemsDevStaffMenusPlayer_OnToggleSoup()
	{
		if (HasEffect(MY_OWNER, "lsoup"))
		{
			PlayerMessageBlue(MY_OWNER, "Removed Loreldian Soup effect.");
			CallExternal(MY_OWNER, "ext_remove_lsoup");
		}
		else
		{
			PlayerMessageBlue(MY_OWNER, "Applied Loreldian Soup effect.");
			ApplyEffect(MY_OWNER, "items/dev_staff/effects/loreldian_soup");
		}
	}

	// toggle_notarget
	void ItemsDevStaffMenusPlayer_OnToggleNotarget()
	{
		if (Truthy(ScriptVarOf(MY_OWNER, "PLAYING_DEAD")))
		{
			PlayerMessageBlue(MY_OWNER, "Enemies will now target you.");
			CallExternal(MY_OWNER, "ext_invalidate", 0);
		}
		else
		{
			PlayerMessageBlue(MY_OWNER, "Enemies have stopped targeting you.");
			CallExternal(MY_OWNER, "ext_invalidate", 1);
		}
	}

	// menu_playerlevels
	void ItemsDevStaffMenusPlayer_OnMenuPlayerlevels()
	{
		MenuItem menuItem;

		menuItem.title = "1";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "1";

		menuItem.title = "5";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "5";

		menuItem.title = "10";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "10";

		menuItem.title = "15";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "15";

		menuItem.title = "20";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "20";

		menuItem.title = "25";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "25";

		menuItem.title = "30";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "30";

		menuItem.title = "35";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "35";

		menuItem.title = "75";
		menuItem.type = "callback";
		menuItem.callback = "setlevels";
		menuItem.data = "75";
	}

	// setlevels
	void ItemsDevStaffMenusPlayer_OnSetlevels(string value = "", string level = "")
	{
		CallExternal(MY_OWNER, "ext_setstats", level);
		PlayerMessageBlue(MY_OWNER, "Set all levels to: " + level);

		GiveHealth(MY_OWNER, 10000);
		GiveMana(MY_OWNER, 10000);
	}

	// menu_addgold
	void ItemsDevStaffMenusPlayer_OnMenuAddgold()
	{
		MenuItem menuItem;

		menuItem.title = "100";
		menuItem.type = "callback";
		menuItem.callback = "addgold";
		menuItem.data = "100";

		menuItem.title = "10000";
		menuItem.type = "callback";
		menuItem.callback = "addgold";
		menuItem.data = "10000";

		menuItem.title = "1000000";
		menuItem.type = "callback";
		menuItem.callback = "addgold";
		menuItem.data = "1000000";

		menuItem.title = "999999999";
		menuItem.type = "callback";
		menuItem.callback = "addgold";
		menuItem.data = "999999999";
	}

	// addgold
	void ItemsDevStaffMenusPlayer_OnAddgold(string value = "", string goldAmount = "")
	{
		CallExternal(MY_OWNER, "ext_addgold", goldAmount);
	}

	// set_respawn
	void ItemsDevStaffMenusPlayer_OnSetRespawn()
	{
		CallExternal(MY_OWNER, "set_spawn_point", OriginOf(MY_OWNER));
		PlayerMessageBlue(MY_OWNER, "Respawn point set.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMenuPlayerlist() { ItemsDevStaffMenusPlayer_OnMenuPlayerlist(); } // menu_playerlist
	void OnToggleSoup() { ItemsDevStaffMenusPlayer_OnToggleSoup(); } // toggle_soup
	void OnToggleNotarget() { ItemsDevStaffMenusPlayer_OnToggleNotarget(); } // toggle_notarget
	void OnMenuPlayerlevels() { ItemsDevStaffMenusPlayer_OnMenuPlayerlevels(); } // menu_playerlevels
	void OnSetlevels(string value = "", string level = "") { ItemsDevStaffMenusPlayer_OnSetlevels(value, level); } // setlevels
	void OnMenuAddgold() { ItemsDevStaffMenusPlayer_OnMenuAddgold(); } // menu_addgold
	void OnAddgold(string value = "", string goldAmount = "") { ItemsDevStaffMenusPlayer_OnAddgold(value, goldAmount); } // addgold
	void OnSetRespawn() { ItemsDevStaffMenusPlayer_OnSetRespawn(); } // set_respawn

	// This file's events and timers by their .script names
	bool ItemsDevStaffMenusPlayer_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "addgold") { OnAddgold(Param(params, 0), Param(params, 1)); return true; }
		if (name == "menu_addgold") { OnMenuAddgold(); return true; }
		if (name == "menu_playerlevels") { OnMenuPlayerlevels(); return true; }
		if (name == "menu_playerlist") { OnMenuPlayerlist(); return true; }
		if (name == "set_respawn") { OnSetRespawn(); return true; }
		if (name == "setlevels") { OnSetlevels(Param(params, 0), Param(params, 1)); return true; }
		if (name == "toggle_notarget") { OnToggleNotarget(); return true; }
		if (name == "toggle_soup") { OnToggleSoup(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/menus/player"]
shared class ItemsDevStaffMenusPlayerScript : ScriptEntity, ItemsDevStaffMenusPlayer
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
	int TELEPORT_MODE = 0;
	string TRIG_QUEST = "TRIG_QUEST";
	string WAYPOINT_QUEST = "WAYPOINT_QUEST";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ItemsDevStaffMenusPlayer_DispatchEvent(name, params);
	}
}
