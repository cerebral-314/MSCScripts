#pragma context server

// Converted from gatecity/priest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_chat.as"
#include "converted/help/first_npc.as"

[script "gatecity/priest"]
class GatecityPriest : BaseChatScript, FirstNpc
{
	// Constants
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetGold(0);
		SetName("Priest of Urdual");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		CANCHAT = 1;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_theobold", "theobold");
		CatchSpeech("say_hall", "Hall", "Balance");
		CatchSpeech("say_job", "job", "work", "money", "gold");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SetVolume(10);
		SayText("Do not bother me right now. Speak with Theobold.");
	}

	// say_theobold
	void OnSayTheobold()
	{
		SayText("Theobold is in the Hall of Balance, in the deepest part of the temple.");
	}

	// say_hall
	void OnSayHall()
	{
		SayText("The Hall of Balance is where light and dark meet. Now please, let me meditate.");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("Work? the Temple of Balance has no need for you at the moment.");
		CallEventDelayed(0.0f, "3");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		SayText("If you need a job, try looking in the city.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "say_hall") { OnSayHall(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_theobold") { OnSayTheobold(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return FirstNpc_DispatchEvent(name, params)
			|| BaseChatScript::DispatchEvent(name, params);
	}
}
