#pragma context server

// Converted from edana/sumdale.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "edana/sumdale"]
class Sumdale : BaseChatArrayScript
{
	// Variables (an unset .script variable reads as its own name)
	bool QUEST_DONE = false;
	CBaseEntity@ URD_ID = null;
	bool SAID_URD = false;

	// Variables declared by included files, with the value they start with in this script
	Sumdale()
	{
		CHAT_AUTO_HAIL = true;
	}

	// unnamed block (first think)
	void Sumdale_FirstThink()
	{
		// const NO_JOB 1
		QUEST_DONE = false;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		if (!SAID_URD)
		{
			if (!QUEST_DONE)
			{
				menuItem.title = "Ask about Jobs";
				menuItem.type = "callback";
				menuItem.callback = "say_job";
				RegisterMenuItem(menuItem);
			}
			else
			{
				menuItem.title = "Ask About Urdauf";
				menuItem.type = "callback";
				menuItem.callback = "say_thanx";
				RegisterMenuItem(menuItem);
			}
		}

		if (!SAID_URD)
			return;
		if (!QUEST_DONE)
		{
			menuItem.title = "Ask About Urdauf";
			menuItem.type = "callback";
			menuItem.callback = "say_what";
			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Ask About Urdauf";
			menuItem.type = "callback";
			menuItem.callback = "say_thanx";
			RegisterMenuItem(menuItem);
		}
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(30);
		SetGold(50);
		SetName("Patron");
		// ov	180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 2);
		SetUniqueName("sumdale");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_what", "book", "happened", "urdauf");

		CatchSpeech("say_huh", "urdaf", "urdef", "urdaif", "urdof", "urdouf", "erdef", "erdaf", "erdauf", "erdif");

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

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		bool exitSub = false;
		// try to avoid the whole bar responding to the same statement
		if (talkingPlayer is null && RangeTo(ENT_LASTSPOKE) > 128.0f)
			exitSub = true;
		if (exitSub)
			return;

		OnSayRumour();
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
		OnChatNow("Thanks again for what you've done for my friend.", "3.0");
	}

	// say_hi_normal
	void OnSayHiNormal()
	{
		OnChatNow("Hail adventurer! My name is Sumdale.", "2.9");
		SetName("Sumdale");
		CallEventDelayed(0.0f, "3");
	}

	// say_hi2
	void OnSayHi2()
	{
		@URD_ID = FindByName("urduaf");
		CallExternal(URD_ID, "askbook");

		OnChatNow("You look like a kind fellow, maybe you can help me with something.", "3.9");
		CallEventDelayed(0.0f, "4");
	}

	// say_hi3
	void OnSayHi3()
	{
		OnChatNow("My friend Urdauf up there has become distraught over the loss of his book...", "6.9");
		CallEventDelayed(0.0f, "7");
	}

	// say_hi4
	void OnSayHi4()
	{
		OnChatNow("His father gave it to him as a family heirloom. It means so much to him.", "4.0");
		OnChatNow("He's been very quiet, barely eats, and talks of nothing but the book.", "3.0");
		SAID_URD = true;
	}

	// say_what
	void OnSayWhat()
	{
		if (QUEST_DONE)
			return;

		OnChatNow("I recently found him passed out in the field outside of town and brought him back here.", "2.9");
		CallEventDelayed(0.0f, "3");
	}

	// say_what2
	void OnSayWhat2()
	{
		OnChatNow("He's finally walking again but he won't talk to me much about what happened.", "2.9");
		CallEventDelayed(0.0f, "3");
	}

	// say_what3
	void OnSayWhat3()
	{
		OnChatNow("You'd best ask him, he's been distraught over the loss of some book.", "3.0");
	}

	// say_huh
	void OnSayHuh()
	{
		OnChatNow("Who are you talking about? You mean Urdauf? He's up there.", "2.0");
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
		OnChatNow("I saw Tristan read an odd note here at the tavern the other night. It seemed pretty torn up to me, and he looked confused.", "3.5");
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
		Sumdale_FirstThink();
		BaseChatArray_FirstThink();
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
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
