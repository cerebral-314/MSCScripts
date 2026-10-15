#pragma context server

// Converted from NPCs/lighthouse_keeper.script by msc_transpiler.
// Lighthouse keeper NPC for Dridge's Gwhatzitz map

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/debug.as"

[script "NPCs/lighthouse_keeper"]
class LighthouseKeeper : BaseChatScript, Debug
{
	// Constants
	string TEND_ANIMS = "console;dryhands;writeboard;studycart;lean;pondering;pondering2;pondering3;buysoda;console;console;console;console;console;";
	string BASIC_REWARDS = "smallarms_huggerdagger3;smallarms_craftedknife3;smallarms_stiletto;swords_katana;axes_scythe;axes_doubleaxe;blunt_greatmaul;blunt_mace;bows_longbow;scroll_summon_rat;armor_leather_studded;armor_helm_knight;";
	bool NO_HAIL = true;
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	string ANIM_IDLE_CHAT = "idle1";

	// Variables (an unset .script variable reads as its own name)
	bool TENDING_HOUSE = false;
	string MENU_MODE = "MENU_MODE";
	float MY_YAW = 0.0f;
	bool WAS_STARTLED = false;
	string TASK_STRING = "TASK_STRING";
	string MENU_TARGET = "MENU_TARGET";
	string MENU_QUEST = "MENU_QUEST";
	int CONFIRM_STEP = 0;
	CBasePlayer@ HIRED_SPIDER = null;
	CBasePlayer@ HIRED_GRAVE = null;
	CBasePlayer@ HIRED_CRYSTAL = null;
	CBasePlayer@ HIRED_FOOD = null;
	bool APPLE_QUEST_ACTIVE = false;
	bool DONE_CRYSTAL = false;
	bool DONE_FOOD = false;
	bool DONE_SPIDER = false;
	bool DONE_GRAVE = false;

	// Variables declared by included files, with the value they start with in this script
	LighthouseKeeper()
	{
		CHAT_DELAY = 4.5f;
	}

