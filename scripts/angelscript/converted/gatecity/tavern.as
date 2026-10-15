#pragma context server

// Converted from gatecity/tavern.script by msc_transpiler.
// barkeep

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "gatecity/tavern"]
class Tavern : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string STORE_NAME = "gatecity_tavern";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	int STORE_CLOSED = 0;
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	int JOB = 0;
	int CANCHAT = 0;

	// unnamed block (first think)
	void Tavern_FirstThink()
	{
		// base_vendor
		STORE_CLOSED = 0;
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("Kendra has been upset recently. Maybe you can cheer her up?");
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetUniqueName("Stein");
		SetHealth(25);
		SetGold(25);
		SetName("Stein the Barkeep");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 1); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 0); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetInvincible(true);

		SetModelBody(2, 0);

		JOB = 0;
		CANCHAT = 1;
		STORE_CLOSED = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");

		OnCreatemystore();
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
			SayText("Care for a sip of ale?");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(ENT_LASTSPOKE) <= 90.0f)
			SayText("What can I get fer you?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I have all the help I could use now.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "health_apple", RandomInt(12, 15), 100);
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(3, 5), 115);
		AddStoreItem(STORE_NAME, "drink_mead", RandomInt(15, 20), 100);
		AddStoreItem(STORE_NAME, "drink_ale", RandomInt(15, 20), 100);
		AddStoreItem(STORE_NAME, "drink_wine", RandomInt(7, 10), 300);

		if (RandomInt(1, 5) != 1)
			return;
		AddStoreItem(STORE_NAME, "drink_forsuth", RandomInt(1, 2), 300);
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

	void OnCreatemystore() {} // createmystore

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tavern_FirstThink();
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
