#pragma context server

// Converted from gatecity/hunter.script by msc_transpiler.
// Hunting Supplies merchant

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "gatecity/hunter"]
class Hunter : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string STORE_NAME = "gatecity_huntery";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	bool NO_CHAT = true;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	int STORE_CLOSED = 0;
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string SELL_WEAPON_LEVEL = "SELL_WEAPON_LEVEL";
	string VEND_NEWBIE = "VEND_NEWBIE";
	bool VEND_WEAPONS = false;
	bool VEND_CONTAINERS = false;
	bool VEND_ARMORER = false;
	int JOB = 0;
	int CANCHAT = 0;

	// unnamed block (first think)
	void Hunter_FirstThink()
	{
		// base_vendor
		STORE_CLOSED = 0;
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		SELL_WEAPON_LEVEL = "3,6";

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

		SetUniqueName("Durwyn");
		SetHealth(25);
		SetGold(25);
		SetName("Durwyn the Hunter");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
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

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("If you want some information about this area, speak with the miner in the tavern.");
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
			SayText("Get your hunting supplies!");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (STORE_CLOSED == 0 && DistanceTo(ENT_LASTSPOKE) <= 90.0f)
			SayText("Would you like a fine bow? Or perhaps a quiver?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I have everything I need right now.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "proj_arrow_wooden", 600, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_fire", 600, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_broadhead", 600, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_holy", 60, 200, 0.1f, 30);
		OnSilverTipped();

		AddStoreItem(STORE_NAME, "pack_quiver", RandomInt(1, 3), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "bows_orcbow", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_treebow", RandomInt(1, 3), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "bows_shortbow", RandomInt(1, 2), 115, SELL_RATIO);

		AddStoreItem(STORE_NAME, "smallarms_knife", RandomInt(1, 5), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "smallarms_dagger", RandomInt(1, 5), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "polearms_sp", RandomInt(0, 2), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "polearms_tri", RandomInt(0, 1), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "skin_ratpelt", 0, 130, 1.1f);
		AddStoreItem(STORE_NAME, "skin_boar", 0, 130, 1.1f);
		AddStoreItem(STORE_NAME, "skin_boar_heavy", 0, 130, 1.1f);
		AddStoreItem(STORE_NAME, "skin_bear", 0, 130, 1.1f);

		AddStoreItem(STORE_NAME, "proj_bolt_fire", 50, 300, 0, 25);
	}

	// silver_tipped
	void OnSilverTipped()
	{
		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORE_NAME, "proj_arrow_silvertipped", 300, 135, 0, 30);
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
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Hunter_FirstThink();
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
		if (name == "silver_tipped") { OnSilverTipped(); return true; }
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
