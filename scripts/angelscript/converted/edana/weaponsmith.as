#pragma context server

// Converted from edana/weaponsmith.script by msc_transpiler.
// Krythos the weaponsmith

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "edana/weaponsmith"]
class Weaponsmith : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	bool VEND_WEAPONS = true;
	bool VEND_CONTAINERS = true;
	bool NO_CHAT = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "edana_kyrthos";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";
	int CIDER = 0;

	// unnamed block (first think)
	void Weaponsmith_FirstThink()
	{
		SOUND_DEATH = "none";

		// base_vendor
		STORE_NAME = "edana_kyrthos";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
		SELL_RATIO = 0.75f;
		SELL_WEAPON_LEVEL = "3,6,9,12";

		VEND_NEWBIE = "1";
	}

	// unnamed block (timer)
	void Weaponsmith_Timer()
	{
		CallEventDelayed(15.0f, "Weaponsmith_Timer");

		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;

		SayText("WEAPONS FOR SAAAAALLLLLLLEEEEE!!!!!!");
	}

	// say_rumor
	// Rumours
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		PlayAnim("once", "pondering2");
		SayText("Helena is starting to become a fair sized city, their armourer is finally able to make all of his own weapons.");
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetUniqueName("krythos");
		SetHealth(25);
		SetGold(50);
		SetName("Krythos the Weaponsmith");
		// ov		30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/blacksmith.mdl");
		SetInvincible(true);
		CIDER = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_store", "buy", "trade", "sell", "purchase", "sale");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_cider", "cider");
		CatchSpeech("say_rumor", "rumours", "news", "happenings");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Welcome to my humble shop, I sell all kinds of adventuring stuffs.");
		CallEventDelayed(0.8f, "say_hi2");
	}

	// say_hi2
	void OnSayHi2()
	{
		SayText("Can I interest you in anything?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("You don't look like a member of the Merchant's Guild, and I can't afford to hire non-guild workers.");
	}

	// vendor_addstoreitems
	// //////////// Store
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|              |Quantity|  |cost%|	|Sell Ratio|
		AddStoreItem(STORE_NAME, "smallarms_rknife", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_knife", 3, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dagger", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dirk", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_stiletto", 0, 100, SELL_RATIO);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "smallarms_stiletto", 1, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "swords_rsword", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_shortsword", 3, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_scimitar", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_longsword", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_bastardsword", 0, 100, SELL_RATIO);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "swords_bastardsword", 1, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "axes_rsmallaxe", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_smallaxe", 3, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_axe", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_2haxe", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_battleaxe", 0, 100, SELL_RATIO);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "axes_battleaxe", 1, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "blunt_club", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer1", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer2", 3, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_mace", 2, 100, SELL_RATIO);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "blunt_warhammer", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer3", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_maul", 0, 100, SELL_RATIO);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "blunt_maul", 1, 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "polearms_qs", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "polearms_sp", RandomInt(1, 5), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "sheath_back_holster", 2, 100, SELL_RATIO);

		// Random items
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     blunt_hammer3	 	1   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     axes_battleaxe	 	1   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     axes_scythe	 	1   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     swords_longsword	 	1   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     axes_2haxe	 	1   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     blunt_maul	 	1   	    100	SELL_RATIO
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "blunt_gauntlets_leather", 1, 100, SELL_RATIO);
	}

	// trade_done
	void OnTradeDone()
	{
		if (RandomInt(1, 3) != 1)
			return;
		SayText("Please, do come again some time. Might have something more interesting for you then.");
	}

	// cider4
	// ----------ciderquest
	void OnCider4()
	{
		CIDER = 1;
	}

	// say_cider
	void OnSayCider()
	{
		if (CIDER != 1)
			return;
		PlayAnim("once", "converse2");
		SayText("Ah yes, the shipment was waylaid so I had to arrange another, I've already sent a messenger.");
		CallEventDelayed(0.0f, "3");
	}

	// say_cider2
	void OnSayCider2()
	{
		SayText("She must have gotten anxious. Sorry for the touble. Head back to her for your reward");
		CIDER = 99;
		CallExternal(FindByName("wench"), "ciderreward");
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
		Precache("npc/blacksmith.mdl");
		CallEventDelayed(15.0f, "Weaponsmith_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Weaponsmith_FirstThink();
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
		if (name == "cider4") { OnCider4(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_cider") { OnSayCider(); return true; }
		if (name == "say_cider2") { OnSayCider2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Weaponsmith_Timer") { Weaponsmith_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
