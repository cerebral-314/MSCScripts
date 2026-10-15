#pragma context server

// Converted from edana/priest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/help/first_npc.as"

[script "edana/priest"]
class EdanaPriest : FirstNpcScript
{
	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;

	// spawn
	void OnSpawn()
	{
		SetHealth(40);
		SetGold(0);
		SetName("Priest of Urdual");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		CANCHAT = 1;
		OnCreatemystore();

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_sembelbin", "sembelbin");

		CatchSpeech("say_hall", "Hall");
		CatchSpeech("say_hall", "Balance");

		CatchSpeech("say_job", "job");
		CatchSpeech("say_job", "work");
		CatchSpeech("say_job", "money");
		CatchSpeech("say_job", "gold");

		CatchSpeech("say_rumour", "rumours");
		CatchSpeech("say_rumour", "news");
		CatchSpeech("say_rumour", "happenings");
		CatchSpeech("say_rumour", "rumor");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SetVolume(10);
		SayText("Do not bother me right now. Speak with Sembelbin.");
	}

	// say_sembelbin
	void OnSaySembelbin()
	{
		SayText("Sembelbin is in the Hall of Balance, in the deepest part of the temple.");
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
		CallEventDelayed(0.0f, "2");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		SayText("If you need a job, try the village of Edana.");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		SayText("The temple is very saddened right now... We recently lost a fine elf blademaster to the orcs.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("Lord Vecilus was his name, and he had his armor forged at Eswen Sylen. He insited on taking the orcs alone, to avenge his brother, Sir Geric.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour3
	void OnSayRumour3()
	{
		SayText("His pride was his death, and his armor lost.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour4
	void OnSayRumour4()
	{
		SayText("We would ask you to get back that armor, but don't you go alone like Lord Vecilus.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour5
	void OnSayRumour5()
	{
		SayText("I suppose you can keep the armor to yourself when you find it, seeing we don't have any temple fighters left.");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnCreatemystore() {} // createmystore

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
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "say_rumour3") { OnSayRumour3(); return true; }
		if (name == "say_rumour4") { OnSayRumour4(); return true; }
		if (name == "say_rumour5") { OnSayRumour5(); return true; }
		if (name == "say_sembelbin") { OnSaySembelbin(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return FirstNpcScript::DispatchEvent(name, params);
	}
}
