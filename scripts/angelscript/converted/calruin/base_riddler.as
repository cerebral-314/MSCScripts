#pragma context server

// Converted from calruin/base_riddler.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseRiddler
{
	// Variables (an unset .script variable reads as its own name)
	bool RIDDLE_ANSWERED = false;
	bool NTRODUCED = false;
	bool INTRODUCED = false;
	CBaseEntity@ VICTIM = null;

	// unnamed block (first think)
	void BaseRiddler_FirstThink()
	{
		RIDDLE_ANSWERED = false;
		NTRODUCED = false;
	}

	// game_spawn
	void BaseRiddler_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetWidth(32);
		SetHeight(72);
		SetRace("undead");
		SetName("Riddlemaster");
		SetRoam(false);
		SetModel("monsters/riddler.mdl");
		SetInvincible(true);
		SetNoPush(true);

		CatchSpeech("say_riddle1", "hi", "hail", "greet", "hello");
		CatchSpeech("say_riddle", "yes", "aye", "yep", "yar", "sure", "why not?");

		CatchSpeech("say_answer", RIDDLE_ANSWER);

		SetSolid("none");
	}

	// unnamed block (timer)
	// Introducing riddle
	void BaseRiddler_Timer()
	{
		CallEventDelayed(1.0f, "BaseRiddler_Timer");

		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		CallEventDelayed(2.0f, "say_riddle1");
	}

	// say_riddle1
	void BaseRiddler_OnSayRiddle1()
	{
		if (INTRODUCED)
			return;
		INTRODUCED = true;
		SayText("Halt! You may not proceed until you answer a riddle!");
		CallEventDelayed(4.0f, "say_riddle2");
	}

	// say_riddle2
	void BaseRiddler_OnSayRiddle2()
	{
		SayText("Take my advice and leave, for if you fail to answer, you will die!");
		CallEventDelayed(4.0f, "say_riddle3");
	}

	// say_riddle3
	void BaseRiddler_OnSayRiddle3()
	{
		SayText("Despite the risk, are you willing to try?");
	}

	// say_riddle
	// Say the riddle after the player says yes
	void BaseRiddler_OnSayRiddle()
	{
		if (!INTRODUCED)
			return;
		if (RIDDLE_ANSWERED)
			return;

		@VICTIM = EntityOf(ENT_LASTSPOKE);

		OnRiddleQuestion(); // on monster

		CallEventDelayed(30.0f, "kill_player");
	}

	// say_answer
	// If the player answered correctly
	void BaseRiddler_OnSayAnswer()
	{
		RIDDLE_ANSWERED = true;

		OnRiddleCorrect();

		CallEventDelayed(2.0f, "death");
	}

	// death
	void BaseRiddler_OnDeath()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// kill_player
	// If not...
	void BaseRiddler_OnKillPlayer()
	{
		if (RIDDLE_ANSWERED)
			return;
		Vector3 myTargetPos = OriginOf(VICTIM) + Vector3(0, 0, 16);

		SayText(FAILED_MSG);

		string sky = Text(myTargetPos);
		sky = Text(Vec(sky) + Vector3(0, 0, 4096));
		PlaySound3D("weather/Storm_exclamation.wav", 10, myTargetPos);
		ClientEvent("new", "all_in_sight", "effects/sfx_lightning", myTargetPos, sky, 1, 1);

		DoDamage(VICTIM, "direct", 10000, "100%", ENT_ME);

		CallEventDelayed(5.0f, "restart");
	}

	// restart
	void BaseRiddler_OnRestart()
	{
		INTRODUCED = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseRiddler_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnSayRiddle1() { BaseRiddler_OnSayRiddle1(); } // say_riddle1
	void OnSayRiddle2() { BaseRiddler_OnSayRiddle2(); } // say_riddle2
	void OnSayRiddle3() { BaseRiddler_OnSayRiddle3(); } // say_riddle3
	void OnSayRiddle() { BaseRiddler_OnSayRiddle(); } // say_riddle
	void OnSayAnswer() { BaseRiddler_OnSayAnswer(); } // say_answer
	void OnDeath() { BaseRiddler_OnDeath(); } // death
	void OnKillPlayer() { BaseRiddler_OnKillPlayer(); } // kill_player
	void OnRestart() { BaseRiddler_OnRestart(); } // restart
	void OnRiddleCorrect() {} // riddle_correct
	void OnRiddleQuestion() {} // riddle_question

	// This file's events and timers by their .script names
	bool BaseRiddler_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "death") { OnDeath(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "kill_player") { OnKillPlayer(); return true; }
		if (name == "restart") { OnRestart(); return true; }
		if (name == "say_answer") { OnSayAnswer(); return true; }
		if (name == "say_riddle") { OnSayRiddle(); return true; }
		if (name == "say_riddle1") { OnSayRiddle1(); return true; }
		if (name == "say_riddle2") { OnSayRiddle2(); return true; }
		if (name == "say_riddle3") { OnSayRiddle3(); return true; }
		if (name == "BaseRiddler_Timer") { BaseRiddler_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "calruin/base_riddler"]
shared class BaseRiddlerScript : ScriptEntity, BaseRiddler
{
	// Variables every script that includes this file declares
	string FAILED_MSG = "FAILED_MSG";
	string RIDDLE_ANSWER = "RIDDLE_ANSWER";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/riddler.mdl");
		CallEventDelayed(1.0f, "BaseRiddler_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseRiddler_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseRiddler_DispatchEvent(name, params);
	}
}
