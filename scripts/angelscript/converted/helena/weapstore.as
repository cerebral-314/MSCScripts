#pragma context server

// Converted from helena/weapstore.script by msc_transpiler.
// Helena Weaponstore

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/helena/helena_npc.as"

[script "helena/weapstore"]
class Weapstore : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, HelenaNpc
{
	// Constants
	bool NO_HAIL = true;
	bool NO_RUMOR = true;
	bool NO_JOB = true;
	bool VEND_WEAPONS = true;
	bool VEND_CONTAINERS = true;
	bool VEND_ARMORER = false;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "helena_weapstore";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.0f;
	string VEND_NEWBIE = "VEND_NEWBIE";
	string OVERCHARGE = "OVERCHARGE";
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";

	// unnamed block (first think)
	void Weapstore_FirstThink()
	{
		SOUND_DEATH = "none";

		// base_vendor
		STORE_NAME = "helena_weapstore";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
		SELL_RATIO = 0.8f;

		VEND_NEWBIE = "1";
	}

	// unnamed block (timer)
	void Weapstore_Timer()
	{
		CallEventDelayed(15.0f, "Weapstore_Timer");

		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;

		SayText("Weapons for sale!");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(1);
		SetName("Weapon Seller");
		// ov		30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_store", "buy", "trade", "sell", "purchase", "sale");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumour", "rumours", "news", "happenings");

		OVERCHARGE = RandomInt(90, 150);
		SELL_WEAPON_LEVEL = "3,6,9,12";
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Welcome to the best weapon store in town! Supplied by our own blacksmith!");
		CallEventDelayed(0.8f, "say_hi2");
	}

	// say_hi2
	void OnSayHi2()
	{
		SayText("He's famous you know! He helped fight off the orcish attacks!");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I am afraid that I do not give out jobs, I am a worker myself.");
	}

	// vendor_addstoreitems
	// //////////// Store
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|              |Quantity|	|cost%|		|Sell Ratio|
		AddStoreItem(STORE_NAME, "smallarms_knife", 4, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dagger", 3, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dirk", RandomInt(0, 1), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger2", RandomInt(0, 1), OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "smallarms_rknife", 0, OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "swords_rsword", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_shortsword", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_scimitar", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_nkatana", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_longsword", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "swords_bastardsword", 2, OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "axes_rsmallaxe", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_smallaxe", 3, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_axe", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_2haxe", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "axes_battleaxe", 2, OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "blunt_club", 1, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer1", 0, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer2", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_mace", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_warhammer", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_hammer3", 2, OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "blunt_maul", 2, OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "blunt_greatmaul", 0, OVERCHARGE, 0.5f);
		AddStoreItem(STORE_NAME, "swords_katana", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "swords_katana2", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "swords_katana3", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "swords_katana4", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "swords_skullblade", 0, OVERCHARGE, 0.4f);
		AddStoreItem(STORE_NAME, "swords_skullblade2", 0, OVERCHARGE, 0.4f);
		AddStoreItem(STORE_NAME, "swords_skullblade3", 0, OVERCHARGE, 0.4f);
		AddStoreItem(STORE_NAME, "swords_skullblade4", 0, OVERCHARGE, 0.4f);
		AddStoreItem(STORE_NAME, "smallarms_fangstooth", 0, OVERCHARGE, 0.5f);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger2", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger3", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger4", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife2", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife3", 0, OVERCHARGE, 0.6f);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife4", 0, OVERCHARGE, 0.6f);

		// Random items
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     blunt_hammer3	 	2   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     axes_battleaxe	 	2   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     axes_scythe	 	2   	    100	SELL_RATIO
		// if( $rand(1,3) == 1 ) addstoreitem  STORE_NAME     swords_longsword	 	2   	    100	SELL_RATIO
		if (RandomInt(1, 3) != 1)
			return;
		// addstoreitem STORE_NAME sheath_belt_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_dagger_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_axe_snakeskin 1 OVERCHARGE SELL_RATIO
		// addstoreitem STORE_NAME sheath_holster_snakeskin 1 OVERCHARGE SELL_RATIO
		AddStoreItem(STORE_NAME, "sheath_back_holster", 5, OVERCHARGE, SELL_RATIO);
	}

	// trade_done
	void OnTradeDone()
	{
		if (RandomInt(1, 3) != 1)
			return;
		SayText("Please, do come again some time. Might have something more interesting for you then.");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering2");
		SayText("Don't travel to the west! Dangerous things lurk out there.");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
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

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor
		HelenaNpc_OnBasevendorOfferstore(target); // helena/helena_npc
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(15.0f, "Weapstore_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Weapstore_FirstThink();
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
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Weapstore_Timer") { Weapstore_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
