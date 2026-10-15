#pragma context server

// Converted from deralia/barguy.script by msc_transpiler.
// Bar Patron

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "deralia/barguy"]
class Barguy : BaseChatScript
{
	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;
	int HAT_QUEST = 0;
	float ATTACK_RANGE = 90.0f;
	string ATTACK1_DAMAGE = "5";
	string ATTACK_PERCENTAGE = "60%";
	string CURRENT_THIEF = "\x81PNULL\x81P";
	string SOUND_IDLE1 = "voices/human/male_idle4.wav";
	string SOUND_IDLE2 = "voices/human/male_idle5.wav";
	string SOUND_IDLE3 = "voices/human/male_idle6.wav";
	int REQ_QUEST_NOTDONE = 0;
	bool SAID_HELP = false;
	string QUEST_WINNER = "QUEST_WINNER";

	// game_spawn
	void Barguy_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(25);
		SetGold(30);
		SetName("Mosor");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, 2);

		// basechat
		CANCHAT = 1;

		HAT_QUEST = 0;
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "60%";
		CURRENT_THIEF = "\x81PNULL\x81P"; // A player can't pick this name

		SOUND_IDLE1 = "voices/human/male_idle4.wav";
		SOUND_IDLE2 = "voices/human/male_idle5.wav";
		SOUND_IDLE3 = "voices/human/male_idle6.wav";

		REQ_QUEST_NOTDONE = 1;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_apple", "apple");

		CatchSpeech("respond_no", "no");

		CatchSpeech("say_job", "help", "yes", "sure", "try", "give", "have", "buy");

		CatchSpeech("say_rumor", "rumours", "news", "happenings", "rumour", "rumor");
	}

	// unnamed block (timer)
	void Barguy_Timer()
	{
		CallEventDelayed(35.0f, "Barguy_Timer");
		PlayRandomSound(2, 5, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// unnamed block (timer)
	void Barguy_Timer2()
	{
		CallEventDelayed(60.0f, "Barguy_Timer2");
		SayText("Give me another pint!");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		Barguy_OnGameSpawn(playerRace, playerGender);
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (REQ_QUEST_NOTDONE == 0)
			return;
		if (Truthy(ItemExists(player, "item_hat")))
		{
			menuItem.title = "Return hat";
			menuItem.type = "payment";
			menuItem.data = "item_hat";
			menuItem.callback = "give_hat";
			RegisterMenuItem(menuItem);
		}

		if (HAT_QUEST != 0)
		{
			menuItem.title = "No";
			menuItem.type = "callback";
			menuItem.callback = "respond_no";
			RegisterMenuItem(menuItem);
		}
		else if (SAID_HELP)
		{
			menuItem.title = "Help";
			menuItem.type = "callback";
			menuItem.callback = "say_job";
			RegisterMenuItem(menuItem);
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("Gossip?");
		if (REQ_QUEST_NOTDONE != 0)
			CallEventDelayed(1.0f, "helpeh");
		else
			CallEventDelayed(1.0f, "say_a_really_important");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("What do you 'ant?");
	}

	// helpeh
	void OnHelpeh()
	{
		if (SAID_HELP)
			return;
		SayText("Bah, away with you, unless you can [help] me!");
		SAID_HELP = true;
	}

	// respond_no
	void OnRespondNo()
	{
		if (!SAID_HELP)
			return;

		SayText("Then begone!");
		SAID_HELP = false;
		HAT_QUEST = 0;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		// if SAID_HELP equals 1
		if (HAT_QUEST != 0)
			return;

		PlayAnim("once", "converse1");
		SayText("Well, a few days ago I came home after a night like this, quite... happy.");
		CallEventDelayed(0.0f, "2");
	}

	// say_thief2
	void OnSayThief2()
	{
		SayText("I walked through the door into my house only to find that everything was missing!");
		CallEventDelayed(0.0f, "2");
	}

	// say_thief3
	void OnSayThief3()
	{
		SayText("Me gold, me weapons, even me hat! I must have me hat! I don't know what to do!");
		CallEventDelayed(0.0f, "2");
	}

	// say_thief4
	void OnSayThief4()
	{
		PlayAnim("once", "pondering");
		SayText("Maybe you can get me hat back for me! I'll reward ye! Well!");
		HAT_QUEST = 1;
	}

	// say_a_really_important
	// Rumours
	void OnSayAReallyImportant()
	{
		PlayAnim("once", "pondering");
		SayText("No rumors around here... only truths."); // oops, not that important.
	}

	// give_hat
	void OnGiveHat(CBasePlayer@ winner = null)
	{
		QUEST_WINNER = EntityId(winner);
		ReceiveOffer("accept");
		SayText("MY HAT!");
		CallEventDelayed(0.0f, "5");
	}

	// hat_2
	void OnHat2()
	{
		SayText("Thank you so much! Heres your reward!");
		Offer(QUEST_WINNER, "gold", 25);
		REQ_QUEST_NOTDONE = 0;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(35.0f, "Barguy_Timer");
		CallEventDelayed(60.0f, "Barguy_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_hat") { OnGiveHat(PlayerParam(params, 0)); return true; }
		if (name == "hat_2") { OnHat2(); return true; }
		if (name == "helpeh") { OnHelpeh(); return true; }
		if (name == "respond_no") { OnRespondNo(); return true; }
		if (name == "say_a_really_important") { OnSayAReallyImportant(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_thief2") { OnSayThief2(); return true; }
		if (name == "say_thief3") { OnSayThief3(); return true; }
		if (name == "say_thief4") { OnSayThief4(); return true; }
		if (name == "Barguy_Timer") { Barguy_Timer(); return true; }
		if (name == "Barguy_Timer2") { Barguy_Timer2(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
