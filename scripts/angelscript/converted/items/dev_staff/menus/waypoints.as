#pragma context server

// Converted from items/dev_staff/menus/waypoints.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Waypoints
{
	// Variables (an unset .script variable reads as its own name)
	string WAYPOINT_QUEST = "WAYPOINT_QUEST";

	// unnamed block (first think)
	void Waypoints_FirstThink()
	{
		WAYPOINT_QUEST = "wpoint_" + ToLowerCase(MapName());
	}

	// menu_choose_waypoints
	void Waypoints_OnMenuChooseWaypoints()
	{
		MenuItem menuItem;

		menuItem.title = "Save Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "12";

		menuItem.title = "Load Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "13";
	}

	// menu_waypoint_save
	void Waypoints_OnMenuWaypointSave()
	{
		MenuItem menuItem;

		PlayerMessageBlue(MY_OWNER, "Waypoints save along with the map.");

		menuItem.title = "#1 Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "save_waypoint";
		menuItem.data = "0";

		menuItem.title = "#2 Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "save_waypoint";
		menuItem.data = "1";

		menuItem.title = "#3 Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "save_waypoint";
		menuItem.data = "2";

		menuItem.title = "#4 Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "save_waypoint";
		menuItem.data = "3";

		menuItem.title = "#5 Waypoint";
		menuItem.type = "callback";
		menuItem.callback = "save_waypoint";
		menuItem.data = "4";
	}

	// save_waypoint
	void Waypoints_OnSaveWaypoint(string value = "", string waypointName = "")
	{
		string waypoints = GetQuestData(MY_OWNER, WAYPOINT_QUEST);
		if (waypoints == "0")
			waypoints = "0;0;0;0;0";

		waypoints = TokenSet(waypoints, Int(waypointName), Text(OriginOf(MY_OWNER)));
		Quest("set", MY_OWNER, WAYPOINT_QUEST, waypoints);

		PlayerMessageBlue(MY_OWNER, "Waypoint saved.");
	}

	// menu_waypoint_load
	void Waypoints_OnMenuWaypointLoad()
	{
		MenuItem menuItem;

		string waypoints = GetQuestData(MY_OWNER, WAYPOINT_QUEST);
		if (waypoints == "0")
			waypoints = "0;0;0;0;0";

		menuItem.title = "#1 Waypoint";
		if (GetToken(waypoints, 0) != "0")
		{
			menuItem.type = "callback";
			menuItem.callback = "load_waypoint";
			menuItem.data = "0";
		}
		else
		{
			menuItem.type = "disabled";
		}

		menuItem.title = "#2 Waypoint";
		if (GetToken(waypoints, 1) != "0")
		{
			menuItem.type = "callback";
			menuItem.callback = "load_waypoint";
			menuItem.data = "1";
		}
		else
		{
			menuItem.type = "disabled";
		}

		menuItem.title = "#3 Waypoint";
		if (GetToken(waypoints, 2) != "0")
		{
			menuItem.type = "callback";
			menuItem.callback = "load_waypoint";
			menuItem.data = "2";
		}
		else
		{
			menuItem.type = "disabled";
		}

		menuItem.title = "#4 Waypoint";
		if (GetToken(waypoints, 3) != "0")
		{
			menuItem.type = "callback";
			menuItem.callback = "load_waypoint";
			menuItem.data = "3";
		}
		else
		{
			menuItem.type = "disabled";
		}

		menuItem.title = "#5 Waypoint";
		if (GetToken(waypoints, 4) != "0")
		{
			menuItem.type = "callback";
			menuItem.callback = "load_waypoint";
			menuItem.data = "4";
		}
		else
		{
			menuItem.type = "disabled";
		}
	}

	// load_waypoint
	void Waypoints_OnLoadWaypoint(string value = "", int pointIndex = 0)
	{
		string waypoints = GetQuestData(MY_OWNER, WAYPOINT_QUEST);
		string point = GetToken(waypoints, pointIndex);

		SetOrigin(MY_OWNER, Vec(point));

		PlayerMessageBlue(MY_OWNER, "Waypoint loaded.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMenuChooseWaypoints() { Waypoints_OnMenuChooseWaypoints(); } // menu_choose_waypoints
	void OnMenuWaypointSave() { Waypoints_OnMenuWaypointSave(); } // menu_waypoint_save
	void OnSaveWaypoint(string value = "", string waypointName = "") { Waypoints_OnSaveWaypoint(value, waypointName); } // save_waypoint
	void OnMenuWaypointLoad() { Waypoints_OnMenuWaypointLoad(); } // menu_waypoint_load
	void OnLoadWaypoint(string value = "", int pointIndex = 0) { Waypoints_OnLoadWaypoint(value, pointIndex); } // load_waypoint

	// This file's events and timers by their .script names
	bool Waypoints_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "load_waypoint") { OnLoadWaypoint(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "menu_choose_waypoints") { OnMenuChooseWaypoints(); return true; }
		if (name == "menu_waypoint_load") { OnMenuWaypointLoad(); return true; }
		if (name == "menu_waypoint_save") { OnMenuWaypointSave(); return true; }
		if (name == "save_waypoint") { OnSaveWaypoint(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/menus/waypoints"]
shared class WaypointsScript : ScriptEntity, Waypoints
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

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Waypoints_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Waypoints_DispatchEvent(name, params);
	}
}
