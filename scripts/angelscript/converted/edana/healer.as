#pragma context server

// Converted from edana/healer.script by msc_transpiler.
// Healer - sells weak potions and weak spells

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "edana/healer"]
class EdanaHealer : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "edana_healer";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	int EVIDENCE_FOUND = 0;

	// unnamed block (first think)
	void EdanaHealer_FirstThink()
	{
		// base_vendor
		STORE_NAME = "edana_healer";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
		EVIDENCE_FOUND = 0;
	}

	// unnamed block (timer)
	// call for sale
	void EdanaHealer_Timer()
	{
		CallEventDelayed(25.0f, "EdanaHealer_Timer");

		if (!Truthy(LegacyFunction("cansee", "player", 256)))
			return;

		SayText("Puh-potions! I-I got potions!");
	}

	// say_rumor
	// Rumours
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		PlayAnim("once", "pondering");
		CallEventDelayed(1.5f, "say_rumour2");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(60);
		SetGold(0);
		SetName("Hartold the Mage");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_rumor", "rumours", "rumor", "news", "happenings");
	}

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		OnHelpVendorMagic(player);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("He- He- Howdy! How about so-some po-,po-,po-, healing items?");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  		|Quantity| 	|cost%|
		AddStoreItem(STORE_NAME, "health_mpotion", 30, 100, 0.1f);
		AddStoreItem(STORE_NAME, "health_lpotion", 30, 110, 0.1f);
		AddStoreItem(STORE_NAME, "scroll_fire_dart", RandomInt(0, 1), 120);
		AddStoreItem(STORE_NAME, "scroll_lightning_weak", RandomInt(0, 1), 120);
		AddStoreItem(STORE_NAME, "scroll2_glow", 1, 120);
		AddStoreItem(STORE_NAME, "mana_mpotion", 5, 105, 0.1f);
		AddStoreItem(STORE_NAME, "scroll_rejuvenate", 1, 200, 0.1f);
		AddStoreItem(STORE_NAME, "scroll2_rejuvenate", 1, 800, 0.1f);
		AddStoreItem(STORE_NAME, "sheath_spellbook", RandomInt(1, 2), 100, 0.1f);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "health_spotion", RandomInt(1, 4), 100);
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("I h-hear the fletcher will buy hawk f-feathers at a very high price.");
		CallEventDelayed(3.0f, "say_rumour3");
	}

	// say_rumour3
	void OnSayRumour3()
	{
		if (EVIDENCE_FOUND != 1)
			return;
		SayText("Oh! A-and the may-o-r has be-en found a trai-tor!");
	}

	// worldevent_evidence_found
	void OnWorldeventEvidenceFound()
	{
		EVIDENCE_FOUND = 1;
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
		Precache("npc/balancepriest1.mdl");
		CallEventDelayed(25.0f, "EdanaHealer_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EdanaHealer_FirstThink();
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
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "say_rumour3") { OnSayRumour3(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "worldevent_evidence_found") { OnWorldeventEvidenceFound(); return true; }
		if (name == "EdanaHealer_Timer") { EdanaHealer_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
