#pragma context server

// Converted from dridmars_scripts_WIP/deralia/innkeeper.script by msc_transpiler.
// Thothie - added bar (barkeep script unused in map)
// - Removing asking for innkeeper cash, since it doesn't work
// - Different greet sound
// Innkeeper

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "dridmars_scripts_WIP/deralia/innkeeper"]
class DridmarsScriptsWipDeraliaInnkeeper : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	string SOUND_HELLO = "npc/hello1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ATTACK1_DAMAGE = "5";
	string ATTACK_PERCENTAGE = "60%";
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	bool BUSY_CHATTING = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	int CANCHAT = 1;
	bool SAID_WELCOME = false;
	string STORE_NAME = "deralia_bar";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string TALK_TARGET = "TALK_TARGET";

	// Variables declared by included files, with the value they start with in this script
	DridmarsScriptsWipDeraliaInnkeeper()
	{
		ATTACK_RANGE = 90.0f;
	}

	// unnamed block (timer)
	void DridmarsScriptsWipDeraliaInnkeeper_Timer()
	{
		CallEventDelayed(2.0f, "DridmarsScriptsWipDeraliaInnkeeper_Timer");
		if (CANCHAT == 0)
			return;

		OnSayHi();
		CallEventDelayed(0.0f, "20");
	}

	// say_rumour
	// Rumours
	void DridmarsScriptsWipDeraliaInnkeeper_OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("Rumour has it that this place has rooms real cheap, get my drift?");
	}

	// unnamed block (first think)
	// Thothie - Adding bar, since barkeep actually not in map, damnitall! Where's the booze!
	void DridmarsScriptsWipDeraliaInnkeeper_FirstThink()
	{
		// base_vendor
		STORE_NAME = "deralia_bar";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offerbeeralewinemeaddrink";
	}

	// say_rumour
	// Rumours
	void DridmarsScriptsWipDeraliaInnkeeper_OnSayRumour_2(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("I've heard from travelers coming to this tavern, telling about places outside of this village.");
		CallEventDelayed(0.0f, "3");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		OnSayRumour(); // spellinks
	}

	// spawn
	void OnSpawn()
	{
		// eventname MUST be the first field!
		SetHealth(25);
		SetGold(26);
		SetName("Gerald the Inn Keeper");
		// fov 60
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 1);
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "60%";

		OnResetchat();

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_job", "job", "work", "money", "gold");

		CatchSpeech("say_rumour", "news", "happenings", "rumor");

		CatchSpeech("say_sewer", "sewer");

		CatchSpeech("say_rudolf", "rudolf", "Rudolf");
	}

	// say_rudolf
	void OnSayRudolf()
	{
		CHAT_STEPS = 4;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Rudolf? What do you want with him?";
		CHAT_STEP2 = "He came in here a couple nights ago before leaving the city.";
		CHAT_STEP3 = "Said something about finding riches in an abandoned mine.";
		CHAT_STEP4 = "The fool has more rocks in his head than in that mine.";
		OnChatLoop();
		// callevent bchat_mouth_move
		SetGlobal("RudolfQuest", 1);
	}

	// chatreset
	void OnChatreset()
	{
		CANCHAT = 1;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (SAID_WELCOME)
			return;
		PlayAnim("once", "studycart");
		SayText("Welcome to Deralia Inn!");
		CallEventDelayed(0.0f, "2");
		CANCHAT = 0;
	}

	// say_hi_2
	void OnSayHi22()
	{
		SayText("Finest booze and most comfortable lodging this side of Daragoth!");
		SAID_WELCOME = true;
	}

	// game_recvoffer_gold
	// ///////////////////////////////////////////////////////////////////////////////////////////////
	void OnGameRecvofferGold()
	{
		OnRecvMoregold();
		OnRecvEnoughgold();
		OnRecvNotenoughgold();
	}

	// recv_moregold
	void OnRecvMoregold()
	{
		// (never true here, the rest is skipped) if OFFER_AMT > 5
	}

	// recv_enoughgold
	void OnRecvEnoughgold()
	{
		// (never true here, the rest is skipped) if OFFER_AMT equals 5
	}

	// recv_notenoughgold
	void OnRecvNotenoughgold()
	{
		ReceiveOffer("reject");
		SayText("This isn't charity boy, it's an Inn.");
		PlayAnim("once", "no");
	}

	// robbed
	// -- Attack thieves --
	void OnRobbed()
	{
		SayText("Bastard! Thief!");
		PlayAnim("once", "beatdoor");
	}

	// attack_1
	void OnAttack12()
	{
		// Deal damage
		DoDamage(ENT_LASTSTOLE, ATTACK_RANGE, ATTACK1_DAMAGE, ATTACK_PERCENTAGE);
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I've got Bob the door guard, but he's a little afraid of rats. And my basement is full of them.");
		SayText("If you could clear the place up, it would be greatly appreciated and you can stay the night.");
	}

	// say_rumour
	void OnSayRumour(string speaker = "")
	{
		DridmarsScriptsWipDeraliaInnkeeper_OnSayRumour(speaker);
		DridmarsScriptsWipDeraliaInnkeeper_OnSayRumour_2(speaker);
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

	// vendor_used
	void OnVendorUsed(string player = "")
	{
		SayText("Careful! This isn't that watered down stuff you boys drink in Edana!");
		PlaySound(2, 10, SOUND_HELLO);
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

	// say_sewer
	void OnSaySewer(CBasePlayer@ target = null)
	{
		if (IsAlive(target))
			TALK_TARGET = EntityId(target);
		else
			TALK_TARGET = EntityId(EntityOf(ENT_LASTSPOKE));

		OnConvoAnim();
		SayText("Well, if hunting rats is beneath you...");
		CallEventDelayed(3.0f, "say_job2");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		OnConvoAnim();
		SayText("I heard Cathain, the quartermaster, lost a sewer crew a little while ago.");
		CallEventDelayed(5.0f, "say_job3");
	}

	// say_job3
	void OnSayJob3()
	{
		OnConvoAnim();
		SayText("Usually when that happens, they send militiamen to find them, or at least clean up the mess.");
		CallEventDelayed(5.0f, "say_job4");
	}

	// say_job4
	void OnSayJob4()
	{
		OnConvoAnim();
		if (GenderOf(TALK_TARGET) == "male")
			SayText("A big strapping lad like yourself might fit the bill.");
		else
			SayText("A brave heroine like yourself might just fit the bill.");
		CallEventDelayed(5.0f, "say_job5");
	}

	// say_job5
	void OnSayJob5()
	{
		PlayAnim("critical", "give_shot");
		SayText("You can find Cathain inside the barracks - just left of the castle. Usually pacing a wear in the floor.");
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("This knight came here the other day, and he spoke of the path to Gatecity being cut off. If that's true, we can't visit the dwarves and elves anymore.");
	}

	// bchat_after_menus
	void OnBchatAfterMenus()
	{
		MenuItem menuItem;

		menuItem.title = "Sewer Job";
		menuItem.type = "callback";
		menuItem.callback = "say_sewer";
		RegisterMenuItem(menuItem);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
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
		CallEventDelayed(2.0f, "DridmarsScriptsWipDeraliaInnkeeper_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
		DridmarsScriptsWipDeraliaInnkeeper_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseNpcVendorConfirm_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "bchat_after_menus") { OnBchatAfterMenus(); return true; }
		if (name == "chatreset") { OnChatreset(); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "recv_enoughgold") { OnRecvEnoughgold(); return true; }
		if (name == "recv_moregold") { OnRecvMoregold(); return true; }
		if (name == "recv_notenoughgold") { OnRecvNotenoughgold(); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "robbed") { OnRobbed(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi_2") { OnSayHi22(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_job3") { OnSayJob3(); return true; }
		if (name == "say_job4") { OnSayJob4(); return true; }
		if (name == "say_job5") { OnSayJob5(); return true; }
		if (name == "say_rudolf") { OnSayRudolf(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "say_sewer") { OnSaySewer(PlayerParam(params, 0)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_used") { OnVendorUsed(Param(params, 0)); return true; }
		if (name == "DridmarsScriptsWipDeraliaInnkeeper_Timer") { DridmarsScriptsWipDeraliaInnkeeper_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
