#pragma context server

// Converted from thornlands_north/amaex.script by msc_transpiler.
// Amaex for thornlands_north
// Thanks Jody for the voice

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "thornlands_north/amaex"]
class Amaex : BaseNpcScript, BaseChatArray, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	bool NO_JOB = true;
	bool NO_HAIL = true;
	bool XMASS_OLD_GUY = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "healer2";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	bool SPOKE = false;

	// unnamed block (first think)
	void Amaex_FirstThink()
	{
		STORE_NAME = "healer2";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_SELLMENU = true;
	}

	// unnamed block (timer)
	void Amaex_Timer()
	{
		CallEventDelayed(25.0f, "Amaex_Timer");

		OnChatNow("Greetings, need healing?", "1.0");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetName("Amaex the Mage");
		SetHealth(100);

		SetWidth(32);
		SetHeight(72);
		SetRace("human");

		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);

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

	// speech_nightmare_thornlands
	void OnSpeechNightmareThornlands()
	{
		if (SPOKE)
			return;
		OnChatNow("Hail Adventurer! Welcome to my... eh- failed experiment.", "7", "sound:voices/thornlands_north/amaex1.wav"); // <text> [time] [anim|"none"] [event|"none"] ["clear_que"]
		OnChatNow("I've been attempting to discover a better method of teleportation.", "5", "sound:voices/thornlands_north/amaex2.wav"); // <text> [time] [anim|"none"] [event|"none"] ["clear_que"]
		OnChatNow("It's gone wrong however. And I cannot seem to dispel it.", "5", "sound:voices/thornlands_north/amaex3.wav"); // <text> [time] [anim|"none"] [event|"none"] ["clear_que"]
		OnChatNow("I'll try and tell you to stay away, but I know how you adventurers think.", "6.0", "sound:voices/thornlands_north/amaex4.wav", "open_portal"); // <text> [time] [anim|"none"] [event|"none"] ["clear_que"]
		SPOKE = true;
	}

	// open_portal
	void OnOpenPortal(CBasePlayer@ customer = null)
	{
		UseTrigger("Nightmare_Wall");
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
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
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
		CallEventDelayed(25.0f, "Amaex_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Amaex_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChatArray_FirstThink();
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
		if (name == "open_portal") { OnOpenPortal(PlayerParam(params, 0)); return true; }
		if (name == "speech_nightmare_thornlands") { OnSpeechNightmareThornlands(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "Amaex_Timer") { Amaex_Timer(); return true; }
		return BaseChatArray_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
