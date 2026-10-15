#pragma context server

// Converted from edana/msqguard.script by msc_transpiler.
// Merchant's square guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_xmass.as"

[script "edana/msqguard"]
class Msqguard : BaseChatScript, BaseXmass
{
	// Variables (an unset .script variable reads as its own name)
	bool NO_TALK = false;
	int QUEST_1 = 0;
	string SOUND_HAIL = "voices/human/male_hail_guard.wav";
	string SOUND_IDLE2 = "voices/human/male_idle7.wav";
	string SOUND_IDLE3 = "voices/human/male_idle8.wav";
	int THIEF_QUEST = 0;
	string QUEST_WINNER = "QUEST_WINNER";
	bool THIEF_QUEST_DONE = false;
	bool DID_TAUNT = false;

	// say_mayor
	void Msqguard_OnSayMayor()
	{
		if (QUEST_1 != 2)
			return;

		SayText("Thanks for helping us out.");
		PlayAnim("once", "yes");
	}

	// say_mayor
	void Msqguard_OnSayMayor_2()
	{
		if (QUEST_1 != 0)
			return;

		SayText("I know that old man is up to something...");
		PlayAnim("once", "no");
		CallEventDelayed(0.0f, "5");
	}

	// unnamed block (timer)
	// ////////////////////////////////////////////////
	void Msqguard_Timer()
	{
		CallEventDelayed(10.0f, "Msqguard_Timer");
		if ((NO_TALK ? 1 : 0) != 0)
			return;
		DID_TAUNT = true;
		CallEventDelayed(120.0f, "taunt_reset");
		SayText("Why are you sneaking around here? Go around to the entrance if you wish to enter the merchant's square.");
	}

	// say_thief
	// Thief Quest, part 2
	void Msqguard_OnSayThief()
	{
		if (THIEF_QUEST != 2)
			return;
		THIEF_QUEST = 3;
		Say("suspicious");
		SayText("If you see anything suspicious around here, you let me know.");
	}

