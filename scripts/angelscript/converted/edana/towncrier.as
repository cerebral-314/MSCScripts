#pragma context server

// Converted from edana/towncrier.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "edana/towncrier"]
class Towncrier : BaseChatScript
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	int EVIDENCE_FOUND = 0;
	bool TALKING = true;

	// unnamed block (timer)
	void Towncrier_Timer()
	{
		CallEventDelayed(10.0f, "Towncrier_Timer");
		if (TALKING)
			return;

		SetSayTextRange(1024);
		SayText("News! Path to Gate City open! Orcish attacks on Helena nearly over!");
		SetSayTextRange("default");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetName("Godfrey the Town Crier");
		// ov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(true);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 2);

		EVIDENCE_FOUND = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_adventure", "adventure", "quest", "journey");
		CatchSpeech("say_rumour", "rumours", "news", "happenings", "rumor");
		CatchSpeech("say_mayor", "mayor");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		TALKING = true;
		SayText("Hello! What can I help you with? Looking for [adventure]? Or perhaps you'd like to hear about the [news] that goes around?");
		if (GetProp(ENT_LASTSPOKE, "player") != "1")
			return;
		SetMoveDest(9999, ENT_LASTSPOKE);
		SetRoam(false);
		CallEventDelayed(0.0f, "10");
	}

	// say_adventure
	// Adventure
	void OnSayAdventure()
	{
		SayText("Everyone new goes to the old sewers. It's not in use anymore, at least not as much, but the guards put items and money in");
		SayText("a chest they keep hidden somewhere in there.");
		CallEventDelayed(0.0f, "4");
	}

	// say_adventure2
	void OnSayAdventure2()
	{
		SayText("Indeed. It has encouraged many to join the guards. If fortune is with you, you might get their special price... Good luck!");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("Have you heard? They fought back the orcs in Helena, and they're not just rebuilding it. Looks like it's becoming a market place, if you ask me.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("They've set up several shops, and the inn is in business again. But I'm not so sure if it'll do any good business.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour3
	void OnSayRumour3()
	{
		SayText("I have been hearing reports of repeated attacks. Things could get quite messy if you go out there.");
	}

	// say_mayor
	void OnSayMayor()
	{
		if (EVIDENCE_FOUND != 1)
			return;

		SayText("Apparently, the mayor has been discovered to be working with the orcs! Surprises all around!");
	}

	// worldevent_evidence_found
	void OnWorldeventEvidenceFound()
	{
		EVIDENCE_FOUND = 1;
	}

	// resume
	void OnResume()
	{
		TALKING = false;
		SetRoam(true);
	}

	// worldevent_time
	void OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0)
	{
		if (hour == 24.00f)
			SayText("'tis midnight and all is well!");
		if (hour == 1.00f)
			SayText("'tis one in the morn and all is well!");
		if (hour == 2.00f)
			SayText("'tis two in the morn and all is well!");
		if (hour == 3.00f)
			SayText("'tis three in the morn and all is well!");
		if (hour == 4.00f)
			SayText("'tis four in the morn and all is well!");
		if (hour == 5.00f)
			SayText("'tis five in the morn and all is well!");
		if (hour == 6.00f)
			SayText("'tis six in the morn and all is well!");
		if (hour == 7.00f)
			SayText("'tis seven in the morn and all is well!");
		if (hour == 8.00f)
			SayText("'tis eight in the morn and all is well!");
		if (hour == 9.00f)
			SayText("'tis nine in the morn and all is well!");
		if (hour == 10.00f)
			SayText("'tis ten in the morn and all is well!");
		if (hour == 11.00f)
			SayText("'tis eleven in the morn and all is well!");
		if (hour == 12.00f)
			SayText("'tis noon and all is well!");
		if (hour == 13.00f)
			SayText("'tis one in the eve and all is well!");
		if (hour == 14.00f)
			SayText("'tis two in the eve and all is well!");
		if (hour == 15.00f)
			SayText("'tis three in the eve and all is well!");
		if (hour == 16.00f)
			SayText("'tis four in the eve and all is well!");
		if (hour == 17.00f)
			SayText("'tis five in the eve and all is well!");
		if (hour == 18.00f)
			SayText("'tis six in the eve and all is well!");
		if (hour == 19.00f)
			SayText("'tis seven in the eve and all is well!");
		if (hour == 20.00f)
			SayText("'tis eight in the eve and all is well!");
		if (hour == 21.00f)
			SayText("'tis nine in the eve and all is well!");
		if (hour == 22.00f)
			SayText("'tis ten in the eve and all is well!");
		if (hour == 23.00f)
			SayText("'tis eleven in the eve and all is well!");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(10.0f, "Towncrier_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "resume") { OnResume(); return true; }
		if (name == "say_adventure") { OnSayAdventure(); return true; }
		if (name == "say_adventure2") { OnSayAdventure2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "say_rumour3") { OnSayRumour3(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "worldevent_evidence_found") { OnWorldeventEvidenceFound(); return true; }
		if (name == "worldevent_time") { OnWorldeventTime(Float(Param(params, 0)), Float(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "Towncrier_Timer") { Towncrier_Timer(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
