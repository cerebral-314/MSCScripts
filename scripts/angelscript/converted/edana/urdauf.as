#pragma context server

// Converted from edana/urdauf.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "edana/urdauf"]
class Urdauf : BaseChatArrayScript
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	bool B_QUEST_DONE = false;
	bool TALKED_SUMDALE = false;
	bool TOLD_STORY = true;
	CBasePlayer@ QUEST_COMPLETER = null;

	// Variables declared by included files, with the value they start with in this script
	Urdauf()
	{
		CHAT_AUTO_HAIL = true;
		CHAT_USE_CONV_ANIMS = false;
	}

	// unnamed block (first think)
	void Urdauf_FirstThink()
	{
		B_QUEST_DONE = false;
		TALKED_SUMDALE = false;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_book_old")))
		{
			menuItem.title = "Return book";
			menuItem.type = "payment";
			menuItem.data = "item_book_old";
			menuItem.callback = "give_book";
			RegisterMenuItem(menuItem);
		}

		if (TALKED_SUMDALE && !B_QUEST_DONE)
		{
			menuItem.title = "Ask about Book";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}
	}

	// spawn
	void OnSpawn()
	{
		SetUniqueName("urduaf");
		SetHealth(30);
		SetGold(50);
		SetName("Urduaf");
		// ov	30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 2);

		CatchSpeech("say_hi", "hi", "hail", "hello", "greet");

		CatchSpeech("say_job", "book");
	}

	// askbook
	void OnAskbook()
	{
		TALKED_SUMDALE = true;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		bool exitSub = false;

		// try to avoid the whole bar responding to the same statement
		if (talkingPlayer is null && RangeTo(ENT_LASTSPOKE) > 128.0f)
			exitSub = true;
		if (exitSub)
			return;

		if (!B_QUEST_DONE)
		{
			OnChatNow("Look, I don't feel like talking right now so please just leave.");
			PlayAnim("critical", "no");
		}

		if (B_QUEST_DONE)
		{
			string winnerName = NameOf(QUEST_COMPLETER);
			string msg = "I'm so happy now that " + winnerName + " has returned my journal!";
			PlayAnim("once", "wave");
			OnChatNow(msg);
		}
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		bool exitSub = false;

		// try to avoid the whole bar responding to the same statement
		if (player is null && RangeTo(ENT_LASTSPOKE) > 128.0f)
			exitSub = true;
		if (exitSub)
			return;

		if (!TALKED_SUMDALE)
			return;
		if (B_QUEST_DONE)
			return;

		OnChatNow("You know about the book? You must have learned of it from Sumdale.");
		CallEventDelayed(0.0f, "4");
	}

	// say_bothered1a
	void OnSayBothered1a()
	{
		PlayAnim("once", "no");
		OnChatNow("..I had a book once, it's very important to me.. ");
		CallEventDelayed(0.0f, "3");
	}

	// story
	void OnStory()
	{
		PlayAnim("once", "converse1");
		OnChatNow("I was foolish enough to take it with me to explore the caves. I fancied myself an adventurer.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story2
	void OnSayStory2()
	{
		PlayAnim("critial", "talkright");
		OnChatNow("I was going to explore a little and write down what I found.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story3
	void OnSayStory3()
	{
		PlayAnim("critial", "converse1");
		OnChatNow("I was in a room with an incredible drop off. There was a chest nearby.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story4
	void OnSayStory4()
	{
		PlayAnim("once", "converse1");
		OnChatNow("I was startled by an huge spider. If there are any spiders bigger than that I'd hate to meet it. ");
		CallEventDelayed(0.0f, "5");
	}

	// say_story5
	void OnSayStory5()
	{
		PlayAnim("once", "converse1");
		OnChatNow("I dropped my precious book and ran to the surface. There was a cave in behind me as I crawled frantically away.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story6
	void OnSayStory6()
	{
		PlayAnim("once", "converse1");
		OnChatNow("I couldn't get back to my book and now all I can ask is for the help of a real adventurer.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story7
	void OnSayStory7()
	{
		PlayAnim("once", "yes");
		OnChatNow("If you can return my book to me i'm sure there'd be some kind of reward for your troubles.");
		TOLD_STORY = true;
	}

	// give_book
	void OnGiveBook(CBasePlayer@ completer = null)
	{
		ReceiveOffer("accept");
		PlayAnim("once", "eye_wipe");
		OnChatNow("My god, that's my book! I cannot thank you enough brave adventurer!");
		Say("[.10]", "[.20]", "[.20]", "[.10]", "[.10]", "[.10]", "[.25]", "[.20]", "[.10]", "[.30]", "[.20]", "[.40]");

		@QUEST_COMPLETER = completer;
		B_QUEST_DONE = true;
		CallEventDelayed(2.0f, "recvbook_2");
	}

	// recvbook_2
	void OnRecvbook2()
	{
		B_QUEST_DONE = true;
		CallExternal(FindByName("sumdale"), "bookfound");
		OnChatNow("Here, take this gold as a reward, adventurer.");
		Offer(QUEST_COMPLETER, "gold", RandomInt(6, 9));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Urdauf_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "askbook") { OnAskbook(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_book") { OnGiveBook(PlayerParam(params, 0)); return true; }
		if (name == "recvbook_2") { OnRecvbook2(); return true; }
		if (name == "say_bothered1a") { OnSayBothered1a(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_story2") { OnSayStory2(); return true; }
		if (name == "say_story3") { OnSayStory3(); return true; }
		if (name == "say_story4") { OnSayStory4(); return true; }
		if (name == "say_story5") { OnSayStory5(); return true; }
		if (name == "say_story6") { OnSayStory6(); return true; }
		if (name == "say_story7") { OnSayStory7(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "story") { OnStory(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
