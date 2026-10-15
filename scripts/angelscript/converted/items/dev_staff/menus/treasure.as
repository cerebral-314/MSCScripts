#pragma context server

// Converted from items/dev_staff/menus/treasure.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ItemsDevStaffMenusTreasure
{

	// menu_treasure
	void ItemsDevStaffMenusTreasure_OnMenuTreasure()
	{
		MenuItem menuItem;

		menuItem.title = "Weapons";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "9";

		menuItem.title = "Armor";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/armor";

		menuItem.title = "Shields";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/shields";

		menuItem.title = "Ammunition";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/ammo";

		menuItem.title = "Rings";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/rings";

		menuItem.title = "Packs";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/packs";

		menuItem.title = "Potions";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/potions";

		menuItem.title = "Quest Items";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/quest";
	}

	// menu_treasure_weapons
	void ItemsDevStaffMenusTreasure_OnMenuTreasureWeapons()
	{
		MenuItem menuItem;

		menuItem.title = "Swords";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/swords";

		menuItem.title = "Martial Arts";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/martialarts";

		menuItem.title = "Small Arms";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/smallarms";

		menuItem.title = "Axes";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/axes";

		menuItem.title = "Blunt Arms";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/bluntarms";

		menuItem.title = "Archery";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/archery";

		menuItem.title = "Magic";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/magic";

		menuItem.title = "Polearms";
		menuItem.type = "callback";
		menuItem.callback = "create_treasure";
		menuItem.data = "items/dev_staff/chests/polearms";
	}

	// create_treasure
	// PARAM2 = scriptname
	void ItemsDevStaffMenusTreasure_OnCreateTreasure(string value = "", string scriptName = "")
	{
		Vector3 ownerPos = OriginOf(MY_OWNER);
		float ownerYaw = AnglesOf(MY_OWNER).y;
		string spawnPos = Text(ownerPos);
		spawnPos = Text(Vec(spawnPos) + RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, 64, 0)));
		CreateNpc(scriptName, Vec(spawnPos), MY_OWNER);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMenuTreasure() { ItemsDevStaffMenusTreasure_OnMenuTreasure(); } // menu_treasure
	void OnMenuTreasureWeapons() { ItemsDevStaffMenusTreasure_OnMenuTreasureWeapons(); } // menu_treasure_weapons
	void OnCreateTreasure(string value = "", string scriptName = "") { ItemsDevStaffMenusTreasure_OnCreateTreasure(value, scriptName); } // create_treasure

	// This file's events and timers by their .script names
	bool ItemsDevStaffMenusTreasure_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "create_treasure") { OnCreateTreasure(Param(params, 0), Param(params, 1)); return true; }
		if (name == "menu_treasure") { OnMenuTreasure(); return true; }
		if (name == "menu_treasure_weapons") { OnMenuTreasureWeapons(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/menus/treasure"]
shared class ItemsDevStaffMenusTreasureScript : ScriptEntity, ItemsDevStaffMenusTreasure
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
		return ItemsDevStaffMenusTreasure_DispatchEvent(name, params);
	}
}
