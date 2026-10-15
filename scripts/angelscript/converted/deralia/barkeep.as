#pragma context server

// Converted from deralia/barkeep.script by msc_transpiler.
// Bar Keep

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "deralia/barkeep"]
class Barkeep : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "deralia_bar";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	int CANCHAT = 0;
	string TALK_TARGET = "TALK_TARGET";

	// unnamed block (first think)
	void Barkeep_FirstThink()
	{
		// base_vendor
		STORE_NAME = "deralia_bar";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offerbeeralewinemeaddrink";
	}

	// unnamed block (timer)
	// Greet player and other NPCs
	void Barkeep_Timer()
	{
		CallEventDelayed(30.0f, "Barkeep_Timer");

		SayText("Hello there.");
		Say("*[20]", "*[20]");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour(); // spellinks
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(1);
		SetName("Holten, the Bar Keep");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);

		CatchSpeech("say_hi", "hi", "hail", "j0", "waddaup", "wazzup", "gweets", "gweetings", "greetings", "hello");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumour", "rumours", "news", "happenings", "rumor");
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		Say("goods[34]", "*[24]", "*[35]", "*[40]");
		CANCHAT = 0;
		CallEventDelayed(10.0f, "resetchat");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OnVendorUsed();
	}

	// vendor_used
	void OnVendorUsed(string player = "")
	{
		SayText("What brings you here today? Business or pleasure?");
		PlaySound(2, 10, "SOUND_HELLO");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  	|Quantity| |cost%|   |Sell ratio|
		AddStoreItem(STORE_NAME, "drink_mead", 20, 100);
		AddStoreItem(STORE_NAME, "drink_ale", 20, 100);
		AddStoreItem(STORE_NAME, "drink_wine", 20, 100);
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Eh, all staffed here, at the moment... But...");
		CallEventDelayed(3.0f, "say_job2");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		if (IsAlive(target))
			TALK_TARGET = target;
		else
			TALK_TARGET = EntityId(EntityOf(ENT_LASTSPOKE));
		OnConvoAnim();
		SayText("I heard Cathain, the quartermaster, lost a sewer crew a little while ago.");
		CallEventDelayed(5.0f, "say_job3");
	}

	// say_job3
	void OnSayJob3()
	{
		OnConvoAnim();
		SayText("Usually when that happens, they send down a crew to find them, or at least clean up the mess.");
		CallEventDelayed(5.0f, "say_job4");
	}

	// say_job4
	void OnSayJob4()
	{
		OnConvoAnim();
		if (GenderOf(TALK_TARGET) == "male")
			SayText("A big strapping lad like you might fit the bill.");
		else
			SayText("A brave heroine like you might just fit the bill.");
		CallEventDelayed(5.0f, "say_job5");
	}

	// say_job5
	void OnSayJob5()
	{
		PlayAnim("critical", "give_shot");
		SayText("You can find Cathain inside the barracks - just left of the castle. Usually pacing a wear in the floor.");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("I've heard from travelers coming to this tavern, telling about places outside of this village.");
		CallEventDelayed(0.0f, "3");
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("This knight came here the other day, and he spoke of the path to Gatecity being cut off. If that's true, we can't visit the dwarves and elves anymore.");
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
		Precache("npc/human1.mdl");
		Precache("npc/goods.wav");
		CallEventDelayed(30.0f, "Barkeep_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Barkeep_FirstThink();
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
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_job3") { OnSayJob3(); return true; }
		if (name == "say_job4") { OnSayJob4(); return true; }
		if (name == "say_job5") { OnSayJob5(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_used") { OnVendorUsed(Param(params, 0)); return true; }
		if (name == "Barkeep_Timer") { Barkeep_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
