#pragma context server

// Converted from m2_quest/sylphiel.script by msc_transpiler.
// possible voice sets:
// vs_fx0huskf_vict.wav - SOU
// vs_fx0slinf_enmy.wav - SOU
// vs_nx0jnahf_warn.wav - SOU - if we want to use an older female
// vs_feltoorf_hit1.wav - MAIN - better than most of the above
// vs_ffightf_move.wav - MAIN - best so far
// vs_ncomolf1_say.wav - MAIN - good if you need an old witch

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/debug.as"

[script "m2_quest/sylphiel"]
class Sylphiel : BaseChatArrayScript, Debug
{
	// Constants
	string ANIM_BLUSH = "anim_blush";
	string ANIM_RANT = "anim_rant";
	int MAX_APPLE = 5;
	bool MAX_SALT = true;
	bool MAX_PEPPER = true;
	int MAX_MEAD = 5;
	bool MAX_LADEL = true;
	string QCODE_APPLE = "ap";
	string QCODE_SALT = "bs";
	string QCODE_PEPPER = "bp";
	string QCODE_MEAD = "km";
	string QCODE_LADEL = "la";
	string ANIM_RAGE = "anim_rage";
	string ANIM_RAGE_WALK = "anim_rage_walk";
	string ANIM_VICTORY = "wave";
	string ANIM_COOK = "keypad";
	Vector3 POS_SECOND_QUEST = Vector3();

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle1";
	bool NPC_NO_PLAYER_DMG = false;
	bool QUEST_SOUP_COMPLETE = false;
	float COUNT_APPLE = 0.0f;
	float COUNT_SALT = 0.0f;
	float COUNT_PEPPER = 0.0f;
	float COUNT_MEAD = 0.0f;
	float COUNT_LADEL = 0.0f;
	string SOUP_LIST = "SOUP_LIST";
	string LOCKED_PLAYER = "LOCKED_PLAYER";
	bool CIRCLE_ACTIVE = false;
	CBaseEntity@ COOKING_POT_ID = null;
	int DID_INTRO = 0;
	bool CHAT_TEMP_NO_AUTO_FACE = false;
	bool MENU_ENABLE_HELP = false;
	float NEXT_PACE = 0.0f;
	string QUEST_PLAYER = "QUEST_PLAYER";
	bool CHECK_PACING = false;
	bool SECOND_QUEST_READY = false;
	bool SECOND_QUEST_INPROGRESS = false;
	float WASTING_MY_TIME = 0.0f;
	bool DID_FIRST_HELP = false;
	bool DID_HELP = false;
	bool QUEST_ENABLED = false;
	bool DO_THANK = false;
	CBaseEntity@ MY_ID = null;
	float THANK_INDEX = 0.0f;
	string QUEST_COMPLETE = "QUEST_COMPLETE";
	float COOK_COMPLAIN = 0.0f;
	bool SOUP_READY = false;
	CBasePlayer@ LAST_GAVE_SOUP = null;
	bool SECOND_QUEST_OFFERED = false;
	float COMPLAIN_BLOCKED = 0.0f;
	string NPCATK_TARGET = "NPCATK_TARGET";
	float NEXT_ATTACK = 0.0f;
	bool ALL_QUESTS_DONE = false;

	// unnamed block (first think)
	void Sylphiel_FirstThink()
	{
		NPC_NO_PLAYER_DMG = true;
		QUEST_SOUP_COMPLETE = false;

		COUNT_APPLE = 0.0f;
		COUNT_SALT = 0.0f;
		COUNT_PEPPER = 0.0f;
		COUNT_MEAD = 0.0f;
		COUNT_LADEL = 0.0f;

		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";

		SOUP_LIST = "";
	}

