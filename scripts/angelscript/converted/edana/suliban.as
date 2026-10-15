#pragma context server

// Converted from edana/suliban.script by msc_transpiler.
// Suliban, the mayor's courier

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "edana/suliban"]
class Suliban : BaseChatScript
{
	// Constants
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	int EVIDENCE_FOUND = 0;
	int BRIBED = 0;
	bool CAN_BRIBE = false;
	string ATTACK1_DAMAGE = "30";
	float ATTACK_RANGE = 0.0f;

	// say_mayor
	void Suliban_OnSayMayor()
	{
		if (BRIBED != 0)
			return;

		SayText("Old fellow Erkold? What ye need from him? Did [Edrin] send you?");
		PlayAnim("once", "talkright");
	}

	// say_mayor
	void Suliban_OnSayMayor_2()
	{
		if (BRIBED != 1)
			return;

		SayText("I already told you what I know.");
		PlayAnim("once", "talkright");
	}

	// unnamed block (timer)
	void Suliban_Timer()
	{
		CallEventDelayed(20.0f, "Suliban_Timer");

		if (BRIBED != 0)
			return;

		SayText("Stop pestering me. I've got no time for the likes of you.");
	}

	// unnamed block (first think)
	void Suliban_FirstThink()
	{
		SayText("Try not to kill him, will you? Would rather spare the bloodshed in town. He is human afterall. Try talking him out of it instead. ... That's all I know...");
		PlayAnim("once", "talkright");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		menuItem.title = "Say Hello";
		menuItem.type = "say";

		int say = RandomInt(1, 4);
		if (say == 1)
			menuItem.data = "Hello";
		else if (say == 2)
			menuItem.data = "Hi";
		else if (say == 3)
			menuItem.data = "Hail";
		else if (say == 4)
			menuItem.data = "Greetings!";
		RegisterMenuItem(menuItem);

		if ((CAN_BRIBE ? 1 : 0) == 1)
		{
			menuItem.title = "Bribe (15g)";
			menuItem.type = "payment";
			menuItem.data = "gold:15";
			menuItem.callback = "bribe";
			menuItem.cb_failed = "bribe_failed";
			RegisterMenuItem(menuItem);
		}
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(3000);
		SetGold(340);
		SetName("Warrior");
		// ov 300
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/guard1.mdl");
		SetInvincible(true);

		EVIDENCE_FOUND = 0;
		BRIBED = 0;
		CAN_BRIBE = false;

		ATTACK1_DAMAGE = "30";
		ATTACK_RANGE = 128.0f;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_mayor", "mayor");

		CatchSpeech("say_edrin", "edrin");

		CatchSpeech("say_job", "job", "work", "money", "gold");

		CatchSpeech("say_name", "name");
	}

	// say_name
	void OnSayName()
	{
		SetName("Suliban");
		SayText("I guess I can let you know now; my name is Suliban.");
		PlayAnim("once", "talkright");
	}

	// say_hi
	// //// Greets ///////
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BRIBED != 0)
			return;

		SetVolume(7);
		Say("edrin1[34]");
		SayText("Yes? What do you want?");
	}

	// say_mayor
	void OnSayMayor()
	{
		Suliban_OnSayMayor();
		Suliban_OnSayMayor_2();
	}

	// say_edrin
	void OnSayEdrin()
	{
		SayText("I don't speak with just anyone, nor do I speak for free. If you can offer me enough, I'll tell you everything.");
		CAN_BRIBE = true;
	}

	// bribe
	// /////////// Bribe /////////////
	void OnBribe()
	{
		ReceiveOffer("accept");
		SayText("Right... Here's what you need to do - The mayor is guarded by a hot-tempered guard. You must steer off him. You might need a friend to help you stalk the guard, while one of you goes inside to speak with Erkold.");
		PlayAnim("once", "talkleft");
		CallEventDelayed(0.0f, "7");
		UseTrigger("mayorsdoor");

		BRIBED = 1;
	}

	// bribe_failed
	void OnBribeFailed()
	{
		ReceiveOffer("reject");
		SayText("What are you trying? Off with ye.");
		PlayAnim("once", "no");
	}

	// robbed
	// -- Attack thieves --
	void OnRobbed()
	{
		SayText("Thief!");
		PlayAnim("once", "beatdoor");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSTOLE, ATTACK_RANGE, ATTACK1_DAMAGE, "ATTACK_PERCENTAGE");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I got nothing for you.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		Precache("npc/edrin1.wav");
		CallEventDelayed(20.0f, "Suliban_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
		Suliban_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "bribe") { OnBribe(); return true; }
		if (name == "bribe_failed") { OnBribeFailed(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "robbed") { OnRobbed(); return true; }
		if (name == "say_edrin") { OnSayEdrin(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_name") { OnSayName(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "Suliban_Timer") { Suliban_Timer(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