	// say_thief
	// After telling him about thieves one second time
	void Msqguard_OnSayThief_2()
	{
		if (THIEF_QUEST != 3)
			return;
		THIEF_QUEST = 6;
		SayText("If you see any thieves, try bribing them for information, or give threats that I will lock them up for good.");
		CallEventDelayed(0.0f, "4");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		// dbg thief set THIEF_QUEST
		if (Truthy(ItemExists(player, "item_letter_mayor")))
		{
			menuItem.title = "Present Evidence";
			menuItem.type = "payment";
			menuItem.data = "item_letter_mayor";
			menuItem.callback = "got_letter";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "item_thiefmap")))
		{
			menuItem.title = "Give Thief Map";
			menuItem.type = "payment";
			menuItem.data = "item_thiefmap";
			menuItem.callback = "got_theif_map";
			RegisterMenuItem(menuItem);
		}

		if (THIEF_QUEST == 2)
		{
			menuItem.title = "Ask about thieves";
			menuItem.type = "callback";
			menuItem.callback = "say_thief";
			RegisterMenuItem(menuItem);
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayMayor();
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(100); // Guards are strong
		SetGold(0);
		SetName("Tristan");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/guard1.mdl");
		SetInvincible(true);
		NO_TALK = false;
		QUEST_1 = 0;
		THIEF_QUEST = 2;

		SOUND_HAIL = "voices/human/male_hail_guard.wav";
		SOUND_IDLE2 = "voices/human/male_idle7.wav";
		SOUND_IDLE3 = "voices/human/male_idle8.wav";

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_mayor", "mayor");

		CatchSpeech("say_job", "job");
		CatchSpeech("say_job", "work");
		CatchSpeech("say_job", "money");
		CatchSpeech("say_job", "gold");

		CatchSpeech("say_thief", "thief");
		CatchSpeech("say_thief", "thieves");
		CatchSpeech("say_thief", "bandit");
		CatchSpeech("say_thief", "cutpurse");
		CatchSpeech("say_thief", "poacher");

		CallEventDelayed(0.0f, "5");
	}

	// idle
	// Idling
	void OnIdle()
	{
		CallEventDelayed(35.0f, "idle");
		SetVolume(2);
		PlayRandomSound(2, 2, SOUND_IDLE2, SOUND_IDLE3);
	}

	// say_hi
	// //// Greets ///////
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlaySound(2, 7, SOUND_HAIL);
		SayText("I'm on duty, but go ahead.");
	}

	// say_mayor
	void OnSayMayor()
	{
		Msqguard_OnSayMayor();
		Msqguard_OnSayMayor_2();
	}

	// say_mayor2
	void OnSayMayor2()
	{
		SayText("Fetch me evidence that he is a traitor, and I will give you a little something.");
		PlayAnim("once", "no");
	}

	// got_letter
	void OnGotLetter(CBasePlayer@ player = null)
	{
		QUEST_WINNER = EntityId(player);
		ReceiveOffer("accept");
		SayText("Thank you! Thank you very much. At last we can get that scumbag out of the way.");
		UseTrigger("evidence_found");
		QUEST_1 = 2;
		CallEventDelayed(0.0f, "6");
	}

	// got_theif_map
	void OnGotTheifMap(CBasePlayer@ player = null)
	{
		QUEST_WINNER = EntityId(player);

		THIEF_QUEST_DONE = true;

		ReceiveOffer("accept");
		PlayAnim("once", "return_needle");
		SayText("Ah, what's this? A map of the thieves whereabouts? You have done well, my friend.");
		CallEventDelayed(0.0f, "4");
	}

	// recvletter_2
	void OnRecvletter2()
	{
		SayText("Here, I found it on a dead body. Supposedly it's answers to some riddles. Perhaps you should keep it safe. Might be valueable to you some day.");
		Offer(QUEST_WINNER, "item_riddleanswers");
		UseTrigger("evidence_found");
	}

	// taunt_reset
	void OnTauntReset()
	{
		DID_TAUNT = false;
	}

	// say_nothing
	void OnSayNothing()
	{
		NO_TALK = true;
		CallEventDelayed(0.0f, "9");
	}

	// say_something
	void OnSaySomething()
	{
		NO_TALK = false;
	}

	// game_recvoffer_gold
	// /////////////////////////////////////////////////
	void OnGameRecvofferGold()
	{
		ReceiveOffer("reject");
		SayText("A bribe?? I should expect more upstanding behavior than that, citizen.");
		PlayAnim("once", "no");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Hmmmmm... I just recently got hired and I don't think they need another guard.");
		PlayAnim("once", "shrug");
	}

	// say_thief
	void OnSayThief()
	{
		Msqguard_OnSayThief();
		Msqguard_OnSayThief_2();
	}

	// say_thief2
	void OnSayThief2()
	{
		SayText("Aye, I will have them thieves locked up, if not killed should I get my hands on them.");
	}

	// say_thiefloc
	// After getting map
	void OnSayThiefloc()
	{
		SayText("Hmmmm... this map shows bandits in a few of the local areas, one being in the Thornlands.");
		CallEventDelayed(0.0f, "4");
	}

	// say_thiefloc2
	void OnSayThiefloc2()
	{
		SayText("There will probably be thieves around the area. If not, look in the caves near the road to Edana or Helena.");
		CallEventDelayed(0.0f, "4");
	}

	// say_thiefloc3
	void OnSayThiefloc3()
	{
		SayText("Bring me proof that you've killed them and I'll reward you, if killing them is not reward enough.");
		CallEventDelayed(0.0f, "4");
	}

	// say_thiefloc4
	void OnSayThiefloc4()
	{
		SetVolume(8);
		Say("guardwarn");
		string questWinnerName = NameOf(QUEST_WINNER) + ",";
		SayText("Here's some incentive. Be wary, " + questWinnerName + " it is dangerous outside.");
		Offer(QUEST_WINNER, "gold", 30);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		Precache("npc/suspicious.wav");
		Precache("npc/guardwarn.wav");
		CallEventDelayed(10.0f, "Msqguard_Timer");
		CallEventDelayed(35.0f, "idle");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "got_letter") { OnGotLetter(PlayerParam(params, 0)); return true; }
		if (name == "got_theif_map") { OnGotTheifMap(PlayerParam(params, 0)); return true; }
		if (name == "idle") { OnIdle(); return true; }
		if (name == "recvletter_2") { OnRecvletter2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_mayor2") { OnSayMayor2(); return true; }
		if (name == "say_nothing") { OnSayNothing(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_something") { OnSaySomething(); return true; }
		if (name == "say_thief") { OnSayThief(); return true; }
		if (name == "say_thief2") { OnSayThief2(); return true; }
		if (name == "say_thiefloc") { OnSayThiefloc(); return true; }
		if (name == "say_thiefloc2") { OnSayThiefloc2(); return true; }
		if (name == "say_thiefloc3") { OnSayThiefloc3(); return true; }
		if (name == "say_thiefloc4") { OnSayThiefloc4(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "taunt_reset") { OnTauntReset(); return true; }
		if (name == "Msqguard_Timer") { Msqguard_Timer(); return true; }
		return BaseXmass_DispatchEvent(name, params)
			|| BaseChatScript::DispatchEvent(name, params);
	}
}
