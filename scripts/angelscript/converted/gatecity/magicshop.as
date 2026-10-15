#pragma context server

// Converted from gatecity/magicshop.script by msc_transpiler.
// magic shop

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "gatecity/magicshop"]
class Magicshop : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string STORE_NAME = "gatecity_magicshop";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	bool NO_HAIL = true;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	int STORE_CLOSED = 0;
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	int JOB = 0;
	int CANCHAT = 0;

	// unnamed block (first think)
	void Magicshop_FirstThink()
	{
		// base_vendor
		STORE_CLOSED = 0;

		VEND_NEWBIE = "1";
		VEND_WEAPONS = true;
		VEND_CONTAINERS = true;
		VEND_ARMORER = false;
	}

	// game_spawn
	// Spawn properties
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm

		SetUniqueName("Galan");
		SetHealth(25);
		SetGold(25);
		SetName("Galan the Mage");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);

		JOB = 0;
		CANCHAT = 1;
		STORE_CLOSED = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");

		OnCreatemystore();
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("Goblins have been hanging around the city lately.");
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "npc/goods.wav");
		Say("[.34]", "[.24]", "[.35]", "[.40]");
		CANCHAT = 0;
		CallEventDelayed(10.0f, "resetchat");
	}

	// npcreact_targetsighted
	// /////////////////////////////////////////////////////////
	// Greeting players
	// Respond to seeing player
	void OnNpcreactTargetsighted(CBaseEntity@ player = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(player) <= 90.0f)
			SayText("Can I get you some potions?");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(ENT_LASTSPOKE) <= 90.0f)
			SayText("Would you like a potion or a new spell?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Until the Undermountains is open again, I have no need to hire you.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(25, 30), 115, 0.2f);
		AddStoreItem(STORE_NAME, "health_lpotion", RandomInt(25, 30), 115, 0.2f);
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "health_spotion", RandomInt(1, 4), 120, 0.2f);
		AddStoreItem(STORE_NAME, "mana_mpotion", RandomInt(5, 10), 120, 0.2f);
		AddStoreItem(STORE_NAME, "scroll_fire_dart", RandomInt(1, 3), 135);
		AddStoreItem(STORE_NAME, "scroll_lightning_weak", RandomInt(1, 3), 135);
		AddStoreItem(STORE_NAME, "scroll2_fire_dart", RandomInt(1, 3), 135);
		AddStoreItem(STORE_NAME, "scroll2_lightning_weak", RandomInt(1, 3), 135);
		AddStoreItem(STORE_NAME, "sheath_spellbook", RandomInt(1, 3), 135);
		AddStoreItem(STORE_NAME, "scroll2_glow", RandomInt(1, 2), 200);
		AddStoreItem(STORE_NAME, "scroll_glow", RandomInt(3, 5), 200);
		// if ( $rand(1,2) == 1 ) addstoreitem	 STORE_NAME		mana_protection 1 80 0.1
		// if ( $rand(1,10) == 1 ) addstoreitem	 STORE_NAME		mana_gprotection 1 110 0.1
		// if ( $rand(1,10) == 1 ) addstoreitem	 STORE_NAME		mana_speed 1 150 0.1
		if (RandomInt(1, 5) == 1)
		{
			AddStoreItem(STORE_NAME, "mana_resist_fire", 1, 150, 0.1f);
		}
		else
		{
			// addstoreitem STORE_NAME mana_immune_poison 1 150 0.1
			if (RandomInt(1, 15) == 1)
				AddStoreItem(STORE_NAME, "mana_resist_cold", 1, 150, 0.1f);
		}
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// vendor_say_closed
	void OnVendorSayClosed()
	{
		SayText("Sorry, I'm closed. I will reopen at seven in the morning.");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

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

	void OnCreatemystore() {} // createmystore

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Magicshop_FirstThink();
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
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcreact_targetsighted") { OnNpcreactTargetsighted(EntityParam(params, 0)); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_say_closed") { OnVendorSayClosed(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
