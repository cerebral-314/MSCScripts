#pragma context server

// Converted from edana/highpriest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "edana/highpriest"]
class Highpriest : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float ATTACK_RANGE = 100.0f;
	string ATTACK1_DAMAGE = "-1000";
	string ATTACK_PERCENTAGE = "100%";

	// unnamed block (timer)
	// Attack
	void Highpriest_Timer()
	{
		CallEventDelayed(0.3f, "Highpriest_Timer");

		SetMoveDest(ENT_LASTSEEN, 9999);
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(60);
		SetGold(0);
		SetName("High Priest");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false); // go roaming around
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		ATTACK_RANGE = 100.0f;
		ATTACK1_DAMAGE = "-1000";
		ATTACK_PERCENTAGE = "100%";

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_job", "job");
		CatchSpeech("say_job", "work");

		CatchSpeech("say_rumour", "rumours");
		CatchSpeech("say_rumour", "news");
		CatchSpeech("say_rumour", "happenings");
		CatchSpeech("say_rumour", "rumor");

		CatchSpeech("say_heal", "heal");
		CatchSpeech("say_heal", "regenerate");
		CatchSpeech("say_heal", "reconstitute");
		CatchSpeech("say_heal", "wounds");
		CatchSpeech("say_heal", "wounded");
		CatchSpeech("say_heal", "healing");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SetVolume(10);
		SayText("...");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SetVolume(10);
		SayText("It is the duty of each one of us to server Urdual with all of our heart.");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		SayText("Long ago, a fallen elf left the Temple of Balance to aid Torkalath and his orcs.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour2
	void OnSayRumour2()
	{
		SayText("That fool didn't know much of the orcs, and we begged him not to go.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour3
	void OnSayRumour3()
	{
		SayText("They tricked him into believeing they would let him help, but instead they killed him and ate his body.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour4
	void OnSayRumour4()
	{
		SayText("The Circle of Seven trapped his soul into his armor so they could use his rage on their berserkers.");
		CallEventDelayed(0.0f, "5");
	}

	// say_rumour5
	void OnSayRumour5()
	{
		SayText("I believe the elf's name was Geric.");
	}

	// say_heal
	// Healing
	void OnSayHeal()
	{
		SayText("Oh my, let me help you with that...");
		PlayAnim("once", "retina");
		CallEventDelayed(0.0f, "1");
	}

	// attack_1
	void OnAttack12()
	{
		// Healing Powers
		ApplyEffect(ENT_LASTSPOKE, "effects/effect_rejuv2", 0, 1000, self);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.title = "Ask to be Healed";
		menuItem.type = "callback";
		menuItem.callback = "say_heal";
		RegisterMenuItem(menuItem);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
		CallEventDelayed(0.3f, "Highpriest_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "say_heal") { OnSayHeal(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_rumour2") { OnSayRumour2(); return true; }
		if (name == "say_rumour3") { OnSayRumour3(); return true; }
		if (name == "say_rumour4") { OnSayRumour4(); return true; }
		if (name == "say_rumour5") { OnSayRumour5(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "Highpriest_Timer") { Highpriest_Timer(); return true; }
		return false;
	}
}
