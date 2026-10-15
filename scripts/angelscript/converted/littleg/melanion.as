#pragma context server

// Converted from littleg/melanion.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "littleg/melanion"]
class Melanion : BaseChatScript
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	bool B_QUEST_DONE = false;
	bool TALKED_SALANDRIA = false;
	bool TOLD_STORY = true;
	CBasePlayer@ QUEST_COMPLETER = null;

	// unnamed block (first think)
	void Melanion_FirstThink()
	{
		B_QUEST_DONE = false;
		TALKED_SALANDRIA = false;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (Truthy(ItemExists(player, "item_documents")))
		{
			menuItem.title = "Return documents";
			menuItem.type = "payment";
			menuItem.data = "item_documents";
			menuItem.callback = "give_documents";
			RegisterMenuItem(menuItem);
		}

		if (TALKED_SALANDRIA && !B_QUEST_DONE)
		{
			menuItem.title = "Ask about Documents";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}
	}

	// spawn
	void OnSpawn()
	{
		SetUniqueName("melanion");
		SetHealth(30);
		SetGold(50);
		SetName("Ambassador Melanion Belore");
		// ov	30
		SetWidth(32);
		SetHeight(72);
		SetRace("elf");
		SetRoam(false);
		SetModel("npc/elf_f.mdl");
		SetInvincible(true);
		LegacyCommand("setmodelbody", 0);

		CatchSpeech("say_hi", "hi", "hail", "hello", "greet");

		CatchSpeech("say_job", "documents");
	}

	// askbook
	void OnAskbook()
	{
		TALKED_SALANDRIA = true;
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
			PlayAnim("once", "no");
			SayText("I will loose my job...and the whole transaction will fail...please leave me alone.");
		}

		if (B_QUEST_DONE)
		{
			string winnerName = NameOf(QUEST_COMPLETER);
			SayText("Hello! I'm so happy now that " + winnerName + " has returned my documents!");
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

		if (!TALKED_SALANDRIA)
			return;
		if (B_QUEST_DONE)
			return;

		SayText("You know about the documents? You must have learned of it from Salandria.");
		CallEventDelayed(0.0f, "4");
	}

	// say_bothered1a
	void OnSayBothered1a()
	{
		PlayAnim("once", "no");
		SayText("..I am a diplomat from Kray Eldorad, i had some documents..");
		CallEventDelayed(0.0f, "4");
	}

	// story
	void OnStory()
	{
		PlayAnim("once", "converse1");
		SayText("We were planning a diplomatic meeting. I came all the way from Kray Eldorad.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story2
	void OnSayStory2()
	{
		PlayAnim("critial", "talkright");
		SayText("I was walking in the garden, when a man came by, he stole my documents!.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story3
	void OnSayStory3()
	{
		PlayAnim("critial", "converse1");
		SayText("Thoose Documents had very important information, i chased him all the way to Thornlands, to a place called the Spider Cavern.");
		CallEventDelayed(0.0f, "7");
	}

	// say_story4
	void OnSayStory4()
	{
		PlayAnim("once", "converse1");
		SayText("I was then startled by many spiders, and had to flee, thoose documents MUST be back before the meeting, please help me.");
		CallEventDelayed(0.0f, "6");
	}

	// say_story5
	void OnSayStory5()
	{
		PlayAnim("once", "converse1");
		SayText("He is in there somewhere, please find him...it is so important for me...");
		CallEventDelayed(0.0f, "5");
	}

	// say_story6
	void OnSayStory6()
	{
		PlayAnim("once", "converse1");
		SayText("I tried talking to Edrin but he said his guards were far too busy and that he could not spare one.");
		CallEventDelayed(0.0f, "5");
	}

	// say_story7
	void OnSayStory7()
	{
		PlayAnim("once", "yes");
		SayText("If you can return my documents, i will make sure you will be rewarded.");
		TOLD_STORY = true;
	}

	// give_book
	void OnGiveBook(CBasePlayer@ completer = null)
	{
		ReceiveOffer("accept");
		PlayAnim("once", "eye_wipe");
		SayText("The Documents! By Felewyn Bless you! !");
		Say("[.10]", "[.20]", "[.20]", "[.10]", "[.10]", "[.10]", "[.25]", "[.20]", "[.10]", "[.30]", "[.20]", "[.40]");

		@QUEST_COMPLETER = completer;
		B_QUEST_DONE = true;
		CallEventDelayed(2.0f, "recvdocuments_2");
	}

	// recvbook_2
	void OnRecvbook2()
	{
		B_QUEST_DONE = true;
		CallExternal(FindByName("salandria"), "documentsfound");
		SayText("Here, some coins, and a gift from Salandria.");
		Offer(QUEST_COMPLETER, "gold", RandomInt(13, 16));
		Offer("QUEST_COMPLETE", "item_bracelet");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_f.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Melanion_FirstThink();
		BaseChat_FirstThink();
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
		return BaseChatScript::DispatchEvent(name, params);
	}
}
