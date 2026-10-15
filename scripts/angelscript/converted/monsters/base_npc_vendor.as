#pragma context server

// Converted from monsters/base_npc_vendor.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/help/first_vendor.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseNpcVendor
{
	// Constants
	bool STORE_RESTOCK = true;
	int STORE_RESTOCK_TIME_LO = 300;
	int STORE_RESTOCK_TIME_HI = 600;
	string BUSY_COMMENT = "One at a time, please.";

	// Variables (an unset .script variable reads as its own name)
	bool HAS_INCLUDE_VENDOR = true;
	string STORE_TRADEEXT = "STORE_TRADEEXT";
	string STORE_BUYMENU = "STORE_BUYMENU";
	bool VENDOR_STORE_ACTIVE = false;
	string VENDOR_TARGET = "VENDOR_TARGET";
	string VEND_PREFIX = "VEND_PREFIX";
	string STORE_NAME = "STORE_NAME";
	bool VEND_NO_GOODBYE = false;

	// unnamed block (first think)
	// Standard npc which will sell you items
	// Definitions required:
	// STORE_NAME 		(Default: "mystore" )
	// STORE_TRADEEXT 	(Default: "trade")
	// STORE_SELLMENU	(Default: "0")
	// (STORE_TRIGGERTEXT is no longer used, as the implementation was buggy)
	void BaseNpcVendor_FirstThink()
	{
		HAS_INCLUDE_VENDOR = true;
	}

	// unnamed block (first think)
	void BaseNpcVendor_FirstThink2()
	{
		// Defaults
		if (STORE_TRADEEXT == "STORE_TRADEEXT")
			STORE_TRADEEXT = "trade";
		if (STORE_BUYMENU == "STORE_BUYMENU")
			STORE_BUYMENU = "1";
	}

	// game_spawn
	void BaseNpcVendor_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// note: "buy" does not work here - no clue as to why
		CatchSpeech("npc_say_store", "store", "trade", "buy", "sell", "purchase", "sale", "offer");

		CallEventDelayed(0.1f, "vendor_setup_store");

		if (Eval("game.monster.race") != "human")
			return;
		SetModelBody(0, 3);
	}

	// vendor_setup_store
	void BaseNpcVendor_OnVendorSetupStore()
	{
		if (Truthy(GetVar("VEND_INDIVIDUAL")))
			return;
		LegacyCommand("npcstore.create", STORE_NAME);

		CallEventDelayed(1.0f, "vendor_addstoreitems");
	}

	// npc_spawn
	void BaseNpcVendor_OnNpcSpawn(string npc = "")
	{
		if (Eval("game.monster.race") != "human")
			return;
		SetModelBody(0, 3);
	}

	// game_menu_getoptions
	void BaseNpcVendor_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		OnVendorAddstoremenu();
	}

	// vendor_addstoremenu
	void BaseNpcVendor_OnVendorAddstoremenu()
	{
		MenuItem menuItem;

		if (Truthy(GetVar("VENDOR_MENU_OFF")))
			return;

		menuItem.id = "genericstore";
		menuItem.priority = "-100";
		SetLocal("reg.mitem.access", "all");

		if (!Truthy(GetVar("STORE_CLOSED")))
		{
			if (GetVar("VEND_CHAT_MODE") != "weapons")
			{
				menuItem.title = "Shop";
				menuItem.type = "callback";
				menuItem.callback = "vendor_offerstore";
			}
		}
		else
		{
			menuItem.title = "Closed";
			menuItem.type = "disabled";
		}

		RegisterMenuItem(menuItem);
	}

	// game_playerused
	// Player pressed '+use' on me
	void BaseNpcVendor_OnGamePlayerused(CBasePlayer@ player = null)
	{
		OnVendorUsed();
		if (Truthy(GetVar("VENDOR_NOT_ON_USE")))
			return;
		OnVendorOfferstore(ToPlayer(EntityOf(ENT_LASTUSED)));
	}

	// npc_say_store
	// Player said my keyword
	void BaseNpcVendor_OnNpcSayStore()
	{
		OnVendorOfferstore(ToPlayer(EntityOf(ENT_LASTSPOKE)));
	}

	// vendor_offerstore
	// Offer store to a player
	// Gives parent script chance to override this and cancel the tranaction
	// 1: Offer Target
	void BaseNpcVendor_OnVendorOfferstore(CBasePlayer@ player = null)
	{
		DebugPrint("vendor_offerstore to " + NameOf(player));
		// if !VENDOR_STORE_ACTIVE //disable since it is unreliable.
		VENDOR_STORE_ACTIVE = true;

		if (!Truthy(GetVar("STORE_CLOSED")))
		{
			VENDOR_TARGET = EntityId(player);
			if (Float(GetVar("VENDOR_DELAY")) > 0.0f)
			{
				// for vendors that may need to adjust stores based on quest data, and such
				CallEventOrDelay(GetVar("VENDOR_DELAY"), "basevendor_offerstore");
			}
			else
			{
				OnBasevendorOfferstore();
			}
		}
		else
		{
			OnVendorSayClosed();
			VENDOR_STORE_ACTIVE = false;
		}
	}

	// vendor_fail
	void BaseNpcVendor_OnVendorFail()
	{
		VENDOR_STORE_ACTIVE = false;
	}

	// basevendor_offerstore
	// 1: Offer Target
	void BaseNpcVendor_OnBasevendorOfferstore(string target = "")
	{
		if (!target.isEmpty())
			VENDOR_TARGET = target;

		string service = "0";
		if (Truthy(STORE_BUYMENU))
			service = "buy";
		if (Truthy(GetVar("STORE_SELLMENU")))
			service += ";sell";

		// Warns player about level restricted weapons
		if (Float(GetVar("SELL_WEAPON_LEVEL")) > 0.0f)
			PlayerMessageGreen(VENDOR_TARGET, "This vendor's weapons require proficiency level  " + GetVar("SELL_WEAPON_LEVEL"));

		if (!Truthy(GetVar("VEND_INDIVIDUAL")))
		{
			LegacyCommand("npcstore.offer", STORE_NAME, VENDOR_TARGET, service, "trade");
		}
		else
		{
			// check if indivual store exists, if not, build store
			if (VEND_PREFIX == "VEND_PREFIX")
			{
				VEND_PREFIX = STORE_NAME;
				ArrayCreate("ARRAY_STORES");
				DebugPrint("basevendor_offerstore initiated array");
			}

			string targetStore = VEND_PREFIX + SteamIdOf(VENDOR_TARGET);

			if (ArrayFind("ARRAY_STORES", targetStore) > -1)
			{
				DebugPrint("basevendor_offerstore setupstore " + targetStore);
				LegacyCommand("npcstore.offer", targetStore, VENDOR_TARGET, service, "trade");
			}
			else
			{
				HelpTip(VENDOR_TARGET, "generic", "Individualized Store", "This merchant shows a seperate inventory for each player.");
				ArrayAdd("ARRAY_STORES", targetStore);
				STORE_NAME = targetStore;
				LegacyCommand("npcstore.create", STORE_NAME);
				OnVendorAddstoreitems();
				LegacyCommand("npcstore.offer", STORE_NAME, VENDOR_TARGET, service, "trade");
			}
		}
	}

	// trade_busy
	// Restock items after the level's been going a while
	// Restock means delete all store items and restock them
	// Thothie AUG2010_15 - offing this: intensive, and potentially problematic
	// {
	// repeatdelay $randf(STORE_RESTOCK_TIME_LO,STORE_RESTOCK_TIME_HI)
	// if STORE_RESTOCK
	// npcstore.remove STORE_NAME allitems
	// callevent vendor_addstoreitems
	// }
	void BaseNpcVendor_OnTradeBusy(string player = "")
	{
		if (!IsAlive(player))
			return;
		if (!(RangeTo(player) < 256.0f))
			return;
		SayText(BUSY_COMMENT);
	}

	// trade_success
	void BaseNpcVendor_OnTradeSuccess()
	{
		VENDOR_STORE_ACTIVE = false;
	}

	// vendor_store_reset
	void BaseNpcVendor_OnVendorStoreReset()
	{
		LegacyCommand("npcstore.remove", STORE_NAME, "allitems");
		CallEventDelayed(0.1f, "vendor_addstoreitems");
	}

	// vendor_clear
	void BaseNpcVendor_OnVendorClear()
	{
		LegacyCommand("npcstore.remove", STORE_NAME, "allitems");
	}

	// game_confirm_buy
	// <owner_id> <item_name> <scriptname> <skill_type>
	void BaseNpcVendor_OnGameConfirmBuy(CBasePlayer@ player = null, string itemName = "", string itemScript = "", string skill = "", string stat = "")
	{
		DebugPrint("game_confirm_buy id " + EntityId(player) + " script " + itemName + " cost " + itemScript + " disp " + skill + " stat " + stat);

		string itemStat = "skill." + skill;

		// local USER_SKILL $get(%VENDOR_USER%,ITEM_STAT)
		SayText("I do not think you yet have the skill to use a " + itemName + " properly.");
		SayText("You might consider buying one of my other " + skill + " items instead.");
		VEND_NO_GOODBYE = true; // Tells some older vendor scripts not to use their "please come again" line.

		if (Float(GetVar("SELL_WEAPON_LEVEL")) > 0.0f && ToLowerCase(MapName()) != "edana")
		{
			string msgText = "This vendor offers weapons requiring levels " + GetVar("SELL_WEAPON_LEVEL");
			InfoMessage(player, "VENDOR LEVEL");
		}

		if (Truthy(GetVar("HAS_BASE_CHAT_INCLUDE")))
			OnBchatMouthMove();
		if (Truthy(GetVar("HAS_BASE_CHAT_ARRAY_INCLUDE")))
			OnChatMouthMove();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseNpcVendor_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnVendorSetupStore() { BaseNpcVendor_OnVendorSetupStore(); } // vendor_setup_store
	void OnNpcSpawn(string npc = "") { BaseNpcVendor_OnNpcSpawn(npc); } // npc_spawn
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseNpcVendor_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnVendorAddstoremenu() { BaseNpcVendor_OnVendorAddstoremenu(); } // vendor_addstoremenu
	void OnGamePlayerused(CBasePlayer@ player = null) { BaseNpcVendor_OnGamePlayerused(player); } // game_playerused
	void OnNpcSayStore() { BaseNpcVendor_OnNpcSayStore(); } // npc_say_store
	void OnVendorOfferstore(CBasePlayer@ player = null) { BaseNpcVendor_OnVendorOfferstore(player); } // vendor_offerstore
	void OnVendorFail() { BaseNpcVendor_OnVendorFail(); } // vendor_fail
	void OnBasevendorOfferstore(string target = "") { BaseNpcVendor_OnBasevendorOfferstore(target); } // basevendor_offerstore
	void OnTradeBusy(string player = "") { BaseNpcVendor_OnTradeBusy(player); } // trade_busy
	void OnTradeSuccess() { BaseNpcVendor_OnTradeSuccess(); } // trade_success
	void OnVendorStoreReset() { BaseNpcVendor_OnVendorStoreReset(); } // vendor_store_reset
	void OnVendorClear() { BaseNpcVendor_OnVendorClear(); } // vendor_clear
	void OnGameConfirmBuy(CBasePlayer@ player = null, string itemName = "", string itemScript = "", string skill = "", string stat = "") { BaseNpcVendor_OnGameConfirmBuy(player, itemName, itemScript, skill, stat); } // game_confirm_buy
	void OnVendorDelay() {} // VENDOR_DELAY
	void OnBchatMouthMove() {} // bchat_mouth_move
	void OnChatMouthMove() {} // chat_mouth_move
	void OnVendorAddstoreitems() {} // vendor_addstoreitems
	void OnVendorSayClosed() {} // vendor_say_closed
	void OnVendorUsed(string player = "") {} // vendor_used

	// This file's events and timers by their .script names
	bool BaseNpcVendor_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "game_confirm_buy") { OnGameConfirmBuy(PlayerParam(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_say_store") { OnNpcSayStore(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "trade_busy") { OnTradeBusy(Param(params, 0)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoremenu") { OnVendorAddstoremenu(); return true; }
		if (name == "vendor_clear") { OnVendorClear(); return true; }
		if (name == "vendor_fail") { OnVendorFail(); return true; }
		if (name == "vendor_offerstore") { OnVendorOfferstore(PlayerParam(params, 0)); return true; }
		if (name == "vendor_setup_store") { OnVendorSetupStore(); return true; }
		if (name == "vendor_store_reset") { OnVendorStoreReset(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_npc_vendor"]
shared class BaseNpcVendorScript : FirstVendorScript, BaseNpcVendor
{
	// Variables declared by included files, with the value they start with in this script
	BaseNpcVendorScript()
	{
		STORE_RESTOCK = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendorScript::DispatchEvent(name, params);
	}
}
