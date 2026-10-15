#pragma context server

// Converted from edana/packmerc.script by msc_transpiler.
// Pack Merchant

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "edana/packmerc"]
class Packmerc : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	string STORE_NAME = "foglund_shop";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	bool VEND_WEAPONS = true;
	bool VEND_CONTAINERS = true;
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool CHAT_JOB = false;
	bool CHAT_GOODS = false;
	int CANCHAT = 0;
	string AD_TEXT = "AD_TEXT";

	// unnamed block (first think)
	void Packmerc_FirstThink()
	{
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		SELL_WEAPON_LEVEL = "0,3";

		VEND_NEWBIE = "1";
	}

	// unnamed block (timer)
	// /////////////////////////////////////////////////////////
	// Greeting players
	void Packmerc_Timer()
	{
		CallEventDelayed(1.0f, "Packmerc_Timer");

		if (CANCHAT == 0)
			return;
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;

		SayText(AD_TEXT);
		Say("[.6]", "[.6]", "[.6]");
		OnNoChat();
		CallEventDelayed(90.0f, "reset_chat");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour();
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
		SetGold(25);
		SetName("Foglund the Merchant");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 2);
		SetInvincible(true);

		CHAT_JOB = false;
		CHAT_GOODS = false;
		CANCHAT = 1;

		if (MapName() != "lowlands")
			AD_TEXT = "Backpacks! Sheaths! Torches!";
		if (MapName() == "lowlands")
			AD_TEXT = "I do hope you can help me with my little bear problem...";

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_store", "buy", "trade", "sell", "purchase", "sale");
		CatchSpeech("say_rumour", "heard", "rumor", "rumour", "news", "happening");
		CatchSpeech("say_job", "work", "job");
		CatchSpeech("say_bear", "bear");
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (!CHAT_GOODS)
			return;

		Say("goods[.34]", "[.24]", "[.35]", "[.40]");
		OnNoChat();
		CHAT_GOODS = false;
		CallEventDelayed(6.0f, "reset_chat_goods");
	}

	// say_bear
	void OnSayBear()
	{
		SayText("I hate bears, I really do, I've an insatiable desire to buy bear parts. Got any?");
		CallEventDelayed(4.0f, "say_bear2");
	}

	// say_bear2
	void OnSayBear2()
	{
		if (MapName() != "lowlands")
			return;
		SayText("Granted, I suspect this has gotten me into a bit of trouble.");
		CallEventDelayed(4.0f, "say_bear3");
	}

	// say_bear3
	void OnSayBear3()
	{
		SayText("It is said if you kill 100 bears, the Curse of the Bear Gods will befall you.");
		CallEventDelayed(4.0f, "say_bear4");
	}

	// say_bear4
	void OnSayBear4()
	{
		SayText("Looks as though it has befallen me... I can't get outside.");
		CallEventDelayed(4.0f, "say_bear5");
	}

	// say_bear5
	void OnSayBear5()
	{
		SayText("I've no clue how I'm going to get back to Edana.");
		CallEventDelayed(4.0f, "say_bear6");
	}

	// say_bear6
	void OnSayBear6()
	{
		SayText("I'll give you access to my special stock, if you think you can break this curse!");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Hello, I have many things that you will need!");
		CallEventDelayed(0.0f, "2");
		OnNoChat();
	}

	// no_chat
	// Make sure I don't idle chat while player is interacting with me
	void OnNoChat()
	{
		CANCHAT = 0;
		CallEventDelayed(20.0f, "reset_chat");
	}

	// reset_chat
	void OnResetChat()
	{
		CANCHAT = 1;
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|    		|Q|		|cost%| |Sell ratio| |Bundle amt|
		string mapName = ToLowerCase(MapName());

		if (mapName == "lowlands")
		{
			AddStoreItem(STORE_NAME, "item_crystal_reloc", 1, 300, 0.1f);
			AddStoreItem(STORE_NAME, "item_crystal_return", 1, 300, 0.1f);
			AddStoreItem(STORE_NAME, "sheath_spellbook", 1, 80, SELL_RATIO);
			AddStoreItem(STORE_NAME, "skin_bear", 20, 100, 0.9f);
			AddStoreItem(STORE_NAME, "health_spotion", 10, 80, 0.5f);
			AddStoreItem(STORE_NAME, "mana_protection", 1, RandomInt(100, 150), 0.2f);
		}

		if (mapName != "lowlands")
			AddStoreItem(STORE_NAME, "skin_bear", 0, 100, 2.0f);
		AddStoreItem(STORE_NAME, "item_bearclaw", 0, 100, 0.9f);
		AddStoreItem(STORE_NAME, "swords_rsword", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_rknife", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_knife", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_treebow", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_rsmallaxe", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer1", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "polearms_qs", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "item_torch", RandomInt(5, 10), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "pack_bigsack", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", RandomInt(1, 4), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "sheath_back_holster", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_club", 0, 100, SELL_RATIO);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "blunt_club", 1, 100, SELL_RATIO);
	}

	// reset_chat_goods
	void OnResetChatGoods()
	{
		CHAT_GOODS = true;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Well I'm just a small shop owner with no need for help, maybe Ike could help ye out?");
		Say("[.5]", "[.4]", "[.2]", "[.1]", "[.4]", "[.4]", "[.2]", "[.2]", "[.4]", "[.1][.2]", "[.2]", "[.8]", "[.2]", "[.2]", "[.4]", "[.6]", "[.4]", "[.2]");
		OnNoChat();
		CallEventDelayed(15.0f, "reset_chat_job");
	}

	// reset_chat_job
	void OnResetChatJob()
	{
		CHAT_JOB = true;
	}

	// say_rumour
	void OnSayRumour(string speaker = "")
	{
		OnNoChat();
		PlayAnim("once", "no");
		SayText("I don't know much. Speak to Krythos. He've been all over the world.");
		Say("[.2]", "[.2]", "[.2]", "[.5]", "[.3]", "[.1]", "[.15]", "[.6]", "[.4]", "[.4][.2]", "[.2]", "[.2]", "[.3]", "[1]");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/goods.wav");
		CallEventDelayed(1.0f, "Packmerc_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Packmerc_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseNpcVendorConfirm_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "no_chat") { OnNoChat(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "reset_chat") { OnResetChat(); return true; }
		if (name == "reset_chat_goods") { OnResetChatGoods(); return true; }
		if (name == "reset_chat_job") { OnResetChatJob(); return true; }
		if (name == "say_bear") { OnSayBear(); return true; }
		if (name == "say_bear2") { OnSayBear2(); return true; }
		if (name == "say_bear3") { OnSayBear3(); return true; }
		if (name == "say_bear4") { OnSayBear4(); return true; }
		if (name == "say_bear5") { OnSayBear5(); return true; }
		if (name == "say_bear6") { OnSayBear6(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Packmerc_Timer") { Packmerc_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