	// unnamed block (timer)
	void Sylphiel_Timer()
	{
		CallEventDelayed(5.0f, "Sylphiel_Timer");

		if (CHECK_PACING)
		{
			if (!Truthy(QUEST_COMPLETE) && !SECOND_QUEST_READY && !SECOND_QUEST_INPROGRESS && !SECOND_QUEST_OFFERED && GameTime() > NEXT_PACE)
			{
				SetVar("PLAYER_LIST", GetActivePlayers());
				string sortPlayers = SortEntities("PLAYER_LIST", "range");
				CBaseEntity@ testPlayer = FindEntity(GetToken(sortPlayers, 0));
				if (RangeTo(testPlayer) > 256.0f && !CIRCLE_ACTIVE)
				{
					SetMoveAnim(ANIM_WALK);
					SetIdleAnim(ANIM_WALK);
					CIRCLE_ACTIVE = true;
					OnCirclePot();
				}
			}
		}
		else
		{
			SetIdleAnim(ANIM_IDLE);
		}

		if (!CanSee("enemy"))
			return;
		NPCATK_TARGET = EntityId(EntityOf(ENT_LASTSEEN));
		if (!(RangeTo(NPCATK_TARGET) < 128.0f))
			return;
		OnStopCircle();
		NEXT_PACE = GameTime() + 30.0f;
		SetMoveDest(NPCATK_TARGET, 9999);
		OnDoAttack();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Sylphiel");
		SetUniqueName("sylphiel");
		SetRace("human");
		SetWidth(32);
		SetHeight(72);
		SetRoam(false);
		SetModel("npc/human2.mdl");
		SetInvincible(true);
		// setvard PLAYING_DEAD 1
		SetNoPush(true);

		LOCKED_PLAYER = "none";
		SetVar("PLAYER_LIST", GetActivePlayers());

		SetSayTextRange(1024);

		CallEventDelayed(3.0f, "scan_for_players");
		CallEventDelayed(2.0f, "get_pot_id");
		CIRCLE_ACTIVE = true;
		CallEventDelayed(3.0f, "circle_pot");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		bool exitSub = false;
		MenuItem menuItem;

		if (DID_INTRO == 0)
		{
			SetIdleAnim(ANIM_IDLE);
			// if $cansee(TEST_PLAYER,96)
			DID_INTRO = 1;
			CHAT_CURRENT_SPEAKER = EntityId(player);
			LOCKED_PLAYER = EntityId(player);
			OnDoIntro();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (DID_INTRO == 0)
			return;

		CHAT_CURRENT_SPEAKER = EntityId(player);
		LOCKED_PLAYER = EntityId(player);

		if (CIRCLE_ACTIVE)
		{
			OnStopCircle();
			NEXT_PACE = GameTime() + 30.0f;
		}

		SetMoveDest(LOCKED_PLAYER, 9999);

		if (ALL_QUESTS_DONE)
			OnChatNow("Thanks for all the help! I'll see you in town in a few days.", "3.0", "none", "none", "add_to_que");

		if (SOUP_READY)
		{
			OnStopCircle();
			int plrIndex = IndexOf(player);
			DebugPrint("game_menu_getoptions " + plrIndex + " vs " + SOUP_LIST + " vs " + FindToken(SOUP_LIST, Text(plrIndex)));
			if (FindToken(SOUP_LIST, Text(plrIndex)) == -1)
			{
				menuItem.title = "(Get soup)";
				menuItem.type = "callback";
				menuItem.callback = "menu_get_soup";
				RegisterMenuItem(menuItem);
			}
		}

		if (SECOND_QUEST_READY)
		{
			OnStopCircle();
			menuItem.title = "One other thing?";
			menuItem.type = "callback";
			menuItem.callback = "menu_help";
			RegisterMenuItem(menuItem);
		}

		// some redunadncy, as I dunno how it's getting pass this
		if (Truthy(QUEST_COMPLETE))
			return;
		if (SECOND_QUEST_READY)
			return;
		if (SECOND_QUEST_INPROGRESS)
			return;
		if (SECOND_QUEST_OFFERED)
			return;

		QUEST_PLAYER = EntityId(player);

		// check and remove quest items, if found, and thank player (sylphiel_thanks1.wav/sylphiel_thanks2.wav)
		if (MENU_ENABLE_HELP)
		{
			menuItem.title = "How can I help?";
			menuItem.type = "callback";
			menuItem.callback = "menu_help";
			RegisterMenuItem(menuItem);
		}

		if (!DID_FIRST_HELP)
			return;

		OnTallyQuestItems(player);

		if (QUEST_ENABLED)
		{
			CHECK_PACING = true;

			// apple counter
			menuItem.title = "Golden Apples (";
			LegacyCommand("stradd", "reg.mitem.title", int(COUNT_APPLE));
			LegacyCommand("stradd", "reg.mitem.title", "/");
			LegacyCommand("stradd", "reg.mitem.title", MAX_APPLE);
			LegacyCommand("stradd", "reg.mitem.title", ")");
			if (COUNT_APPLE >= MAX_APPLE)
			{
				menuItem.type = "green"; // new function
			}
			else
			{
				menuItem.type = "disabled";
			}
			RegisterMenuItem(menuItem);

			// salt counter
			menuItem.title = "Bag of Salt (";
			LegacyCommand("stradd", "reg.mitem.title", int(COUNT_SALT));
			LegacyCommand("stradd", "reg.mitem.title", "/");
			LegacyCommand("stradd", "reg.mitem.title", int((MAX_SALT ? 1.0f : 0.0f)));
			LegacyCommand("stradd", "reg.mitem.title", ")");
			if (COUNT_SALT >= (MAX_SALT ? 1.0f : 0.0f))
			{
				menuItem.type = "green"; // new function
			}
			else
			{
				menuItem.type = "disabled";
			}
			RegisterMenuItem(menuItem);

			// pepper counter
			menuItem.title = "Bag of Pepper (";
			LegacyCommand("stradd", "reg.mitem.title", int(COUNT_PEPPER));
			LegacyCommand("stradd", "reg.mitem.title", "/");
			LegacyCommand("stradd", "reg.mitem.title", int((MAX_PEPPER ? 1.0f : 0.0f)));
			LegacyCommand("stradd", "reg.mitem.title", ")");
			if (COUNT_PEPPER >= (MAX_PEPPER ? 1.0f : 0.0f))
			{
				menuItem.type = "green"; // new function
			}
			else
			{
				menuItem.type = "disabled";
			}
			RegisterMenuItem(menuItem);

			// mead counter
			menuItem.title = "Barrel of Honeymead (";
			LegacyCommand("stradd", "reg.mitem.title", int(COUNT_MEAD));
			LegacyCommand("stradd", "reg.mitem.title", "/");
			LegacyCommand("stradd", "reg.mitem.title", MAX_MEAD);
			LegacyCommand("stradd", "reg.mitem.title", ")");
			if (COUNT_MEAD >= MAX_MEAD)
			{
				menuItem.type = "green"; // new function
			}
			else
			{
				menuItem.type = "disabled";
			}
			RegisterMenuItem(menuItem);

			// ladel counter
			menuItem.title = "Ladel (";
			LegacyCommand("stradd", "reg.mitem.title", int(COUNT_LADEL));
			LegacyCommand("stradd", "reg.mitem.title", "/");
			LegacyCommand("stradd", "reg.mitem.title", int((MAX_LADEL ? 1.0f : 0.0f)));
			LegacyCommand("stradd", "reg.mitem.title", ")");
			if (COUNT_LADEL >= (MAX_LADEL ? 1.0f : 0.0f))
			{
				menuItem.type = "green"; // new function
			}
			else
			{
				menuItem.type = "disabled";
			}
			RegisterMenuItem(menuItem);
		}
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("m2_quest/pot");
	}

	// get_pot_id
	void OnGetPotId()
	{
		@COOKING_POT_ID = FindByName("cooking_pot");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		CallEventDelayed(0.1f, "setup_debug_pot");
	}

	// setup_debug_pot
	void OnSetupDebugPot()
	{
		Vector3 potOrg = OriginOf(ENT_ME);
		potOrg.x += 32.0f;
		CreateNpc("m2_quest/pot", potOrg);
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		bool findNewLock = false;
		SetMoveAnim(ANIM_RAGE_WALK);
		SetIdleAnim(ANIM_RAGE_WALK);
		DebugPrint("scan_for_players");

		if (DID_INTRO != 0)
			return;
		CallEventDelayed(1.0f, "scan_for_players");
		SetVar("PLAYER_LIST", GetActivePlayers());
		if (LOCKED_PLAYER == "none")
			findNewLock = true;
		if (!Exists(LOCKED_PLAYER))
			findNewLock = true;
		if (RangeTo(LOCKED_PLAYER) > 512.0f)
			findNewLock = true;
		if (!findNewLock)
			return;
		string sortPlayers = SortEntities("PLAYER_LIST", "range");
		CBaseEntity@ testPlayer = FindEntity(GetToken(sortPlayers, 0));
		if (!(RangeTo(testPlayer) < 64.0f))
			return;
		LOCKED_PLAYER = EntityId(testPlayer);
		if (DID_INTRO != 0)
			return;
		SetIdleAnim(ANIM_IDLE);
		// if $cansee(TEST_PLAYER,96)
		DID_INTRO = 1;
		CHAT_CURRENT_SPEAKER = LOCKED_PLAYER;
		OnDoIntro();
	}

	// stop_circle
	void OnStopCircle()
	{
		if (CIRCLE_ACTIVE)
			SetIdleAnim(ANIM_IDLE);
		CIRCLE_ACTIVE = false;
	}

	// do_intro
	void OnDoIntro()
	{
		CHAT_TEMP_NO_AUTO_FACE = true;
		CIRCLE_ACTIVE = true;
		OnChatNow("By the blood of the gods! Those damn goblins!", "1.0", "none", "none", "clear_que", "add_to_que", "sound:voices/m2_quest/sylphiel_cuss.wav");
		OnChatNow("May The Lost take their filthy little souls!", "4.0", ANIM_RAGE, "do_intro2", "add_to_que", "sound:voices/m2_quest/sylphiel_rage.wav");
	}

	// do_intro2
	void OnDoIntro2()
	{
		OnStopCircle();
		PlayAnim("break");
		SetMoveDest(LOCKED_PLAYER, 32);
		OnChatNow("Oh, sorry...", "2.0", ANIM_BLUSH, "do_intro3", "add_to_que", "sound:voices/m2_quest/sylphiel_hi.wav");
		OnChatNow("Didn't mean for anyone to actually hear that.", "3.0", "lean", "none", "add_to_que");
		OnChatNow("Hey! Don't I know you from the Edana Inn?", "3.0", "pondering", "move_closer", "add_to_que");

		if (PlayerCount() > 1)
			OnChatNow("You're adventurers, aren't you? Maybe you could [help] me?", "3.0", "pondering3", "1", "add_to_que");
		else
			OnChatNow("You're an adventurer, aren't you? Maybe you could [help] me?", "3.0", "pondering3", "1", "add_to_que");
	}

	// move_closer
	void OnMoveCloser()
	{
		PlaySound(0, 10, "voices/m2_quest/sylphiel_help.wav");
		SetMoveDest(LOCKED_PLAYER, 32);
	}

	// hold_for_help
	void OnHoldForHelp()
	{
		MENU_ENABLE_HELP = true;
		SetMoveAnim("pondering3");
		SetIdleAnim("pondering3");
		CatchSpeech("menu_help", "help");
	}

	// menu_help
	void OnMenuHelp(CBasePlayer@ player = null)
	{
		if (ALL_QUESTS_DONE)
			return;

		if (IsPlayer(player))
		{
			CHAT_CURRENT_SPEAKER = EntityId(player);
			LOCKED_PLAYER = EntityId(player);
		}
		else
		{
			CHAT_CURRENT_SPEAKER = EntityId(EntityOf(ENT_LASTSPOKE));
			LOCKED_PLAYER = CHAT_CURRENT_SPEAKER;
		}

		if (SECOND_QUEST_READY)
		{
			SECOND_QUEST_READY = false;
			SECOND_QUEST_INPROGRESS = true;
			OnChatNow("My grams, as you might guess by all the weird stuff on these shelves, was a bit of an alchemist.", "4.0", "converse1", "none", "add_to_que");
			OnChatNow("She passed on, just a bit ago, and I came here to maybe, try my hand at it...", "4.0", "none", "none", "add_to_que");
			OnChatNow("But there's a lot of secrets in this old house, and I'm a little afraid of what I might find...", "4.0", "lean", "none", "add_to_que");
			OnChatNow("Over here, for instance...", "2.0", "no_convo", "second_quest_show", "add_to_que");
		}

		if (SECOND_QUEST_READY)
			return;
		if (SECOND_QUEST_INPROGRESS)
			return;

		if (!DID_FIRST_HELP)
		{
			WASTING_MY_TIME = -2.0f;
			DID_FIRST_HELP = true;
		}

		if (DID_HELP)
		{
			OnChatNow("Just bring me these items, and we'll be golden.", "4.0", "pondering3", "none", "add_to_que", "sound:voices/m2_quest/sylphiel_help.wav");
			CallEventDelayed(0.1f, "send_menu");
		}

		if (DID_HELP)
			return;
		OnEnableQuest();
		OnChatNow("I came here, to my grand's house, to put together some of her special stew, for the inn.", "4.0", "converse1", "none", "add_to_que");
		OnChatNow("But I must have left the place unlocked on my last visit, as those damned goblins have been in here.", "3.0", "none", "none", "add_to_que");
		OnChatNow("The little green thieves went and pilfered all my ingredients!", "4.0", "none", "none", "add_to_que");
		OnChatNow("If you can track them down, and get my stuff back, maybe I can give you a free sample!", "5.0", "none", "none", "add_to_que");
		OnChatNow("Plus I'll have some more, when I get back to town.", "3.0", "pondering", "none", "add_to_que");
		OnChatNow("I need five of granny's golden apples, a sack of pepper, a sack of salt, and some honeymead.", "6.0", "none", "none", "add_to_que");
		OnChatNow("Waddya say ya help ol Sylphiel out, aye? Just find the ingredients and bring them back here.", "6.0", "pondering3", "none", "add_to_que");
		DID_HELP = true;
	}

	// send_menu
	void OnSendMenu()
	{
		OpenMenu(LOCKED_PLAYER);
	}

	// enable_quest
	void OnEnableQuest()
	{
		QUEST_ENABLED = true;
	}

	// tally_quest_items
	void OnTallyQuestItems(CBaseEntity@ player = null)
	{
		// tally and remove quest items
		DO_THANK = false; // sets to 1 if one or more items found
		@MY_ID = self;

		QUEST_PLAYER = EntityId(player);

		OnCheckQuestItems(QCODE_APPLE);

		OnCheckQuestItems(QCODE_SALT);

		OnCheckQuestItems(QCODE_PEPPER);

		OnCheckQuestItems(QCODE_MEAD);

		OnCheckQuestItems(QCODE_LADEL);

		// check if quest complete
		bool questComplete = true;
		if (COUNT_APPLE < MAX_APPLE)
			questComplete = false;
		if (COUNT_SALT < (MAX_SALT ? 1.0f : 0.0f))
			questComplete = false;
		if (COUNT_PEPPER < (MAX_PEPPER ? 1.0f : 0.0f))
			questComplete = false;
		if (COUNT_MEAD < MAX_MEAD)
			questComplete = false;
		if (COUNT_LADEL < (MAX_LADEL ? 1.0f : 0.0f))
			questComplete = false;

		if (DO_THANK)
		{
			WASTING_MY_TIME = 0.0f;
			if (!questComplete)
			{
				THANK_INDEX += 1.0f;
				if (THANK_INDEX == 1.0f)
				{
					OnChatNow("Thank you for that.", "1.0", "none", "none", "add_to_que");
					PlaySound(0, 10, "voices/m2_quest/sylphiel_thanks1.wav");
				}
				if (THANK_INDEX == 2.0f)
				{
					THANK_INDEX = 0.0f;
					OnChatNow("I appreciate it.", "1.0", "none", "none", "add_to_que");
					PlaySound(0, 10, "voices/m2_quest/sylphiel_thanks2.wav");
				}
			}
		}
		else if (!questComplete)
		{
			WASTING_MY_TIME += 1.0f;
			if (WASTING_MY_TIME > 1.0f)
			{
				OnChatNow("You're wasting time... Get going!", "2.0", "pondering3", "none", "add_to_que", "sound:voices/m2_quest/sylphiel_impatient.wav");
				WASTING_MY_TIME = 0.0f;
			}
		}

		if (!questComplete)
			return;
		QUEST_COMPLETE = "1";
		CHECK_PACING = false;
		OnStopCircle();
		SetIdleAnim(ANIM_IDLE);
		CallEventDelayed(1.0f, "do_soup");
	}

	// check_quest_items
	// PARAM1 = qitem code
	void OnCheckQuestItems(string questCode = "")
	{
		CallExternal(GetVar("GAME_MASTER"), "ext_check_quest_item", questCode, @MY_ID);
	}

	// ext_receive_quest_item
	// <item_code>
	void OnExtReceiveQuestItem(string itemCode = "")
	{
		if (itemCode == QCODE_APPLE)
			COUNT_APPLE += 1.0f;
		if (itemCode == QCODE_SALT)
			COUNT_SALT += 1.0f;
		if (itemCode == QCODE_PEPPER)
			COUNT_PEPPER += 1.0f;
		if (itemCode == QCODE_MEAD)
			COUNT_MEAD += 1.0f;
		if (itemCode == QCODE_LADEL)
			COUNT_LADEL += 1.0f;
		DO_THANK = true;
	}

	// do_soup
	void OnDoSoup()
	{
		SetMoveDest(QUEST_PLAYER, 9999);
		OnChatNow("That's the way! All right!", "2.0", ANIM_VICTORY, "none", "add_to_que", "clear_que", "sound:voices/m2_quest/sylphiel_victory1.wav");
		OnChatNow("Haha! Alright, let's get cooking!", "2.0", "no_convo", "do_cook_loop", "add_to_que", "sound:voices/m2_quest/sylphiel_victory2.wav");
		COOK_COMPLAIN = GameTime() + 10.0f;
	}

	// do_cook_loop
	void OnDoCookLoop()
	{
		SetMoveAnim(ANIM_WALK);
		SetMoveDest(@COOKING_POT_ID, 4);
		Vector3 potOrg = OriginOf(COOKING_POT_ID);
		Vector3 myOrg = OriginOf(ENT_ME);
		string potDistText = LegacyFunction("dist2d", myOrg, potOrg);
		int potDist = Int(potDistText);
		DebugPrint("do_cook_loop " + potDistText);
		if (potDist > 32)
		{
			CallEventDelayed(Random(1, 2), "do_cook_loop");
			if (GameTime() > COOK_COMPLAIN)
			{
				COOK_COMPLAIN = GameTime() + 10.0f;
				SayText("Stand aside, you're between me and my pot!");
				PlaySound(0, 10, "voices/m2_quest/sylphiel_blocked.wav");
			}
		}
		else
		{
			OnDoSoup2();
		}
	}

	// do_soup2
	void OnDoSoup2()
	{
		SetMoveDest(@COOKING_POT_ID, 9999);
		PlayAnim("break");
		PlayAnim("critical", ANIM_COOK);
		CallExternal(COOKING_POT_ID, "ext_cooking");
		CallEventDelayed(6.0f, "soups_on");
	}

	// soups_on
	void OnSoupsOn()
	{
		OnChatNow("Alright, I'm done with this...", "2.0", ANIM_COOK, "none", "clear_que", "add_to_que", "sound:voices/m2_quest/sylphiel_done.wav");
		OnChatNow("Gather here, form up, and get your soup!", "3.0", "no_convo", "soups_on2", "add_to_que", "sound:voices/m2_quest/sylphiel_soupson.wav");
	}

	// soups_on2
	void OnSoupsOn2()
	{
		PlayAnim("break");
		SetMoveDest(LOCKED_PLAYER, 9999);
		SOUP_READY = true;
	}

	// circle_pot
	void OnCirclePot()
	{
		if (CIRCLE_ACTIVE)
		{
			// find nearest radial
			// dbg circle_pot
			Vector3 wanderPoint = OriginOf(COOKING_POT_ID);
			float angleToNpc = AnglesTo(wanderPoint, MyOrigin());
			Vector3 myOrg = OriginOf(ENT_ME);
			angleToNpc += 60.0f;
			if (angleToNpc > 359.99f)
				angleToNpc -= 359.99f;
			wanderPoint += RelativePosition(Vector3(0, angleToNpc, 0), Vector3(0, 32, 0));
			SetMoveDest(wanderPoint, 8);
			CallEventDelayed(1.0f, "circle_pot");
		}
	}

	// menu_get_soup
	void OnMenuGetSoup(CBasePlayer@ player = null)
	{
		SOUP_LIST = TokenAdd(SOUP_LIST, Text(IndexOf(player)));
		Offer(player, "mana_soup");
		float questCount = Float(GetQuestData(player, "sy"));
		questCount += 1.0f;
		Quest("set", player, "sy", questCount);

		HelpTip(player, "generic", "Sylphiel's Soup", "Provides full health and three minutes of rapid mana regeneration");

		PlayAnim("once", "push_button");
		OnChatNow("There ya go, one free sample of Sylphee's delicious soup!", "2.0", "none", "none", "add_to_que");
		@LAST_GAVE_SOUP = player;

		float nsoups = GetTokenCount(SOUP_LIST) + 1.0f;

		if (nsoups >= ActivePlayerCount())
			CallEventDelayed(2.0f, "second_quest_start");

		if (SECOND_QUEST_OFFERED)
			return;
		CallEventDelayed(90.0f, "second_quest_start"); // auto start after 90 seconds, even if not all players got their soup
	}

	// second_quest_start
	void OnSecondQuestStart()
	{
		if (SECOND_QUEST_OFFERED)
			return;
		SECOND_QUEST_OFFERED = true;
		// beatdoor buysoda
		SECOND_QUEST_READY = true;
		SetMoveDest(@LAST_GAVE_SOUP, 9999);
		OnChatNow("Listen... There is one other little thing you can [help] me with, if you're interested.", "4.0", "ponder", "none", "add_to_que", "sound:voices/m2_quest/sylphiel_hey_listen.wav");
	}

	// second_quest_show
	void OnSecondQuestShow()
	{
		PlayAnim("break");
		SetMoveAnim("walk");
		SetMoveDest(POS_SECOND_QUEST, 4);
		COMPLAIN_BLOCKED = GameTime() + 10.0f;
		CallEventDelayed(1.0f, "second_quest_show_loop");
	}

	// second_quest_show_loop
	void OnSecondQuestShowLoop()
	{
		Vector3 myPos = OriginOf(ENT_ME);
		if (Distance(myPos, POS_SECOND_QUEST) > 8.0f)
		{
			SetMoveDest(POS_SECOND_QUEST, 4);
			CallEventDelayed(Random(1, 2), "second_quest_show_loop");
			if (GameTime() > COMPLAIN_BLOCKED)
			{
				COMPLAIN_BLOCKED = GameTime() + 10.0f;
				OnChatNow("Stand aside, you're in my way...", "1.0", "pondering3", "none", "add_to_que", "sound:voices/m2_quest/sylphiel_blocked.wav");
			}
		}
		else
		{
			OnSecondQuestShow2();
		}
	}

	// second_quest_show2
	void OnSecondQuestShow2()
	{
		SetAngle("face", Vector3(0, -90, 0));
		UseTrigger("spawn_sylph_reward");
		OnChatNow("Have a look behind here...", "3.0", "buysoda", "second_quest_open_secret", "add_to_que", "sound:voices/m2_quest/sylphiel_lookhere.wav");
		OnChatNow("Search this carefully... I just want to be sure it's safe - but if you find anything, it's yours.", "4.0", "ponder", "none", "add_to_que", "sound:voices/m2_quest/sylphiel_secrets.wav");
	}

	// second_quest_open_secret
	void OnSecondQuestOpenSecret()
	{
		SetAngle("face", Vector3(0, -90, 0));
		UseTrigger("door_syph1");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		NPCATK_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
		SetMoveDest(NPCATK_TARGET, 9999);
		OnDoAttack();
		NEXT_PACE = GameTime() + 30.0f;
	}

	// do_attack
	void OnDoAttack(string damage = "")
	{
		if (!(GameTime() > NEXT_ATTACK))
			return;
		NEXT_ATTACK = GameTime() + 3.0f;

		if (RandomInt(1, 2) == 1)
		{
			OnChatNow("Bring it on!", "2.0", "seeya", "none", "add_to_que");
			PlaySound(0, 10, "voices/m2_quest/sylphiel_attacked.wav");
		}
		else
		{
			OnChatNow("You're messing with more trouble than you can handle!", "2.0", "seeya", "none", "add_to_que");
			PlaySound(0, 10, "voices/m2_quest/sylphiel_warn.wav");
		}

		CallEventDelayed(2.0f, "fake_frame_attack");
	}

	// fake_frame_attack
	void OnFakeFrameAttack()
	{
		DoDamage(NPCATK_TARGET, 64, 2, "100%", "blunt");
	}

	// ext_saw_chest
	void OnExtSawChest()
	{
		OnChatNow("Oh, will you look at that, a sinister looking chest...", "4.0", "pondering", "none", "add_to_que");
		OnChatNow("Eh, just, take it. I don't even want to know what's in there.", "4.0", "none", "none", "add_to_que");
		OnChatNow("...and I'm also not going to ask what's kept that candle burning all this time.", "4.0", "none", "none", "add_to_que");
		OnChatNow("*sigh* It's just so typical of grams, having something like this.", "4.0", "pondering3", "none", "add_to_que");
		ALL_QUESTS_DONE = true;
	}

	// npc_suicide
	void OnNpcSuicide(string suicideMode = "")
	{
		if (suicideMode != "only_bad")
			DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human2.mdl");
		CallEventDelayed(5.0f, "Sylphiel_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Sylphiel_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_quest_items") { OnCheckQuestItems(Param(params, 0)); return true; }
		if (name == "circle_pot") { OnCirclePot(); return true; }
		if (name == "do_attack") { OnDoAttack(Param(params, 0)); return true; }
		if (name == "do_cook_loop") { OnDoCookLoop(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_soup") { OnDoSoup(); return true; }
		if (name == "do_soup2") { OnDoSoup2(); return true; }
		if (name == "enable_quest") { OnEnableQuest(); return true; }
		if (name == "ext_receive_quest_item") { OnExtReceiveQuestItem(Param(params, 0)); return true; }
		if (name == "ext_saw_chest") { OnExtSawChest(); return true; }
		if (name == "fake_frame_attack") { OnFakeFrameAttack(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_pot_id") { OnGetPotId(); return true; }
		if (name == "hold_for_help") { OnHoldForHelp(); return true; }
		if (name == "menu_get_soup") { OnMenuGetSoup(PlayerParam(params, 0)); return true; }
		if (name == "menu_help") { OnMenuHelp(PlayerParam(params, 0)); return true; }
		if (name == "move_closer") { OnMoveCloser(); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "second_quest_open_secret") { OnSecondQuestOpenSecret(); return true; }
		if (name == "second_quest_show") { OnSecondQuestShow(); return true; }
		if (name == "second_quest_show2") { OnSecondQuestShow2(); return true; }
		if (name == "second_quest_show_loop") { OnSecondQuestShowLoop(); return true; }
		if (name == "second_quest_start") { OnSecondQuestStart(); return true; }
		if (name == "send_menu") { OnSendMenu(); return true; }
		if (name == "setup_debug_pot") { OnSetupDebugPot(); return true; }
		if (name == "soups_on") { OnSoupsOn(); return true; }
		if (name == "soups_on2") { OnSoupsOn2(); return true; }
		if (name == "stop_circle") { OnStopCircle(); return true; }
		if (name == "tally_quest_items") { OnTallyQuestItems(EntityParam(params, 0)); return true; }
		if (name == "Sylphiel_Timer") { Sylphiel_Timer(); return true; }
		return Debug_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
