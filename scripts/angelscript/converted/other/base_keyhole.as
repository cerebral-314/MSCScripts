#pragma context server

// Converted from other/base_keyhole.script by msc_transpiler.
// Base Keyhole by Thothie
// - To make it easier to add individual keyholes
// KEY_NAME //scriptname for item to accept
// KEYHOLE_NAME
// KEYHOLE_TITLE
// RETURN_KEY

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseKeyhole
{
	// Variables (an unset .script variable reads as its own name)
	bool RETURN_KEY = false;

	// game_spawn
	void BaseKeyhole_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName(KEYHOLE_NAME);
		SetWidth(5);
		SetHeight(16);
		SetRoam(false);
		SetModel("misc/keyhole.mdl");
		SetInvincible(true);
		SetFly(true); // suspend in air where placed
		LegacyCommand("float", 1);
		SetSolid("none"); // Will block doors sometimes.
		SetNoPush(true);

		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void BaseKeyhole_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (Truthy(ItemExists(player, KEY_NAME)))
		{
			menuItem.title = KEYHOLE_TITLE;
			menuItem.type = "payment";
			menuItem.data = KEY_NAME;
			menuItem.callback = "key_used";
			RegisterMenuItem(menuItem);
		}
	}

	// key_used
	// PARAM1 = PlayerID , PARAM2 = keyname
	void BaseKeyhole_OnKeyUsed(CBasePlayer@ playerId = null)
	{
		UseTrigger(KEY_NAME);
		if (RETURN_KEY)
			Offer(playerId, KEY_NAME);
	}

	// return_keys
	void BaseKeyhole_OnReturnKeys()
	{
		// called from external ms_npcscript
		RETURN_KEY = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseKeyhole_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseKeyhole_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnKeyUsed(CBasePlayer@ playerId = null) { BaseKeyhole_OnKeyUsed(playerId); } // key_used
	void OnReturnKeys() { BaseKeyhole_OnReturnKeys(); } // return_keys

	// This file's events and timers by their .script names
	bool BaseKeyhole_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "key_used") { OnKeyUsed(PlayerParam(params, 0)); return true; }
		if (name == "return_keys") { OnReturnKeys(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/base_keyhole"]
shared class BaseKeyholeScript : ScriptEntity, BaseKeyhole
{
	// Variables every script that includes this file declares
	string KEYHOLE_NAME = "KEYHOLE_NAME";
	string KEYHOLE_TITLE = "KEYHOLE_TITLE";
	string KEY_NAME = "KEY_NAME";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/keyhole.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseKeyhole_DispatchEvent(name, params);
	}
}