	// unnamed block (timer)
	void LighthouseKeeper_Timer()
	{
		CallEventDelayed(Random(3, 5), "LighthouseKeeper_Timer");

		// random anims while tending lighthouse
		if (!TENDING_HOUSE)
			return;
		SetAngle("face", Vector3(0, MY_YAW, 0));

		int nIdles = GetTokenCount(TEND_ANIMS);
		float rndIdle = RandomInt(1, nIdles) - 1.0f; // token arrays index on 0
		string idleAnim = GetToken(TEND_ANIMS, int(rndIdle));
		SetIdleAnim(idleAnim);
		SetMoveAnim(idleAnim);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat

		SetUniqueName("lkeeper");

		SetName("Hyehold, the Lighthouse Keep");
		SetHealth(1);
		SetInvincible(true);
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetModel("npc/human1.mdl");
		SetModelBody(0, 3); // apron
		SetModelBody(1, 5); // baldie
		SetRoam(false);
		SetMoveAnim("idle1");
		SetHearingSensitivity(10);
		SetSayTextRange(1024);

		SetNoPush(true);

		TENDING_HOUSE = true;
		CallEventDelayed(0.1f, "get_yaw"); // yaw is grabbed post spawn, so he knows where to face back to
		MENU_MODE = "normal";

		CatchSpeech("say_hi", "hail", "yo", "j0", "hi", "hello", "wassup", "greet");

		CatchSpeech("say_food", "food");
		CatchSpeech("say_crystal", "crystal");
		CatchSpeech("say_grave", "grave");
		CatchSpeech("say_spider", "spider");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		// cancel quest option
		string curQuest = GetQuestData(player, "l");

		if (MENU_MODE != "confirm")
		{
			if (Truthy(ItemExists(player, "item_light_crystal")) && !DONE_CRYSTAL)
			{
				menuItem.title = "Offer Light Crystal";
				menuItem.type = "payment";
				menuItem.data = "item_light_crystal";
				menuItem.callback = "reward_crystal";
				RegisterMenuItem(menuItem);
			}

			if (Truthy(ItemExists(player, "health_apple")) && APPLE_QUEST_ACTIVE && !DONE_FOOD)
			{
				menuItem.title = "Offer Apple";
				menuItem.type = "payment";
				menuItem.data = "health_apple";
				menuItem.callback = "reward_food";
				RegisterMenuItem(menuItem);
			}

			if (curQuest == "0")
			{
				menuItem.title = "Hail";
				menuItem.type = "callback";
				menuItem.callback = "say_hi";
				RegisterMenuItem(menuItem);

				if (WAS_STARTLED)
				{
					if (!DONE_SPIDER)
					{
						menuItem.title = "Ask about spiders";
						menuItem.type = "callback";
						menuItem.callback = "say_spider";
						RegisterMenuItem(menuItem);
					}

					if (!DONE_GRAVE)
					{
						menuItem.title = "Ask about Feldar's Grave";
						menuItem.type = "callback";
						menuItem.callback = "say_grave";
						RegisterMenuItem(menuItem);
					}

					if (!DONE_CRYSTAL)
					{
						menuItem.title = "Ask about crystals";
						menuItem.type = "callback";
						menuItem.callback = "say_crystal";
						RegisterMenuItem(menuItem);
					}

					if (!DONE_FOOD)
					{
						menuItem.title = "Ask about food";
						menuItem.type = "callback";
						menuItem.callback = "say_food";
						RegisterMenuItem(menuItem);
					}

					menuItem.title = "Ask about forest";
					menuItem.type = "callback";
					menuItem.callback = "say_forest";
					RegisterMenuItem(menuItem);
				}
			}
		}

		// confirm quests
		if (MENU_MODE == "confirm")
		{
			if (MENU_QUEST == "spider")
				menuItem.title = "I'll clear the eggs.";
			if (MENU_QUEST == "grave")
				menuItem.title = "I'll visit the grave.";
			if (MENU_QUEST == "crystal")
				menuItem.title = "I'll get the crystals.";
			if (MENU_QUEST == "food")
				menuItem.title = "I'll bring some apples.";

			menuItem.type = "callback";
			menuItem.callback = "accept_quest";
			RegisterMenuItem(menuItem);

			menuItem.title = "Sorry. I'm busy.";
			menuItem.type = "callback";
			menuItem.callback = "decline_quest";
			RegisterMenuItem(menuItem);
		}

		if (DONE_SPIDER && player is HIRED_SPIDER && curQuest == "spider")
		{
			menuItem.title = "Collect Spider Quest Reward";
			menuItem.type = "callback";
			menuItem.callback = "reward_spider";
			RegisterMenuItem(menuItem);
		}

		if (DONE_GRAVE && player is HIRED_GRAVE && curQuest == "grave")
		{
			menuItem.title = "Collect Grave Quest Reward";
			menuItem.type = "callback";
			menuItem.callback = "reward_grave";
			RegisterMenuItem(menuItem);
		}

		if (curQuest != "0")
		{
			string remindStr = "Cancel " + curQuest + " quest";

			menuItem.title = remindStr;
			menuItem.type = "callback";
			menuItem.callback = "clear_quest";
			RegisterMenuItem(menuItem);
		}
	}

	// face_speaker
	void OnFaceSpeaker(string speaker = "")
	{
		BaseChat_OnFaceSpeaker(speaker); // monsters/base_chat
		TENDING_HOUSE = false; // stop tending
		SetIdleAnim(ANIM_IDLE_CHAT);
		SetMoveAnim(ANIM_IDLE_CHAT);
	}

	// chat_loop
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat

		WAS_STARTLED = true; // damn thing wont stick

		if (MENU_MODE == "confirm" && CHAT_STEP == CONFIRM_STEP)
			OpenMenu(MENU_TARGET);

