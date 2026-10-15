#pragma context server

// Converted from deralia/grocer.script by msc_transpiler.
// Friendly grocer

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_civilian.as"
#include "converted/monsters/base_xmass.as"

[script "deralia/grocer"]
class DeraliaGrocer : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseCivilian, BaseXmass
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string SOUND_IDLE1 = "voices/human/male_idle4.wav";
	string SOUND_IDLE2 = "voices/human/male_idle5.wav";
	string SOUND_IDLE3 = "voices/human/male_idle6.wav";
	string STORE_NAME = "deralia_grocer";
	string STORE_TRIGGERTEXT = "store";
	bool ASKED_APPLE = true;

	// unnamed block (first think)
	void DeraliaGrocer_FirstThink()
	{
		SOUND_IDLE1 = "voices/human/male_idle4.wav";
		SOUND_IDLE2 = "voices/human/male_idle5.wav";
		SOUND_IDLE3 = "voices/human/male_idle6.wav";

		STORE_NAME = "deralia_grocer"; // base_vendor
		STORE_TRIGGERTEXT = "storetradeapple"; // base_vendor
	}

	// unnamed block (timer)
	void DeraliaGrocer_Timer()
	{
		// Advertise my apples
		CallEventDelayed(60.0f, "DeraliaGrocer_Timer");

		SayText("An [apple] a day, keep the man eating giant insects away!");
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

		SetHealth(1);
		SetGold(30);
		SetName("Friendly grocer");
		// fov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetModelBody(1, 3);
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_apple", "apple");
		CatchSpeech("say_rumour", "rumours", "news", "happenings", "rumour");

		CallEventDelayed(0.0f, "10");
	}

	// idle
	// Idling
	void OnIdle()
	{
		CallEventDelayed(35.0f, "idle");
		PlayRandomSound(2, 3, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Hail traveler. Would you like an [apple]? They're quite good!");
		ASKED_APPLE = true;
	}

	// gossip_1
	void OnGossip1()
	{
		SayText("Have you heard about the girls at the house? You look the type.");
	}

	// trade_done
	// //////////// Shop //////////////////
	void OnTradeDone()
	{
		SayText("Have a nice day.");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  |Quantity| |cost%|
		AddStoreItem(STORE_NAME, "health_apple", 30, 100);
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("Rumors? Well, I have heard about a rash of thievery!");
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
		BaseCivilian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseCivilian_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_civilian
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
		Precache("npc/human1.mdl");
		CallEventDelayed(60.0f, "DeraliaGrocer_Timer");
		CallEventDelayed(35.0f, "idle");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DeraliaGrocer_FirstThink();
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
		if (name == "gossip_1") { OnGossip1(); return true; }
		if (name == "idle") { OnIdle(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "DeraliaGrocer_Timer") { DeraliaGrocer_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseCivilian_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
