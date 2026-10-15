#pragma context server

// Converted from edana/fletcher.script by msc_transpiler.
// Thothie - Arrows in wrong quantities make so can't be purchased sometimes, fixed
// - Do not use random numbers for arrow lots lest they are divisible by 15 (multiply)
// Fletcher - sells weak arrows

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/helena/helena_npc.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Fletcher
{
	// Constants
	string SOUND_DEATH = "none";
	string STORE_NAME = "edana_fletcher";
	bool STORE_SELLMENU = true;
	bool NO_HAIL = true;
	string ANIM_CHAT = "pondering";
	string ANIM_YES = "yes";
	string ANIM_NO = "no";
	bool VEND_WEAPONS = true;
	bool VEND_CONTAINERS = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string VEND_NEWBIE = "VEND_NEWBIE";
	int CANCHAT = 1;
	string THIS_MAP = "THIS_MAP";
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	bool HELENA_MODE = false;
	float ARROW_AMT = 0.0f;

	// unnamed block (first think)
	void Fletcher_FirstThink()
	{
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";

		VEND_NEWBIE = "1";
	}

	// npc_spawn
	// fail
	// include NPCs/base_arrow_storage
	// include NPCs/base_fletcher
	// Spawn properties
	void Fletcher_OnNpcSpawn(string npc = "")
	{
		SetHealth(25);
		SetGold(25);
		SetName("Bertold the Fletcher");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		CANCHAT = 1;

		THIS_MAP = ToLowerCase(MapName());

		NO_HAIL = true;
		NO_JOB = true;
		NO_RUMOR = true;

		if (THIS_MAP == "helena")
		{
			SetName("Hendlekemp, master fletcher of Helena");
			HELENA_MODE = true;
		}

		if (THIS_MAP == "gatecity")
			SetName("Soltov, the traveling fletcher");
		if (!HELENA_MODE)
			SetAngle("face", Vector3(0, 90, 0));

		if (THIS_MAP != "edana")
			return;

		NO_JOB = false;
		NO_RUMOR = false;

		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");
	}

	// vendor_addstoreitems
	void Fletcher_OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  		|Quantity|	|cost%|	|buyratio| |Stacksof|
		AddStoreItem(STORE_NAME, "proj_arrow_fire", 600, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_wooden", 600, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_broadhead", 600, 100, 0, 60);

		// addstoreitem  STORE_NAME     proj_bolt_wooden  	600 		100 0 100
		// addstoreitem  STORE_NAME     proj_bolt_fire	  	600	100 0 100
		// addstoreitem  STORE_NAME     proj_bolt_iron	300		100 0 100
		// addstoreitem  STORE_NAME     proj_bolt_steel	100		100 0 100
		AddStoreItem(STORE_NAME, "pack_quiver", 3, 100, SELL_RATIO);
		// addstoreitem  STORE_NAME     pack_xbowquiver	   	3		100 SELL_RATIO
		AddStoreItem(STORE_NAME, "bows_orcbow", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_treebow", 2, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_shortbow", 1, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "item_feather", 0, 150, SELL_RATIO);
		AddStoreItem(STORE_NAME, "proj_bolt_wooden", 100, 100, SELL_RATIO);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "proj_bolt_iron", 200, 100, SELL_RATIO);

		if (RandomInt(1, 12) == 1)
		{
			ARROW_AMT = RandomInt(1, 3) * 30.0f;
			AddStoreItem(STORE_NAME, "proj_arrow_jagged", ARROW_AMT, 500, 0.1f, 30);
			AddStoreItem(STORE_NAME, "proj_arrow_broadhead", ARROW_AMT, 500, 0.1f, 30);
		}
		// if( $rand(1,10) == 1 )
		// {
		// addstoreitem	STORE_NAME	pack_archersquiver	1		200
		// }
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORE_NAME, "proj_arrow_silvertipped", 300, 200, 0, 60);

		if (THIS_MAP == "gatecity")
		{
			AddStoreItem(STORE_NAME, "proj_arrow_holy", 60, 200, 0.1f, 30);
			if (RandomInt(1, 2) == 1)
				AddStoreItem(STORE_NAME, "proj_bolt_fire", 25, 200, 0, 25);
		}
	}

	// trade_success
	void Fletcher_OnTradeSuccess()
	{
		if (CANCHAT != 1)
			return;

		Say("goods[.34]", "[.24]", "[.35]", "[.40]");
		CANCHAT = 0;
		CallEventDelayed(10.0f, "resetchat");
	}

	// resetchat
	void Fletcher_OnResetchat()
	{
		CANCHAT = 1;
	}

	// say_job
	// CHIT CHAT
	void Fletcher_OnSayJob(CBasePlayer@ player = null)
	{
		if (HELENA_MODE)
			return;
		SayText("Sorry lad I do all my work at home and have no need for an aide, maybe the armourer could find a place for you?");
	}

	// say_rumor
	// Rumours
	void Fletcher_OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		if (HELENA_MODE)
			return;

		PlayAnim("once", "pondering");
		OnSayRumour2();
	}

	// say_rumour2
	void Fletcher_OnSayRumour2()
	{
		SayText("Krythos lacks some confidence in himself and his goods, and he keeps high prices.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

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

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		Fletcher_OnSayRumor(talkingPlayer);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor
		Fletcher_OnNpcSpawn(npc);
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

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor
		Fletcher_OnTradeSuccess();
	}

	void OnVendorAddstoreitems() { Fletcher_OnVendorAddstoreitems(); } // vendor_addstoreitems
	void OnResetchat() { Fletcher_OnResetchat(); } // resetchat
	void OnSayJob(CBasePlayer@ player = null) { Fletcher_OnSayJob(player); } // say_job
	void OnSayRumour2() { Fletcher_OnSayRumour2(); } // say_rumour2

	// This file's events and timers by their .script names
	bool Fletcher_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "edana/fletcher"]
shared class FletcherScript : BaseNpcScript, Fletcher, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, HelenaNpc
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/goods.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Fletcher_FirstThink();
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
		return Fletcher_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
