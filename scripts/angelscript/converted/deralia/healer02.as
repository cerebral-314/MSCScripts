#pragma context server

// Converted from deralia/healer02.script by msc_transpiler.
// Thothie - seems there should be a spell vender in this massive library
// - Also seems Deralia needs a Fletcher, but that's a job for Ripent

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "deralia/healer02"]
class Healer02 : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	bool NO_JOB = true;
	bool NO_HAIL = true;
	bool XMASS_OLD_GUY = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "healer2";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;

	// unnamed block (first think)
	void Healer02_FirstThink()
	{
		STORE_NAME = "healer2";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
	}

	// unnamed block (timer)
	// call for sale
	void Healer02_Timer()
	{
		CallEventDelayed(25.0f, "Healer02_Timer");

		SayText("Greetings, need healing?");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(1);
		SetName("Melhar the pure");
		// fov		30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);

		CatchSpeech("say_rumour", "rumours", "news", "happenings", "rumour");

		CatchSpeech("say_island", "island");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|          |Quantity| |cost%|
		AddStoreItem(STORE_NAME, "health_mpotion", 30, 100);
		AddStoreItem(STORE_NAME, "health_lpotion", 30, 100);
		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORE_NAME, "mana_protection", 2, 150, 0.1f);

		// if ( $rand(1,10) == 1 ) addstoreitem	 STORE_NAME		mana_gprotection 1 150 0.1
		if (RandomInt(1, 3) == 1)
		{
			AddStoreItem(STORE_NAME, "health_spotion", 3, 100);
			AddStoreItem(STORE_NAME, "scroll2_fire_dart", 1, 200);
			AddStoreItem(STORE_NAME, "scroll2_lightning_weak", 1, 200);
		}
		AddStoreItem(STORE_NAME, "scroll2_rejuvenate", 1, 400);

		AddStoreItem(STORE_NAME, "item_crystal_return", 1, RandomInt(100, 200), 0.3f);

		OnBsEpicItem();
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("I always aggree with Gortigan on this one. Stay AWAY from the [island].");
	}

	// say_island
	void OnSayIsland()
	{
		PlayAnim("once", "pondering");
		SayText("Yes, the harbour master often takes requests to sail there. Many do not return.");
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

	void OnBsEpicItem() {} // bs_epic_item

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
		CallEventDelayed(25.0f, "Healer02_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Healer02_FirstThink();
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
		if (name == "say_island") { OnSayIsland(); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Healer02_Timer") { Healer02_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
