#pragma context server

// Converted from edana/armourer.script by msc_transpiler.
// Armourer

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/helena/helena_npc.as"

[script "edana/armourer"]
class Armourer : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, HelenaNpc
{
	// Constants
	string STORE_NAME = "edana_armory";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool STORE_SELLMENU = true;
	float SELL_RATIO = 0.75f;
	bool NO_RUMOR = true;
	bool VEND_ARMORER = true;
	bool NPC_REACTS = true;

	// Variables (an unset .script variable reads as its own name)
	int STORE_CLOSED = 0;
	bool VENDOR_NOT_ON_USE = false;
	int JOB = 0;
	int CANCHAT = 0;
	bool NO_JOB = false;
	bool HAS_KEYPARTS = false;
	float KEY_STEP = 0.0f;
	float FORGE_KEY_STEP = 0.0f;
	bool KEY_INTRO_DELAY = false;
	string QUEST_WINNER = "QUEST_WINNER";
	bool GOT_KEYPART_1 = false;
	bool GOT_KEYPART_2 = false;
	bool GOT_KEYPART_3 = false;

	// unnamed block (first think)
	void Armourer_FirstThink()
	{
		// base_vendor
		STORE_CLOSED = 0;
		VENDOR_NOT_ON_USE = true;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;

		if (ToLowerCase(MapName()) == "helena")
			return;

		if (JOB == 1)
		{
			menuItem.title = "Accept Job";
			menuItem.type = "say";

			int say = RandomInt(1, 6);
			if (say == 1)
				menuItem.data = "Yes";
			else if (say == 2)
				menuItem.data = "Sure";
			else if (say == 3)
				menuItem.data = "Why not";
			else if (say == 4)
				menuItem.data = "Ok";
			else if (say == 5)
				menuItem.data = "Of course";
			else if (say == 6)
				menuItem.data = "Tell me more";

			RegisterMenuItem(menuItem);
		}
		else if (JOB == 2)
		{
			if (Truthy(ItemExists(player, "item_ledger")))
			{
				menuItem.title = "Give Ledger";
				menuItem.type = "payment";
				menuItem.data = "item_ledger";
				menuItem.callback = "quest_ledger_done";
				RegisterMenuItem(menuItem);
			}
			else
			{
				OnMenuitemWhere();
			}
		}

		if (Truthy(ItemExists(player, "skin_boar_heavy")))
		{
			menuItem.title = "Give Pelt";
			menuItem.type = "payment";
			menuItem.data = "skin_boar_heavy";
			menuItem.callback = "quest_boar_done";
			RegisterMenuItem(menuItem);
		}

		// ============ OUTPOST KEY
		HAS_KEYPARTS = false;
		if (Truthy(ItemExists(player, "brokenkey_1")))
		{
			menuItem.id = "payment";
			menuItem.title = "Give Key Hilt";
			menuItem.type = "payment";
			menuItem.data = "brokenkey_1";
			menuItem.callback = "got_part_1";
			RegisterMenuItem(menuItem);
			HAS_KEYPARTS = true;
		}

		if (Truthy(ItemExists(player, "brokenkey_2")))
		{
			menuItem.id = "payment";
			menuItem.title = "Give Key Middle";
			menuItem.type = "payment";
			menuItem.data = "brokenkey_2";
			menuItem.callback = "got_part_2";
			RegisterMenuItem(menuItem);
			HAS_KEYPARTS = true;
		}

		if (Truthy(ItemExists(player, "brokenkey_3")))
		{
			menuItem.id = "payment";
			menuItem.title = "Give Key End";
			menuItem.type = "payment";
			menuItem.data = "brokenkey_3";
			menuItem.callback = "got_part_3";
			RegisterMenuItem(menuItem);
			HAS_KEYPARTS = true;
		}

		if (HAS_KEYPARTS)
		{
			KEY_STEP = 0.0f;
			OnKeyIntro();
		}

		if (GOT_KEYPART_1 && GOT_KEYPART_2 && GOT_KEYPART_3)
		{
			FORGE_KEY_STEP = 0.0f;
			menuItem.id = "payment";
			menuItem.title = "Pay 10,000 to reforge key";
			menuItem.type = "payment";
			menuItem.data = "gold:10000";
			menuItem.callback = "start_forge_key";
			menuItem.cb_failed = "not_enough_forge_key";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	// Spawn properties
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(25);
		SetGold(25);
		SetName("Iron Fist Ike, the Armourer");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/blacksmith.mdl");
		SetInvincible(true);

		JOB = 0;
		CANCHAT = 1;
		STORE_CLOSED = 0;

		OnCreatemystore();
		if (ToLowerCase(MapName()) == "helena")
		{
			SetName("Galhad, Dorfgan's Sales Rep");
			NO_JOB = true;
		}

		if (ToLowerCase(MapName()) == "helena")
			return;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_yes", "yes", "sure", "why not", "ok", "sho", "whatever", "of course", "tell me more");
		CatchSpeech("say_where", "abulurd", "where");
		CatchSpeech("say_key", "key", "broken", "piece");
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
		if (STORE_CLOSED != 0)
			return;
		if (!(DistanceTo(player) <= 90.0f))
			return;
		if ("JOB.TARGET" == EntityId(player))
			return;

		if ("JOB.WINNER" != EntityId(player))
			SayText("Howdy! How about a trade?");
		else
			SayText("Howdy " + NameOf("JOB.WINNER") + "!" + " What can I do for you?");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!(DistanceTo(ENT_LASTSPOKE) <= 90.0f))
			return;
		if (STORE_CLOSED != 0)
			return;

		SayText("'Ello there.  Would you like to [buy] some fine armor, traveler?");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "armor_leather_torn", RandomInt(1, 2), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather", RandomInt(1, 2), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather_studded", RandomInt(0, 1), 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_plate", RandomInt(0, 2), 125, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_plate", RandomInt(0, 2), 125, SELL_RATIO);

