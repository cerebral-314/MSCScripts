#pragma context server

// Converted from other/keyhole_return.script by msc_transpiler.
// Thothie - Modified to take one of two keys, and call ustart for compatiblity
// - This key hole should be universal - it'll take any key
// - It will fire ustart, and an event matching the key name used
// - If someone creates more keys please expand this accordingly
// - This keyhole will return any key used

#include "runtime/ScriptEntity.as"

[script "other/keyhole_return"]
class KeyholeReturn : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool KEY_USED = false;

	// game_menu_getoptions
	void KeyholeReturn_OnGameMenuGetoptions(CBasePlayer@ player = null)
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
	void KeyholeReturn_OnGameMenuGetoptions_2(CBasePlayer@ player = null)
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
			menuItem.title = "Use the saphire key";
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

	// spawn
	void OnSpawn()
	{
		SetName("keyhole");
		SetWidth(8);
		SetHeight(32);
		SetRoam(false);
		SetModel("props/skullprop.mdl");
		SetInvincible(true);
		KEY_USED = false;
		SetFly(true); // suspend in air where placed
		LegacyCommand("float", 1);
		SetMenuAutoOpen(true);
	}

	// rusty_use_the_key
	void OnRustyUseTheKey()
	{
		// if KEY_USED equals 0
		ReceiveOffer("accept");
		UseTrigger("item_key_rusty", "ustart");
		Offer("KEY_MASTAH", "item_key_rusty");
	}

	// storage_use_the_key
	void OnStorageUseTheKey()
	{
		// if KEY_USED equals 0
		ReceiveOffer("accept");
		UseTrigger("item_storageroomkey", "ustart");
		Offer("KEY_MASTAH", "item_storageroomkey");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		KeyholeReturn_OnGameMenuGetoptions(player);
		KeyholeReturn_OnGameMenuGetoptions_2(player);
	}

	// game_recvoffer_item
	void OnGameRecvofferItem(string itemScript = "")
	{
		SetModelBody(0, 1);
	}

	// key_red
	void OnKeyRed(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_red", "ustart");
		Offer(player, "key_red");
	}

	// key_blue
	void OnKeyBlue(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_blue", "ustart");
		Offer(player, "key_blue");
	}

	// key_green
	void OnKeyGreen(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_green", "ustart");
		Offer(player, "key_green");
	}

	// key_skeleton
	void OnKeySkeleton(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_skeleton", "ustart");
		Offer(player, "key_skeleton");
	}

	// key_brass
	void OnKeyBrass(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_brass", "ustart");
		Offer(player, "key_brass");
	}

	// key_gold
	void OnKeyGold(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_gold", "ustart");
		Offer(player, "key_gold");
	}

	// key_treasury
	void OnKeyTreasury(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_treasury", "ustart");
		Offer(player, "key_treasury");
	}

	// key_forged
	void OnKeyForged(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_forged", "ustart");
		Offer(player, "key_forged");
	}

	// key_ice
	void OnKeyIce(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		UseTrigger("key_forged", "ustart");
		Offer(player, "key_ice");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("props/skullprop.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_recvoffer_item") { OnGameRecvofferItem(Param(params, 0)); return true; }
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
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "storage_use_the_key") { OnStorageUseTheKey(); return true; }
		return false;
	}
}