		if (CHAT_STEP == 2.0f)
			OnConvoAnim();
		if (CHAT_STEP == 4.0f)
			OnConvoAnim();
		if (CHAT_STEP == 6.0f)
			OnConvoAnim();
		if (CHAT_STEP == 8.0f)
			OnConvoAnim();
		if (CHAT_STEP == 10.0f)
			OnConvoAnim();
	}

	// get_yaw
	void OnGetYaw()
	{
		MY_YAW = Float(Eval("game.monster.angles.yaw"));
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ faceTarg = null;

		if (!IsPlayer(talkingPlayer))
			@faceTarg = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(talkingPlayer))
			@faceTarg = talkingPlayer;
		OnFaceSpeaker(EntityId(faceTarg));

		OnSayIntro();
	}

	// say_intro
	void OnSayIntro()
	{
		bool exitSub = false;

		if (BUSY_CHATTING)
			return;
		if (!WAS_STARTLED)
		{
			WAS_STARTLED = true;
			PlayAnim("critical", "eye_wipe");
			CHAT_STEPS = 2;
			CHAT_STEP = 0.0f;
			BUSY_CHATTING = true;
			CHAT_STEP1 = "Oh! Hello there!";
			CHAT_STEP2 = "Sorry for being so startled. It's not very often I get visitors way up here.";
			OnChatLoop();

			float nextChat = CHAT_DELAY * CHAT_STEPS + 0.5f;
			CallEventDelayed(nextChat, "say_jobs");
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!WAS_STARTLED)
			return;
		PlayAnim("critical", ANIM_IDLE_CHAT);
		OnSayJobs();
	}

	// say_jobs
	void OnSayJobs()
	{
		if (BUSY_CHATTING)
			return;

		CHAT_STEPS = 2;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "It's just me up here, and I'm getting on in years, so I often neglect many tasks...";
		OnBuildTaskString();
		CHAT_STEP2 = TASK_STRING;
		OnChatLoop();
		CallEventDelayed(2.0f, "convo_anim");
		MENU_MODE = "pick_quest";
	}

	// build_task_string
	void OnBuildTaskString()
	{
		bool questsLeft = false;
		TASK_STRING = "For instance, ";
		if (!DONE_SPIDER)
		{
			TASK_STRING += "killing those darn [spiders], ";
			questsLeft = true;
		}
		if (!DONE_GRAVE)
		{
			TASK_STRING += "tending Feldar's [grave], ";
			questsLeft = true;
		}
		if (!DONE_CRYSTAL)
		{
			TASK_STRING += "gathering lighthouse [crystals], ";
			questsLeft = true;
		}
		if (!DONE_FOOD)
		{
			TASK_STRING += "not to mention simply getting some [food]!";
			questsLeft = true;
		}
		if (!questsLeft)
		{
			TASK_STRING = "But good young lads like yourself come and fix me up from time to time - so - I've nothing that needs doing just now.";
			CallEventDelayed(2.0f, "resume_tending");
		}
	}

	// say_spider
	void OnSaySpider(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;
		CBaseEntity@ faceTarg = null;

		if (BUSY_CHATTING)
			return;

		if (DONE_SPIDER)
		{
			PlayAnim("critical", "wave");
			SayText("Oh, someone already got rid of those for me. Thank you anyways.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!IsPlayer(speaker))
			@faceTarg = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(speaker))
			@faceTarg = speaker;
		OnFaceSpeaker(EntityId(faceTarg));

		if (GetQuestData(faceTarg, "l") != "0")
		{
			OnTargetBusy(faceTarg);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (IsAlive(HIRED_SPIDER))
		{
			SayText(NameOf(HIRED_SPIDER) + " is already working on that for me.");
			exitSub = true;
			TENDING_HOUSE = true;
			OnBchatMouthMove();
		}
		if (exitSub)
			return;

		MENU_TARGET = EntityId(faceTarg);
		CHAT_STEPS = 4;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Well, there's a spider infestation in the caves below. I've put it off for far too long, so...";
		CHAT_STEP2 = "...I figure by now there's got to be a nest and some very sizable eggs.";
		CHAT_STEP3 = "If those hatch I could be in for more than a little trouble!";
		CHAT_STEP4 = "Think you could go down there and take care of that for me? I'd be ever so grateful.";
		MENU_MODE = "confirm";
		MENU_QUEST = "spider";
		CONFIRM_STEP = 4;
		OnChatLoop();
		CallEventDelayed(2.0f, "convo_anim");
		CallEventDelayed(6.0f, "convo_anim");
	}

	// say_grave
	void OnSayGrave(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;
		CBaseEntity@ faceTarg = null;

		if (BUSY_CHATTING)
			return;

		if (DONE_GRAVE)
		{
			PlayAnim("critical", "wave");
			SayText("Oh, someone already delivered that for me, thanks.");
			OnBchatMouthMove();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!IsPlayer(speaker))
			@faceTarg = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(speaker))
			@faceTarg = speaker;
		OnFaceSpeaker(EntityId(faceTarg));

		if (GetQuestData(faceTarg, "l") != "0")
		{
			OnTargetBusy(faceTarg);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (IsAlive(HIRED_GRAVE))
		{
			SayText(NameOf(HIRED_GRAVE) + " is already working on that for me.");
			exitSub = true;
			OnBchatMouthMove();
			TENDING_HOUSE = true;
		}
		if (exitSub)
			return;

		MENU_TARGET = EntityId(faceTarg);
		CHAT_STEPS = 6;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Well, my old friend Feldar, always the good samaritan, was out escorting some fresh adventurers around the Thornlands.";
		CHAT_STEP2 = "Near as the constable could tell, it turns out they were actually bandits, and they assasinated the kindhearted old fool.";
		CHAT_STEP3 = "He loved this old place, so we made his grave just around the back, ... I used to visit it quite often, but lately it's been... Strange.";
		CHAT_STEP4 = "He had a favorite figurine of The Goddess Felewyn, you see. His widow brought it to me recently. I think he wanted it buried with him...";
		CHAT_STEP5 = "Or at least that would explain the... Unrest... Outside.";
		CHAT_STEP6 = "You look like you might be able to brave the denizens around there. If you could bring this statuette there, I'm sure it'd all quiet down.";
		MENU_MODE = "confirm";
		MENU_QUEST = "grave";
		CONFIRM_STEP = 6;
		OnChatLoop();
	}

	// say_crystal
	void OnSayCrystal(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;
		CBaseEntity@ faceTarg = null;

		if (BUSY_CHATTING)
			return;

		if (DONE_CRYSTAL)
		{
			PlayAnim("critical", "wave");
			SayText("Oh, someone already got those for me, thanks.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!IsPlayer(speaker))
			@faceTarg = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(speaker))
			@faceTarg = speaker;
		OnFaceSpeaker(EntityId(faceTarg));

		if (GetQuestData(faceTarg, "l") != "0")
		{
			OnTargetBusy(faceTarg);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (IsAlive(HIRED_CRYSTAL))
		{
			SayText(NameOf(HIRED_CRYSTAL) + " is already working on that for me.");
			exitSub = true;
			OnBchatMouthMove();
			TENDING_HOUSE = true;
		}
		if (exitSub)
			return;

		MENU_TARGET = EntityId(faceTarg);
		CHAT_STEPS = 5;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Ah, well... The lighthouse here's been a bit flickery as of late - I think she needs some new crystals.";
		CHAT_STEP2 = "The light crystals that power the magic core are fairly common in these parts...";
		CHAT_STEP3 = "But with all the things I've seen crawling about lately, I just don't feel up to grabbing them myself!";
		CHAT_STEP4 = "If you could find me a good set, I'll reward ye handsomely.";
		CHAT_STEP5 = "Otherwise we could wind up with a boat smashed up on the rocks, and that'd be bad for business!";
		MENU_MODE = "confirm";
		MENU_QUEST = "crystal";
		CONFIRM_STEP = 4;
		OnChatLoop();
	}

	// say_food
	void OnSayFood(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;
		CBaseEntity@ faceTarg = null;

		if (BUSY_CHATTING)
			return;

		if (DONE_FOOD)
		{
			PlayAnim("critical", "wave");
			SayText("Oh, someone already got me some - I'm quite sated, thanks.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!IsPlayer(speaker))
			@faceTarg = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(speaker))
			@faceTarg = speaker;
		OnFaceSpeaker(EntityId(faceTarg));

		if (GetQuestData(faceTarg, "l") != "0")
		{
			OnTargetBusy(faceTarg);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (IsAlive(HIRED_FOOD))
		{
			SayText(NameOf(HIRED_FOOD) + " is already working on that for me.");
			exitSub = true;
			OnBchatMouthMove();
		}
		if (exitSub)
			return;

		MENU_TARGET = EntityId(faceTarg);
		CHAT_STEPS = 3;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "I... I don't think I've actually eaten a thing in a week, now that I think of it...";
		CHAT_STEP2 = "...and I really try not to, believe me. Too busy for food and all...";
		CHAT_STEP3 = "If you could just bring me an apple or two, anything really, I'd be so very grateful.";
		MENU_MODE = "confirm";
		MENU_QUEST = "food";
		CONFIRM_STEP = 3;
		OnChatLoop();
	}

	// accept_quest
	// menu response
	void OnAcceptQuest(CBasePlayer@ player = null)
	{
		string trigStr = "quest_" + MENU_QUEST;
		UseTrigger(trigStr);

		Quest("set", player, "l", MENU_QUEST);
		MENU_MODE = "normal";
		OnConvoAnim();

		if (MENU_QUEST == "spider")
		{
			@HIRED_SPIDER = player;
			SayText("Thank you, oh so much. Come back here when ya clear out those pests.");
		}

		if (MENU_QUEST == "grave")
		{
			@HIRED_GRAVE = player;
			SayText("Thank you, oh so much. Come back here when you've done the deed and I'll reward you.");
			Offer(player, "item_fstatue");
		}

		if (MENU_QUEST == "crystal")
		{
			@HIRED_CRYSTAL = player;
			SayText("Thank you, oh so much. Be careful with those crystals by the way - they are quite fragile!");
		}

		if (MENU_QUEST == "food")
		{
			@HIRED_FOOD = player;
			SayText("Oh yes, please bring me something, I'd be grateful beyond words.");
			APPLE_QUEST_ACTIVE = true;
		}

		TENDING_HOUSE = true;
	}

	// decline_quest
	// menu response
	void OnDeclineQuest(CBasePlayer@ player = null)
	{
		MENU_MODE = "normal";
		Quest("set", player, "l", 0);
		PlayAnim("critical", "no");
		SayText("Well... That's alright. At least you're some company... I guess.");
		OnBchatMouthMove();
		TENDING_HOUSE = true;
	}

	// reward_spider
	void OnRewardSpider(CBasePlayer@ winner = null)
	{
		OnFaceSpeaker(EntityId(winner));
		OnConvoAnim();
		Offer(winner, "gold", RandomInt(10, 20));
		OnOfferBasicReward(winner);
		int scrollChance = RandomInt(1, 2);
		if (scrollChance == 1)
		{
			int scrollTome = RandomInt(1, 2);
			if (scrollTome == 1)
				Offer(winner, "scroll2_ice_shield_lesser");
			if (scrollTome == 2)
				Offer(winner, "scroll_ice_shield_lesser");
		}
		if (scrollChance == 2)
			OnOfferBasicReward(winner);
		SayText("Thank you so very much. I'd hate to have a swarm of eight leggeds creeping up here.");
		Quest("set", winner, "l", 0);
		CallEventDelayed(2.0f, "resume_tending");
	}

	// reward_grave
	void OnRewardGrave(CBasePlayer@ winner = null)
	{
		OnOfferBasicReward(winner);

		OnFaceSpeaker(EntityId(winner));
		OnConvoAnim();
		Offer(winner, "gold", RandomInt(10, 15));
		SayText("Thank you so very much. I'm sure he'll rest easier now.");
		Quest("set", winner, "l", 0);
		CallEventDelayed(2.0f, "resume_tending");
	}

	// reward_crystal
	void OnRewardCrystal(CBasePlayer@ winner = null)
	{
		OnOfferBasicReward(winner);

		DONE_CRYSTAL = true;
		OnFaceSpeaker(EntityId(winner));
		OnConvoAnim();
		Offer(winner, "gold", RandomInt(10, 20));
		SayText("A crystal! Thank goodness! I'm sure they'd hang me if we had another... Accident.");
		Quest("set", winner, "l", 0);
		CallEventDelayed(2.0f, "resume_tending");
	}

	// reward_food
	void OnRewardFood(CBasePlayer@ winner = null)
	{
		OnOfferBasicReward(winner);

		DONE_FOOD = true;
		OnFaceSpeaker(EntityId(winner));
		OnConvoAnim();
		Offer(winner, "gold", 5);
		SayText("I thank ye! My stomach, doubly so!");
		Quest("set", winner, "l", 0);
		CallEventDelayed(2.0f, "resume_tending");
	}

	// resume_tending
	// for delay
	void OnResumeTending()
	{
		TENDING_HOUSE = true;
	}

	// clear_quest
	// menu response
	void OnClearQuest(CBasePlayer@ player = null)
	{
		string curQuest = GetQuestData(player, "l");
		if (curQuest == "spider")
			@HIRED_SPIDER = null;
		if (curQuest == "grave")
		{
			@HIRED_GRAVE = null;
			string methodHack = LegacyFunction("item_exists", @player, "item_fstatue", "remove");
		}
		if (curQuest == "crystal")
			@HIRED_CRYSTAL = null;
		if (curQuest == "food")
			@HIRED_FOOD = null;
		MENU_MODE = "normal";
		Quest("set", player, "l", 0);
		SayText("That's alright. There's plenty else to do around here too, if you're interested.");
		OnBchatMouthMove();
		TENDING_HOUSE = true;
	}

	// target_busy
	void OnTargetBusy(CBaseEntity@ target = null)
	{
		// player is already on a quest for me
		PlayAnim("critical", "pondering3");
		string curQuest = GetQuestData(target, "l");
		if (curQuest == "spider")
			SayText("Didn't you say you were going to kill some spiders for me?");
		if (curQuest == "grave")
			SayText("Didn't you say you were going to tend Feldar's grave for me?");
		if (curQuest == "crystal")
			SayText("Didn't you say you were going to get some crystals for me?");
		if (curQuest == "food")
			SayText("Didn't you say you were going to get me some food?");
		MENU_MODE = "confirm";
		MENU_QUEST = curQuest;
		OpenMenu(target);
	}

	// quest_done_spider
	// external map event
	void OnQuestDoneSpider()
	{
		DONE_SPIDER = true;
	}

	// quest_done_grave
	// external from other/grave_watcher
	void OnQuestDoneGrave()
	{
		DONE_GRAVE = true;
	}

	// offer_basic_reward
	void OnOfferBasicReward(CBasePlayer@ winner = null)
	{
		int nRewards = GetTokenCount(BASIC_REWARDS);
		int rndReward = RandomInt(0, nRewards);
		Offer(winner, GetToken(BASIC_REWARDS, rndReward));
	}

	// say_forest
	void OnSayForest(CBasePlayer@ speaker = null)
	{
		CBaseEntity@ faceTarg = null;

		if (BUSY_CHATTING)
			return;

		if (!IsPlayer(speaker))
			@faceTarg = EntityOf(ENT_LASTSPOKE);
		if (IsPlayer(speaker))
			@faceTarg = speaker;
		OnFaceSpeaker(EntityId(faceTarg));

		CHAT_STEPS = 4;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Oh, that forest over there. Lots of wolves in that forest. Nasty place.";
		CHAT_STEP2 = "A young adventurer wandered into there the other day. He looked a bit green around the ears, if you catch my meaning.";
		CHAT_STEP3 = "I tried to stop him, but he wouldn't listen.";
		if (PlayerCount() == 1)
			CHAT_STEP4 = "You look like a strapping young lad. You might want to go in there and check on him.";
		if (PlayerCount() > 1)
			CHAT_STEP4 = "You look like strapping young lads. You might want to go in there and check on him.";
		OnChatLoop();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNextChat() {} // NEXT_CHAT

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(Float(Eval("$randf(3,5)")), "LighthouseKeeper_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "accept_quest") { OnAcceptQuest(PlayerParam(params, 0)); return true; }
		if (name == "build_task_string") { OnBuildTaskString(); return true; }
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "clear_quest") { OnClearQuest(PlayerParam(params, 0)); return true; }
		if (name == "decline_quest") { OnDeclineQuest(PlayerParam(params, 0)); return true; }
		if (name == "face_speaker") { OnFaceSpeaker(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_yaw") { OnGetYaw(); return true; }
		if (name == "offer_basic_reward") { OnOfferBasicReward(PlayerParam(params, 0)); return true; }
		if (name == "quest_done_grave") { OnQuestDoneGrave(); return true; }
		if (name == "quest_done_spider") { OnQuestDoneSpider(); return true; }
		if (name == "resume_tending") { OnResumeTending(); return true; }
		if (name == "reward_crystal") { OnRewardCrystal(PlayerParam(params, 0)); return true; }
		if (name == "reward_food") { OnRewardFood(PlayerParam(params, 0)); return true; }
		if (name == "reward_grave") { OnRewardGrave(PlayerParam(params, 0)); return true; }
		if (name == "reward_spider") { OnRewardSpider(PlayerParam(params, 0)); return true; }
		if (name == "say_crystal") { OnSayCrystal(PlayerParam(params, 0)); return true; }
		if (name == "say_food") { OnSayFood(PlayerParam(params, 0)); return true; }
		if (name == "say_forest") { OnSayForest(PlayerParam(params, 0)); return true; }
		if (name == "say_grave") { OnSayGrave(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_intro") { OnSayIntro(); return true; }
		if (name == "say_jobs") { OnSayJobs(); return true; }
		if (name == "say_spider") { OnSaySpider(PlayerParam(params, 0)); return true; }
		if (name == "target_busy") { OnTargetBusy(EntityParam(params, 0)); return true; }
		if (name == "LighthouseKeeper_Timer") { LighthouseKeeper_Timer(); return true; }
		return Debug_DispatchEvent(name, params)
			|| BaseChatScript::DispatchEvent(name, params);
	}
}
