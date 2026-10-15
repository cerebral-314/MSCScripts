#pragma context server

// Converted from other/keyhole.script by msc_transpiler.
// Thothie - Modified to take one of two keys, and call ustart for compatiblity
// - This key hole should be universal - it'll take any key
// - It will fire ustart, and an event matching the key name used
// - If someone creates more keys please expand this accordingly

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherKeyhole
{
	// Variables (an unset .script variable reads as its own name)
	bool KEY_USED = false;

	// game_spawn
	void OtherKeyhole_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("keyhole");
		SetWidth(2);
		SetHeight(16);
		SetRoam(false);
		SetModel("misc/keyhole.mdl");
		SetInvincible(true);
		KEY_USED = false;
		SetFly(true); // suspend in air where placed
		LegacyCommand("float", 1);

		SetMenuAutoOpen(true);
	}

	// rusty_use_the_key
	void OtherKeyhole_OnRustyUseTheKey()
	{
		// if KEY_USED equals 0
		ReceiveOffer("accept");
		UseTrigger("item_key_rusty", "ustart");
	}

	// storage_use_the_key
	void OtherKeyhole_OnStorageUseTheKey()
	{
		// if KEY_USED equals 0
		ReceiveOffer("accept");
		UseTrigger("item_storageroomkey", "ustart");
	}

	// game_menu_getoptions
	void OtherKeyhole_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_key_rusty")))
		{
			menuItem.title = "Use the rusty key";
			menuItem.type = "payment";
			menuItem.data = "item_key_rusty";
			menuItem.callback = "rusty_use_the_key";
			RegisterMenuItem(menuItem);
		}
	}

	// game_menu_getoptions
	void OtherKeyhole_OnGameMenuGetoptions_2(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_storageroomkey")))
		{
			menuItem.title = "Use the storage key";
			menuItem.type = "payment";
			menuItem.data = "item_storageroomkey";
			menuItem.callback = "storage_use_the_key";
			RegisterMenuItem(menuItem);
		}

		// New Keys
		if (Truthy(ItemExists(player, "key_red")))
		{
			menuItem.title = "Use the crimson key";
			menuItem.type = "payment";
			menuItem.data = "key_red";
			menuItem.callback = "key_red";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_blue")))
		{
			menuItem.title = "Use the sapphire key";
			menuItem.type = "payment";
			menuItem.data = "key_blue";
			menuItem.callback = "key_blue";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_green")))
		{
			menuItem.title = "Use the emerald key";
			menuItem.type = "payment";
			menuItem.data = "key_green";
			menuItem.callback = "key_green";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_skeleton")))
		{
			menuItem.title = "Use the skeleton key";
			menuItem.type = "payment";
			menuItem.data = "key_skeleton";
			menuItem.callback = "key_skeleton";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_brass")))
		{
			menuItem.title = "Use the brass key";
			menuItem.type = "payment";
			menuItem.data = "key_brass";
			menuItem.callback = "key_brass";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_gold")))
		{
			menuItem.title = "Use the gold key";
			menuItem.type = "payment";
			menuItem.data = "key_gold";
			menuItem.callback = "key_gold";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_treasury")))
		{
			menuItem.title = "Use the treasury key";
			menuItem.type = "payment";
			menuItem.data = "key_treasury";
			menuItem.callback = "key_treasury";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_forged")))
		{
			menuItem.title = "Use the forged key";
			menuItem.type = "payment";
			menuItem.data = "key_forged";
			menuItem.callback = "key_forged";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "key_ice")))
		{
			menuItem.title = "Use the ice key";
			menuItem.type = "payment";
			menuItem.data = "key_ice";
			menuItem.callback = "key_ice";
			RegisterMenuItem(menuItem);
		}
	}

	// key_red
	void OtherKeyhole_OnKeyRed(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_red", "ustart");
	}

	// key_blue
	void OtherKeyhole_OnKeyBlue(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_blue", "ustart");
	}

	// key_green
	void OtherKeyhole_OnKeyGreen(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_green", "ustart");
	}

	// key_skeleton
	void OtherKeyhole_OnKeySkeleton(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_skeleton", "ustart");
	}

	// key_brass
	void OtherKeyhole_OnKeyBrass(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_brass", "ustart");
	}

	// key_gold
	void OtherKeyhole_OnKeyGold(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_gold", "ustart");
	}

	// key_treasury
	void OtherKeyhole_OnKeyTreasury(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_treasury", "ustart");
	}

	// key_forged
	void OtherKeyhole_OnKeyForged(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_forged", "ustart");
	}

	// key_ice
	void OtherKeyhole_OnKeyIce(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_forged", "ustart");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { OtherKeyhole_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnRustyUseTheKey() { OtherKeyhole_OnRustyUseTheKey(); } // rusty_use_the_key
	void OnStorageUseTheKey() { OtherKeyhole_OnStorageUseTheKey(); } // storage_use_the_key

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		OtherKeyhole_OnGameMenuGetoptions(player);
		OtherKeyhole_OnGameMenuGetoptions_2(player);
	}

	void OnKeyRed(CBasePlayer@ player = null) { OtherKeyhole_OnKeyRed(player); } // key_red
	void OnKeyBlue(CBasePlayer@ player = null) { OtherKeyhole_OnKeyBlue(player); } // key_blue
	void OnKeyGreen(CBasePlayer@ player = null) { OtherKeyhole_OnKeyGreen(player); } // key_green
	void OnKeySkeleton(CBasePlayer@ player = null) { OtherKeyhole_OnKeySkeleton(player); } // key_skeleton
	void OnKeyBrass(CBasePlayer@ player = null) { OtherKeyhole_OnKeyBrass(player); } // key_brass
	void OnKeyGold(CBasePlayer@ player = null) { OtherKeyhole_OnKeyGold(player); } // key_gold
	void OnKeyTreasury(CBasePlayer@ player = null) { OtherKeyhole_OnKeyTreasury(player); } // key_treasury
	void OnKeyForged(CBasePlayer@ player = null) { OtherKeyhole_OnKeyForged(player); } // key_forged
	void OnKeyIce(CBasePlayer@ player = null) { OtherKeyhole_OnKeyIce(player); } // key_ice

	// This file's events and timers by their .script names
	bool OtherKeyhole_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "key_blue") { OnKeyBlue(PlayerParam(params, 0)); return true; }
		if (name == "key_brass") { OnKeyBrass(PlayerParam(params, 0)); return true; }
		if (name == "key_forged") { OnKeyForged(PlayerParam(params, 0)); return true; }
		if (name == "key_gold") { OnKeyGold(PlayerParam(params, 0)); return true; }
		if (name == "key_green") { OnKeyGreen(PlayerParam(params, 0)); return true; }
		if (name == "key_ice") { OnKeyIce(PlayerParam(params, 0)); return true; }
		if (name == "key_red") { OnKeyRed(PlayerParam(params, 0)); return true; }
		if (name == "key_skeleton") { OnKeySkeleton(PlayerParam(params, 0)); return true; }
		if (name == "key_treasury") { OnKeyTreasury(PlayerParam(params, 0)); return true; }
		if (name == "rusty_use_the_key") { OnRustyUseTheKey(); return true; }
		if (name == "storage_use_the_key") { OnStorageUseTheKey(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/keyhole"]
shared class OtherKeyholeScript : ScriptEntity, OtherKeyhole
{
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
		return OtherKeyhole_DispatchEvent(name, params);
	}
}
