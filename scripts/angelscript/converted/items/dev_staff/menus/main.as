#pragma context server

// Converted from items/dev_staff/menus/main.script by msc_transpiler.
// Items cannot have menus, so use additional npc to handle these menus

#include "runtime/ScriptEntity.as"
#include "converted/items/dev_staff/menus/beams.as"
#include "converted/items/dev_staff/menus/player.as"
#include "converted/items/dev_staff/menus/treasure.as"
#include "converted/items/dev_staff/menus/trigger.as"
#include "converted/items/dev_staff/menus/waypoints.as"
#include "converted/items/dev_staff/menus/warp_player.as"

[script "items/dev_staff/menus/main"]
class Main : BeamsScript, ItemsDevStaffMenusPlayer, ItemsDevStaffMenusTreasure, Trigger, Waypoints, WarpPlayer
{
	// Variables declared by included files, with the value they start with in this script
	Main()
	{
		MENU_TYPE = "0";
		TELEPORT_MODE = 3; // from items/dev_staff/menus/warp_player
	}

	// unnamed block (first think)
	void Main_FirstThink()
	{
		MENU_TYPE = "0"; // 0 = main; 1 = beams; 2 = afflictions type menu; 3 = afflictions duration menu
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Jester's Staff");

		SetModel("null.mdl");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_ITEM = creatorValue2;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (EntityId(player) != MY_OWNER)
			return;
		if (Float(MENU_TYPE) == 0.0f)
			OnMenuMain();
		if (Float(MENU_TYPE) == 1.0f)
			OnMenuListbeams();
		if (Float(MENU_TYPE) == 2.0f)
			OnMenuListafflicttype();
		if (Float(MENU_TYPE) == 3.0f)
			OnMenuListafflictduration();
		if (Float(MENU_TYPE) == 4.0f)
			OnMenuListafflictdmg();
		if (Float(MENU_TYPE) == 5.0f)
			OnMenuPlayerlist();
		if (Float(MENU_TYPE) == 6.0f)
			OnMenuPlayerlevels();
		if (Float(MENU_TYPE) == 7.0f)
			OnMenuAddgold();
		if (Float(MENU_TYPE) == 8.0f)
			OnMenuTreasure();
		if (Float(MENU_TYPE) == 9.0f)
			OnMenuTreasureWeapons();
		if (Float(MENU_TYPE) == 10.0f)
			OnMenuTrigger();
		if (Float(MENU_TYPE) == 11.0f)
			OnMenuTriggerSuccessful();
		if (Float(MENU_TYPE) == 12.0f)
			OnMenuWaypointSave();
		if (Float(MENU_TYPE) == 13.0f)
			OnMenuWaypointLoad();
		if (Float(MENU_TYPE) == 14.0f)
			OnMenuDamagerSetdmg();
		if (Float(MENU_TYPE) == 15.0f)
			OnMenuTeleMode();
		if (Float(MENU_TYPE) == 16.0f)
			OnMenuTelePlayer();
		if (Float(MENU_TYPE) == 17.0f)
			OnMenuChooseWaypoints();
	}

	// menu_main
	void OnMenuMain()
	{
		MenuItem menuItem;

		menuItem.title = "Spawn Galat Chest";
		menuItem.type = "callback";
		menuItem.callback = "spawn_galats";

		menuItem.title = "Change Beam Type";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "1";

		menuItem.title = "Player Attributes";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "5";

		menuItem.title = "Spawn Items";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "8";

		menuItem.title = "Use Trigger";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "10";

		menuItem.title = "Waypoints";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "17";

		menuItem.title = "Warp other Player";
		menuItem.type = "callback";
		menuItem.callback = "set_menu_type";
		menuItem.data = "15";
	}

	// set_menu_type
	void OnSetMenuType(int value = 0, string menuType = "")
	{
		MENU_TYPE = menuType;
		CallEventDelayed(0.1f, "ext_menu_open");
	}

	// ext_menu_open
	void OnExtMenuOpen()
	{
	}

	// ext_menu_main
	// sets menu to main page and opens menu on player
	void OnExtMenuMain()
	{
		MENU_TYPE = "0";
		CallEventDelayed(0.1f, "ext_menu_open");
	}

	// spawn_galats
	void OnSpawnGalats()
	{
		Vector3 ownerPos = OriginOf(MY_OWNER);
		float ownerYaw = AnglesOf(MY_OWNER).y;
		string spawnPos = Text(ownerPos);
		spawnPos = Text(Vec(spawnPos) + RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, 64, 0)));
		CreateNpc("chests/galats", Vec(spawnPos), MY_OWNER);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Main_FirstThink();
		Trigger_FirstThink();
		Waypoints_FirstThink();
		WarpPlayer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_menu_main") { OnExtMenuMain(); return true; }
		if (name == "ext_menu_open") { OnExtMenuOpen(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "menu_main") { OnMenuMain(); return true; }
		if (name == "set_menu_type") { OnSetMenuType(Int(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "spawn_galats") { OnSpawnGalats(); return true; }
		return ItemsDevStaffMenusPlayer_DispatchEvent(name, params)
			|| ItemsDevStaffMenusTreasure_DispatchEvent(name, params)
			|| Trigger_DispatchEvent(name, params)
			|| Waypoints_DispatchEvent(name, params)
			|| WarpPlayer_DispatchEvent(name, params)
			|| BeamsScript::DispatchEvent(name, params);
	}
}
