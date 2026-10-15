#pragma context server

// Converted from deralia/healer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "deralia/healer"]
class DeraliaHealer : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	bool NO_HAIL = true;
	bool NO_JOB = true;
	bool XMASS_OLD_GUY = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "healer1";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	string CURRENT_THIEF = "\x81PNULL\x81P";

	// unnamed block (first think)
	void DeraliaHealer_FirstThink()
	{
		STORE_NAME = "healer1";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
	}

	// unnamed block (timer)
	// call for sale
	void DeraliaHealer_Timer()
	{
		CallEventDelayed(25.0f, "DeraliaHealer_Timer");

		SayText("Greetings, may I be of some aid?");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(60);
		SetGold(0);
		SetName("Gortigan the wise");
		// fov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		CURRENT_THIEF = "\x81PNULL\x81P"; // A player can't pick this name

		CatchSpeech("say_rumour", "rumours", "news", "happenings", "rumour");

		CatchSpeech("say_island", "island");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  |Quantity| |cost%|
		AddStoreItem(STORE_NAME, "health_mpotion", 30, 100);
		AddStoreItem(STORE_NAME, "health_lpotion", 30, 100);
		AddStoreItem(STORE_NAME, "scroll2_glow", 2, 150);

		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORE_NAME, "health_spotion", 3, 100);

		// removing all epic pots, pending gold reset
		// addstoreitem STORE_NAME item_crystal_reloc 5 $rand(100,200) 0.3
		// if ( $rand(1,5) == 1 ) addstoreitem	 STORE_NAME		mana_speed 1 150 0.1
		// if ( $rand(1,30) == 1 ) addstoreitem STORE_NAME mana_regen 1 150 0.1
		OnBsEpicItem();
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("Be wary adventurer, not everything can be conquered. Such as the cursed [island].");
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
		CallEventDelayed(25.0f, "DeraliaHealer_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliaHealer_FirstThink();
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
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "DeraliaHealer_Timer") { DeraliaHealer_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