		AddStoreItem(STORE_NAME, "skin_boar", 0, 150, 0.75f);
		AddStoreItem(STORE_NAME, "skin_ratpelt", 0, 250, 0.75f);
		AddStoreItem(STORE_NAME, "skin_bear", 0, 150, 1);
		AddStoreItem(STORE_NAME, "skin_boar_heavy", 0, 150, 1);

		AddStoreItem(STORE_NAME, "shields_ironshield", RandomInt(0, 3), 100, 0.25f);
		AddStoreItem(STORE_NAME, "shields_buckler", RandomInt(0, 3), 100, SELL_RATIO);

		AddStoreItem(STORE_NAME, "gown_edana", 10, 100, SELL_RATIO);
	}

	// resetchat
	void OnResetchat()
	{
		CANCHAT = 1;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (JOB == 0)
		{
			JOB = 1;
			SayText("Well you do look strong enough, I could always use a short-term errand-runner. Are ye interested?");
			OpenMenu(ENT_LASTSPOKE);
			CallEventDelayed(300.0f, "reset_job");
		}
		else if ("JOB.TARGET" != EntityId(EntityOf(ENT_LASTSPOKE)) && EntityOf("JOB.TARGET") !is player)
		{
			PlayAnim("once", "no");
			SayText("Sorry, Ive already got me an errand boy. If you see " + NameOf("JOB.TARGET") + " tell him to hurry it up!");
		}

		if (JOB >= 3)
			SayText("Sorry, think I've got all the help I need for today.");
	}

	// reset_job
	void OnResetJob()
	{
		JOB = 0;
	}

	// say_yes
	void OnSayYes(CBasePlayer@ player = null)
	{
		if (JOB != 1)
			return;

		SetVar("JOB.SPEECH1", 1);
		SetVar("JOB.TARGET", @EntityOf(ENT_LASTSPOKE));
		SayText("Excellent! I need you to go to Abulurd, give him this letter.");
		Offer(ENT_LASTSPOKE, "item_ikeletter");
		CallExternal(FindByName("abulurd"), "global_quest_letter");
	}

	// say_where
	void OnSayWhere()
	{
		// (never true here, the rest is skipped) if JOB.SPEECH1 equals 1
	}

	// quest_log_done
	void OnQuestLogDone(CBasePlayer@ target = null)
	{
		SayText("Hmmm... this does look like a good set. I'll have him send over the rest.");
		SetVar("script.questlog.target", @target);
		CallEventDelayed(4.0f, "quest_log_done_2");
	}

	// quest_log_done_2
	void OnQuestLogDone2()
	{
		SayText("Well here's something for your trouble.");
		Offer("script.questlog.target", "gold", 6);
		CallEventDelayed(4.0f, "quest_ledger_start");
	}

	// quest_ledger_start
	void OnQuestLedgerStart()
	{
		SayText("Head back over to Abulurd and ask if he has the ledger I asked him about yesterday.");
		JOB = 2;
		CallExternal(FindByName("abulurd"), "global_quest_ledger");
	}

	// quest_ledger_done
	void OnQuestLedgerDone(CBasePlayer@ winner = null)
	{
		SayText("Yep, this is it. Thanks for your help " + NameOf(winner));
		Offer(winner, "gold", 6);
		JOB = 3;
		SetVar("JOB.TARGET", "");
		SetVar("JOB.WINNER", @winner);
	}

	// quest_boar_done
	void OnQuestBoarDone(CBasePlayer@ target = null)
	{
		// Continuing the Boar quest from Abulurd, the old man
		SayText("Aah! What's this?");
		SetVar("questboar.target", @target);
		PlayAnim("critical", "studycart");
		CallEventDelayed(1.0f, "quest_boar_done_2");
		CallExternal(FindByName("abulurd"), "global_quest_boars_done");
	}

	// quest_boar_done_2
	void OnQuestBoarDone2()
	{
		SayText("This pelt is of excellent quality, my friend!");
		CallEventDelayed(2.3f, "quest_boar_done_3");
	}

	// quest_boar_done_3
	void OnQuestBoarDone3()
	{
		SayText("Stay here for a second and I'll make something out of it.");
		SetVar("questboar.angle", Eval("game.monster.angles.yaw"));
		CallEventDelayed(1.0f, "quest_boar_done_4");
	}

	// quest_boar_done_4
	void OnQuestBoarDone4()
	{
		float newang = 180.0f;
		string newangText = Text(newang);
		SetAngle("face.yaw", newangText);
		CallEventDelayed(5.0f, "quest_boar_done_5");
	}

	// quest_boar_done_5
	void OnQuestBoarDone5()
	{
		SayText("Here you go! Hope you will enjoy it.");
		SetAngle("face.yaw", "questboar.angle");
		Offer("questboar.target", "armor_leather_torn");
	}

	// say_closed
	void OnSayClosed()
	{
		SayText("Sorry, I'm closed. I will reopen at seven in the morning");
	}

	// vendor_offerstore
	// 1: Offer Target
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		if (!(DistanceTo(player) <= 90.0f))
			return;

		if (STORE_CLOSED != 0)
			SayText("Sorry, I'm closed. I will reopen at seven in the morning");
		else
			OnBasevendorOfferstore(EntityId(player));
	}

	// menuitem_where
	void OnMenuitemWhere()
	{
		MenuItem menuItem;

		menuItem.title = "I can't find Abulurd";
		menuItem.type = "say";

		int say = RandomInt(1, 2);
		if (say == 1)
			menuItem.data = "Where is abulurd?";
		else if (say == 2)
			menuItem.data = "I can't find abulurd";

		RegisterMenuItem(menuItem);
	}

	// key_intro
	void OnKeyIntro()
	{
		if (KEY_INTRO_DELAY) // stops him from spamming key intro with each part
			return;

		KEY_STEP += 1.0f;

		if (KEY_STEP == 1.0f)
		{
			PlayAnim("once", "converse1");
			SayText("Thats a mighty interestin lookin piece of a key you have there...");
		}

		if (KEY_STEP == 2.0f)
			SayText("If ya find all the parts, I maybe able to put it back together for ya.");

		if (KEY_STEP == 3.0f)
			SayText("Best not give me any parts lest ya have them all, as youll not be gettin any back.");

		if (KEY_STEP == 4.0f)
		{
			KEY_INTRO_DELAY = true;
			CallEventDelayed(60.0f, "reset_keyintro");
			SayText("Oh... And 10,000 gold for the labor. Delicate work, key forging is.");
		}

		if (!(KEY_STEP < 4.0f))
			return;

		CallEventDelayed(2.0f, "key_intro");
	}

	// start_forge_key
	void OnStartForgeKey(CBasePlayer@ player = null)
	{
		ReceiveOffer("accept");
		QUEST_WINNER = EntityId(player);

		GOT_KEYPART_1 = false;
		GOT_KEYPART_2 = false;
		GOT_KEYPART_3 = false;

		CallEventDelayed(0.1f, "forge_key");
	}

	// forge_key
	void OnForgeKey()
	{
		FORGE_KEY_STEP += 1.0f;

		if (FORGE_KEY_STEP == 1.0f)
		{
			PlayAnim("once", "portal");
			SayText("Yup, just as I thought, gonna be a tricky little thing...");
		}
		if (FORGE_KEY_STEP == 2.0f)
		{
			// playanim once portal
			SayText("But dont ya worry, Ill get her done alright...");
		}
		if (FORGE_KEY_STEP == 3.0f)
			SayText("...almost got it....");

		if (FORGE_KEY_STEP == 4.0f)
		{
			PlayAnim("once", "push_button2");
			Look(1024);
			Offer(QUEST_WINNER, "key_forged");
			SayText("See, there ya go, one re-forged key.");
		}

		if (!(FORGE_KEY_STEP < 4.0f))
			return;
		CallEventDelayed(2.0f, "forge_key");
	}

	// not_enough_forge_key
	void OnNotEnoughForgeKey()
	{
		PlayAnim("once", "checktie");
		SayText("Reforging an ornate key like this is very delicate work! I will need more gold.");
	}

	// got_part_1
	void OnGotPart1()
	{
		PlayAnim("once", "push_button");
		GOT_KEYPART_1 = true;
		SayText("Mmm hmm... Fancy lookin key this hilt belongs to, no doubt.");
		if (GOT_KEYPART_2 && GOT_KEYPART_3)
			SayText("Alright, got all the pieces, now I just need that labor charge...");
	}

	// got_part_2
	void OnGotPart2()
	{
		PlayAnim("once", "push_button");
		GOT_KEYPART_2 = true;
		SayText("Yeah, I bet this key is supposed to open somethin really valuable...");
		if (GOT_KEYPART_1 && GOT_KEYPART_3)
			SayText("Alright, got all the pieces, now I just need that labor charge...");
	}

	// got_part_3
	void OnGotPart3()
	{
		PlayAnim("once", "push_button");
		GOT_KEYPART_3 = true;
		SayText("These are about the fanciest lookin key bits Ive ever seen...");
		if (GOT_KEYPART_1 && GOT_KEYPART_2)
			SayText("Alright, got all the pieces, now I just need that labor charge...");
	}

	// say_key
	void OnSayKey()
	{
		KEY_STEP = 0.0f;
		OnKeyIntro();
	}

	// reset_key_intro
	void OnResetKeyIntro()
	{
		KEY_INTRO_DELAY = false;
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
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor
		HelenaNpc_OnBasevendorOfferstore(target); // helena/helena_npc
	}

	void OnCreatemystore() {} // createmystore

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/blacksmith.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Armourer_FirstThink();
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
		if (name == "forge_key") { OnForgeKey(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "got_part_1") { OnGotPart1(); return true; }
		if (name == "got_part_2") { OnGotPart2(); return true; }
		if (name == "got_part_3") { OnGotPart3(); return true; }
		if (name == "key_intro") { OnKeyIntro(); return true; }
		if (name == "menuitem_where") { OnMenuitemWhere(); return true; }
		if (name == "not_enough_forge_key") { OnNotEnoughForgeKey(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcreact_targetsighted") { OnNpcreactTargetsighted(EntityParam(params, 0)); return true; }
		if (name == "quest_boar_done") { OnQuestBoarDone(PlayerParam(params, 0)); return true; }
		if (name == "quest_boar_done_2") { OnQuestBoarDone2(); return true; }
		if (name == "quest_boar_done_3") { OnQuestBoarDone3(); return true; }
		if (name == "quest_boar_done_4") { OnQuestBoarDone4(); return true; }
		if (name == "quest_boar_done_5") { OnQuestBoarDone5(); return true; }
		if (name == "quest_ledger_done") { OnQuestLedgerDone(PlayerParam(params, 0)); return true; }
		if (name == "quest_ledger_start") { OnQuestLedgerStart(); return true; }
		if (name == "quest_log_done") { OnQuestLogDone(PlayerParam(params, 0)); return true; }
		if (name == "quest_log_done_2") { OnQuestLogDone2(); return true; }
		if (name == "reset_job") { OnResetJob(); return true; }
		if (name == "reset_key_intro") { OnResetKeyIntro(); return true; }
		if (name == "resetchat") { OnResetchat(); return true; }
		if (name == "say_closed") { OnSayClosed(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_key") { OnSayKey(); return true; }
		if (name == "say_where") { OnSayWhere(); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "start_forge_key") { OnStartForgeKey(PlayerParam(params, 0)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_offerstore") { OnVendorOfferstore(PlayerParam(params, 0)); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| HelenaNpc_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
