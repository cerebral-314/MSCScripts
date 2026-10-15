#pragma context server

// Converted from littleg/salandria.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "littleg/salandria"]
class Salandria : BaseChatScript
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	bool QUEST_DONE = false;
	CBaseEntity@ MEL_ID = null;
	bool SAID_MEL = false;

	// unnamed block (first think)
	void Salandria_FirstThink()
	{
		QUEST_DONE = false;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Ask about Jobs";
		menuItem.type = "callback";
		menuItem.callback = "say_job";
		RegisterMenuItem(menuItem);
		// (never true here, the rest is skipped) if SAID_URD
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		bool exitSub = false;
		// try to avoid the whole bar responding to the same statement
		if (talkingPlayer is null && RangeTo(ENT_LASTSPOKE) > 128.0f)
			exitSub = true;
		if (exitSub)
			return;

		OnSayRumour();
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(30);
		SetGold(50);
		SetName("Elven Child");
		// ov	180
		SetWidth(32);
		SetHeight(72);
		SetRace("elf");
		SetRoam(false);
		SetModel("npc/elf_fc.mdl");
		SetInvincible(true);
		LegacyCommand("setmodelbody", 0);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "greetings");

		CatchSpeech("say_what", "documents", "document", "happened", "melanion");

		CatchSpeech("say_huh", "melanoin", "melanie", "melarie", "melarion", "malenion", "malanion", "moolanie", "molonoin", "melonion", "melanuon");

		CatchSpeech("say_rumour", "rumour", "news", "happenings");
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

		OnSayHi2();
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

		if (!QUEST_DONE)
			OnSayHiNormal();
		if (QUEST_DONE)
			OnSayThanx();
	}

	// say_thanx
	void OnSayThanx()
	{
		SayText("Thanks again for what you've done for Melanion, You are my new friend now.");
	}

	// say_hi_normal
	void OnSayHiNormal()
	{
		SayText("Hello! My name is Salandria.");
		SetName("Salandria");
		CallEventDelayed(0.0f, "3");
	}

	// say_hi2
	void OnSayHi2()
	{
		@MEL_ID = FindByName("melanion");
		CallExternal(MEL_ID, "askdocuments");

		SayText("You look like a friendly person, maybe you can help me with something.");
		CallEventDelayed(0.0f, "4");
	}

	// say_hi3
	void OnSayHi3()
	{
		SayText("My mother's good friend Melanion took me here, but she is very distressed.");
		CallEventDelayed(0.0f, "7");
	}

	// say_hi4
	void OnSayHi4()
	{
		SayText("She lost some documents from our home. It means so much to her.");
		SayText("she's been very quiet, barely eats, and talks of nothing but the documents.");
		SAID_MEL = true;
	}

	// say_what
	void OnSayWhat()
	{
		if (QUEST_DONE)
			return;

		SayText("I found her with a tragic look, and no documents.");
		CallEventDelayed(0.0f, "3");
	}

	// say_what2
	void OnSayWhat2()
	{
		SayText("She is getting better but she is still so sad.");
		CallEventDelayed(0.0f, "3");
	}

	// say_what3
	void OnSayWhat3()
	{
		SayText("You'd best ask her, she's been distraught over the loss of her documents.");
	}

	// say_huh
	void OnSayHuh()
	{
		SayText("Who are you talking about? You mean Melanion? She's up there.");
	}

	// bookfound
	void OnBookfound()
	{
		// dbg temp Quest Complete
		QUEST_DONE = true;
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		bool exitSub = false;

		// try to avoid the whole bar responding to the same statement
		if (speaker.isEmpty() && RangeTo(ENT_LASTSPOKE) > 128.0f)
			exitSub = true;
		if (exitSub)
			return;

		PlayAnim("once", "pondering");
		SayText("I heard Melanion's meeting has something to do with Eswen Sylen and about allowing humans inside.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/elf_fc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Salandria_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bookfound") { OnBookfound(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_hi3") { OnSayHi3(); return true; }
		if (name == "say_hi4") { OnSayHi4(); return true; }
		if (name == "say_hi_normal") { OnSayHiNormal(); return true; }
		if (name == "say_huh") { OnSayHuh(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_thanx") { OnSayThanx(); return true; }
		if (name == "say_what") { OnSayWhat(); return true; }
		if (name == "say_what2") { OnSayWhat2(); return true; }
		if (name == "say_what3") { OnSayWhat3(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
