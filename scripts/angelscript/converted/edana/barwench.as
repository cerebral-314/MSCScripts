#pragma context server

// Converted from edana/barwench.script by msc_transpiler.
// Bar Wench - sells...erm....'beer'

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "edana/barwench"]
class Barwench : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Constants
	float VENDOR_DELAY = 0.5f;
	bool NO_HAIL = true;
	bool VEND_INDIVIDUAL = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "edana_barwench";
	string STORE_SOUND = "voices/female_vendor2";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	string GAVE_SOUP_LIST = "GAVE_SOUP_LIST";
	string GAVE_SOUP_LIST2 = "GAVE_SOUP_LIST2";
	bool VENDOR_NOT_ON_USE = false;
	string ATTACK1_DAMAGE = "5";
	string ATTACK_PERCENTAGE = "60%";
	int cider_1 = 0;
	int cider_2 = 0;
	bool cider_3 = false;
	float NEXT_HELLO = 0.0f;
	int CANCHAT = 0;
	bool CIDER_DONE = false;
	bool CIDER_FINISHED = false;
	float NEXT_THANK_YOU = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Barwench()
	{
		ATTACK_RANGE = 90.0f;
	}

	// unnamed block (first think)
	void Barwench_FirstThink()
	{
		GAVE_SOUP_LIST = "";
		GAVE_SOUP_LIST2 = "";

		// base_vendor
		STORE_NAME = "edana_barwench";
		STORE_SOUND = "voices/female_vendor2";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		VENDOR_NOT_ON_USE = true;
	}

	// unnamed block (timer)
	// Greet player and other NPCs
	void Barwench_Timer()
	{
		CallEventDelayed(Random(30, 45), "Barwench_Timer");

		if (!(GameTime() > NEXT_HELLO))
			return;
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;

		SayText("Hello there.");
		Say("[.2]", "[.2]", "[.1]");
		SetMoveDest(ENT_LASTSEEN, 9999);
		OnConvoAnim();
	}

	// say_job
	void Barwench_OnSayJob(CBasePlayer@ player = null)
	{
		if (cider_1 != 0)
			return;
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;

		SetMoveDest(ENT_LASTSEEN, 9999);
		SayText("I have a task for you, now that you ask. Head across the way to Bryan and check on my cider shipment.");
		PlayAnim("once", "pondering3");
		CallExternal(FindByName("bryan"), "cider");
		OnStoproam();
		CallEventDelayed(0.0f, "4");
	}

	// say_job
	void Barwench_OnSayJob_2(CBasePlayer@ player = null)
	{
		if (cider_1 != 1)
			return;
		SayText("Didn't I ask you to check with Bryan on that cider shipment? Get on with it then!");
		SetMoveDest(ENT_LASTSPOKE, 9999);
		PlayAnim("once", "converse1");
		OnStoproam();
		CallEventDelayed(0.0f, "2");
	}

	// say_cider
	void Barwench_OnSayCider()
	{
		if (cider_1 != 1)
			return;
		SayText("Didn't I ask you to check with Bryan on that cider shipment? Get on with it then!");
		SetMoveDest(ENT_LASTSPOKE, 9999);
		PlayAnim("once", "converse1");
		OnStoproam();
		CallEventDelayed(2.0f, "stop_converse_anim");
	}

	// say_cider
	void Barwench_OnSayCider_2()
	{
		if (cider_1 != 3)
			return;
		SetMoveDest(ENT_LASTSPOKE, 9999);
		PlayAnim("once", "converse1");
		SayText("Look, I still haven't gotten that cider shipment, maybe you should check with Bryan again.");
		cider_1 = 1;
		CallExternal(FindByName("bryan"), "cider3");
		OnStoproam();
	}

	// say_cider
	void Barwench_OnSayCider_3()
	{
		// Called after player talks to Bryan the 2nd time
		OnSayReward();
	}

	// say_reward
	void Barwench_OnSayReward(CBasePlayer@ player = null)
	{
		if (cider_2 != 1)
			return;
		SayText("Thanks for the help.");
		SetRoam(false);
		SetMoveDest(ENT_LASTSPOKE, 9999);
		PlayAnim("once", "converse1");
		CallEventDelayed(0.0f, "2");
		OnStoproam();
	}

	// say_reward
	void Barwench_OnSayReward_2(CBasePlayer@ player = null)
	{
		if (cider_2 != 3)
			return;
		if ((cider_3 ? 1 : 0) != 0)
			return;
		cider_3 = true;
		SayText("Well, you've done more than your share. Seeing as how I don't have any cider to give you...");
		SetRoam(false);
		SetMoveDest(ENT_LASTSPOKE, 9999);
		PlayAnim("once", "converse1");
		OnStoproam();
		CallEventDelayed(3.0f, "say_reward2_1");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;

		menuItem.title = "Order Soup";
		menuItem.type = "payment";
		menuItem.data = "health_spotion;drink_mead;mana_mpotion;health_apple:3;gold:200";
		menuItem.callback = "give_soup";
		menuItem.cb_failed = "soup_price";
		RegisterMenuItem(menuItem);
	}

	// say_rumor
	// Rumours
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		bool exitSub = false;

		// try to avoid the whole bar responding to the same statement
		if (talkingPlayer is null && RangeTo(ENT_LASTSPOKE) > 128.0f)
			exitSub = true;
		if (exitSub)
			return;

		PlayAnim("once", "pondering");
		SayText("I've heard from travelers coming to this tavern, telling about places outside of this village.");
		CallEventDelayed(3.0f, "say_rumour2");
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetUniqueName("wench");
		SetHealth(25);
		SetGold(25);
		SetName("Sylphiel, the waitress");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human2.mdl");
		SetInvincible(true);
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "60%";
		cider_1 = 0;
		cider_2 = 0;
		cider_3 = false;

		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_wench", "wench", "beer", "ale", "wine", "mead", "woman", "drink");
		CatchSpeech("say_cider", "cider", "shipment");
		CatchSpeech("say_reward", "cider", "reward", "money", "pay", "done");
		CatchSpeech("say_rumor", "rumours", "news", "happenings", "rumor");
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		Say("goods[.34]", "[.24]", "[.35]", "[.40]");
		CANCHAT = 0;
		CallEventDelayed(10.0f, "resetchat");
	}

	// vendor_used
	// {  say_store
	// if $cansee(player,90)
	// saytext I'm no vendor, fool!
	// }
	// yes you are, bitch
	void OnVendorUsed(string player = "")
	{
		bool exitSub = false;

		PlaySound(0, 10, "voices/human/female_vendor2.wav");
		SayText("What brings you here today? Business or pleasure?");
		Say("[.3]", "[.3]", "[.3]", "[.2]", "[.1]", "[.3]", "[.1]");
		OnConvoAnim();
		SetMoveDest(player, 9999);
		NEXT_HELLO = GameTime() + 60.0f;

		int gotSoup = Int(GetQuestData(VENDOR_TARGET, "sy"));
		if (!(gotSoup > 0))
			return;
		if (FindToken(GAVE_SOUP_LIST, "L_PLR_STEAMID") > -1) // just so we don't spam it
			exitSub = true;
		if (exitSub)
			return;
		GAVE_SOUP_LIST = TokenAdd(GAVE_SOUP_LIST, "L_PLR_STEAMID");
		OnBchatMouthMove();
		SayText("Oh hi there. I remember you. Come for some of Sylphee's soup? It's not cheap - no more free samples!");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  	|Quantity| |cost%|   |Sell ratio|
		AddStoreItem(STORE_NAME, "drink_mead", 20, 100);
		AddStoreItem(STORE_NAME, "drink_ale", 20, 100);
		AddStoreItem(STORE_NAME, "drink_wine", 20, 100);

		string plrSteamid = SteamIdOf(VENDOR_TARGET);

		// if ( $get_find_token(GAVE_SOUP_LIST2,L_PLR_STEAMID) > -1 ) exitevent
		string gotSoupText = GetQuestData(VENDOR_TARGET, "sy");
		int gotSoup = Int(gotSoupText);
		if (!(gotSoup > 0))
			return;
		if (gotSoup > 5)
		{
			gotSoup = 5;
			gotSoupText = Text(gotSoup);
		}
		AddStoreItem(STORE_NAME, "mana_soup", gotSoupText, 100);
	}

	// give_soup
	void OnGiveSoup(CBasePlayer@ player = null)
	{
		Offer(player, "mana_soup");
		HelpTip(player, "generic", "Sylphiel's Soup", "Provides full health and three minutes of rapid mana regeneration");
		SetMoveDest(@player, 9999);
		PlayAnim("once", "push_button");
		SayText("One bowl of Sylphee's soup, fresh off the fire. Enjoy!");
		OnConvoAnim();
	}

	// soup_price
	void OnSoupPrice(CBasePlayer@ destination = null)
	{
		SetMoveDest(@destination, 9999);
		SayText("Soup's not free, love. Bring me a strong health potion, a mead, a mana potion, three apples and 200 gold.");
		OnConvoAnim();
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		Barwench_OnSayJob(player);
		Barwench_OnSayJob_2(player);
	}

	// reset
	void OnReset()
	{
		cider_1 = 1;
	}

	// say_cider
	void OnSayCider()
	{
		Barwench_OnSayCider();
		Barwench_OnSayCider_2();
		Barwench_OnSayCider_3();
	}

	// stop_converse_anim
	void OnStopConverseAnim()
	{
		PlayAnim("critical", "idle1");
	}

	// cider2
	void OnCider2()
	{
		cider_1 = 2;
		cider_2 = 1;
	}

	// cider3
	void OnCider3()
	{
		cider_1 = 3;
	}

	// ciderreward
	void OnCiderreward()
	{
		// Called after player talks to Krythos
		cider_2 = 3;
		cider_1 = 4;
	}

	// say_reward
	void OnSayReward(CBasePlayer@ player = null)
	{
		Barwench_OnSayReward(player);
		Barwench_OnSayReward_2(player);
	}

	// say_reward2
	void OnSayReward2()
	{
		SayText("Come back in a bit and I'll have some cider for ya. Just ask when you come in next.");
		CallEventDelayed(3.0f, "say_reward3");
	}

	// say_reward3
	void OnSayReward3()
	{
		if (CIDER_DONE)
			return;
		CIDER_DONE = true;

		SayText("Here's something for helpin' out.");
		CallEventDelayed(2.0f, "cider3");
		Offer(ENT_LASTSPOKE, "gold", 5);
		cider_1 = 99;
		cider_2 = 2;
		PlayAnim("critical", "pull_needle");
	}

	// say_reward2_1
	void OnSayReward21()
	{
		SayText("...this'll have to do. Take this with my thanks.");
		PlayAnim("critical", "pull_needle");
		CallEventDelayed(2.0f, "say_reward2_2");
	}

	// say_reward2_2
	void OnSayReward22()
	{
		if (CIDER_FINISHED)
			return;
		CIDER_FINISHED = true;
		cider_1 = 99;
		cider_2 = 99;
		Offer(ENT_LASTSPOKE, "gold", 7);
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("This knight came here the other day, and he spoke of the path to Gatecity being cut off.");
		CallEventDelayed(3.0f, "say_rumour3");
	}

	// say_rumour3
	void OnSayRumour3()
	{
		SayText("If that's true, we can't go and see the dwarves or elves anymore.");
	}

	// game_gave_player
	// <player> <item>
	void OnGameGavePlayer(CBasePlayer@ player = null, CBaseEntity@ item = null)
	{
		if (!Contains(ItemNameOf(item), "soup"))
			return;
		if (!(Float(GetQuestData(player, "sy")) > 0.0f))
			return;
		if (!(GameTime() > NEXT_THANK_YOU))
			return;
		NEXT_THANK_YOU = GameTime() + 60.0f;
		SayText("Thanks again for helping out with those goblins at gran's old place. Come by again sometime!");
		Say("[.3]", "[.3]", "[.3]", "[.2]", "[.1]", "[.3]", "[.1]");
		OnConvoAnim();
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

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	void OnStoproam() {} // stoproam

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human2.mdl");
		Precache("npc/goods.wav");
		CallEventDelayed(Float(Eval("$randf(30,45)")), "Barwench_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Barwench_FirstThink();
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
		if (name == "cider2") { OnCider2(); return true; }
		if (name == "cider3") { OnCider3(); return true; }
		if (name == "ciderreward") { OnCiderreward(); return true; }
		if (name == "game_gave_player") { OnGameGavePlayer(PlayerParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_soup") { OnGiveSoup(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "reset") { OnReset(); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_cider") { OnSayCider(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_reward") { OnSayReward(PlayerParam(params, 0)); return true; }
		if (name == "say_reward2") { OnSayReward2(); return true; }
		if (name == "say_reward2_1") { OnSayReward21(); return true; }
		if (name == "say_reward2_2") { OnSayReward22(); return true; }
		if (name == "say_reward3") { OnSayReward3(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "say_rumour3") { OnSayRumour3(); return true; }
		if (name == "soup_price") { OnSoupPrice(PlayerParam(params, 0)); return true; }
		if (name == "stop_converse_anim") { OnStopConverseAnim(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_used") { OnVendorUsed(Param(params, 0)); return true; }
		if (name == "Barwench_Timer") { Barwench_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
