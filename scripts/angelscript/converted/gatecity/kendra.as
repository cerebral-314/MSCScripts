#pragma context server

// Converted from gatecity/kendra.script by msc_transpiler.
// Kendra, the prisoner's wife

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "gatecity/kendra"]
class Kendra : BaseChatScript
{
	// Variables (an unset .script variable reads as its own name)
	int QUEST_GOBLINPRISONER = 0;
	CBasePlayer@ QUESTER_LETTER = null;

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (QUEST_GOBLINPRISONER == 0 && Truthy(ItemExists(player, "item_letter_almund")))
		{
			@QUESTER_LETTER = player;
			menuItem.title = "Give Almund's Letter";
			menuItem.type = "payment";
			menuItem.data = "item_letter_almund";
			menuItem.callback = "say_ending";
			RegisterMenuItem(menuItem);
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		if (QUEST_GOBLINPRISONER == 0)
			SayText("...");

		if (QUEST_GOBLINPRISONER == 1)
			SayText("I haven't been out much recently.");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(30); // Start with 30 out of 30 max hit points
		SetGold(50);
		SetName("|Kendra");
		SetFieldOfView(120);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human2.mdl");
		SetInvincible(true);
		SetModelBody(0, 2);
		SetModelBody(1, 0);
		QUEST_GOBLINPRISONER = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_upset", "wrong", "upset", "sad");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");
		CatchSpeech("say_steambow", "sucks", "steam");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		OnSayUpset();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (QUEST_GOBLINPRISONER == 0)
			SayText("I'm too [upset] to talk right now.");

		if (QUEST_GOBLINPRISONER == 1)
			SayText("Thank you Adventurer, I couldn't be happier!");
	}

	// say_upset
	void OnSayUpset()
	{
		if (QUEST_GOBLINPRISONER == 0)
		{
			SayText("My husband has been missing for some time now.");
			CallEventDelayed(0.0f, "3");
		}
	}

	// say_upset2
	void OnSayUpset2()
	{
		SayText("He's a travelling merchant. I'm affraid something has happened to him.");
		CallEventDelayed(0.0f, "3");
	}

	// say_upset3
	void OnSayUpset3()
	{
		SayText("I wish there was some way to know that he is safe.");
	}

	// say_ending
	void OnSayEnding()
	{
		QUEST_GOBLINPRISONER = 1;
		SayText("This letter is from my husband...");
		CallEventDelayed(0.0f, "3");
	}

	// say_ending2
	void OnSayEnding2()
	{
		SayText("He's going to be coming home!");
		CallEventDelayed(0.0f, "3");
	}

	// say_reward
	void OnSayReward(CBasePlayer@ player = null)
	{
		SayText("Thank you Adventurer! Please take this gold!");
		Offer(QUESTER_LETTER, "gold", RandomInt(20, 30));
	}

	// say_steambow
	void OnSaySteambow()
	{
		SayText("You really think that yer going to get the Steam Crossbow that way?");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human2.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "say_ending") { OnSayEnding(); return true; }
		if (name == "say_ending2") { OnSayEnding2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_reward") { OnSayReward(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_steambow") { OnSaySteambow(); return true; }
		if (name == "say_upset") { OnSayUpset(); return true; }
		if (name == "say_upset2") { OnSayUpset2(); return true; }
		if (name == "say_upset3") { OnSayUpset3(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
