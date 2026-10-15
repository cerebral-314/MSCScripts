#pragma context server

// Converted from gatecity/miner.script by msc_transpiler.
// A dwarven miner
// Spawn properties

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "gatecity/miner"]
class Miner : BaseChatScript
{
	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("A miner friend of mine says undead creatures lie below the city.");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(30); // Start with 30 out of 30 max hit points
		SetGold(50);
		SetName("|Roderick the Miner");
		SetFieldOfView(120);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 0); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 1); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetInvincible(true);

		SetModelBody(1, 8);
		SetModelBody(2, 0);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "gold", "money");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");
		CatchSpeech("say_undermountains", "undermountain", "undermountains", "under", "mountain", "mountains", "underkeep", "keep");
	}

	// say_hi
	// /////////////////////////////////////////////////////////
	// Greeting players
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Hail, Adventurer. I hope the [Underkeep] would open soon.");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("You too? I need to find work as well.");
	}

	// say_undermountains
	void OnSayUndermountains()
	{
		SayText("The Underkeep goes through the deepest parts of the mountains.");
		CallEventDelayed(0.0f, "3");
	}

	// say_undermountains2
	void OnSayUndermountains2()
	{
		SayText("Rare gems and metals can be found down there.");
		CallEventDelayed(0.0f, "3");
	}

	// say_undermountains3
	void OnSayUndermountains3()
	{
		SayText("It's so dangerous there now, so the mayor has closed off all access.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_undermountains") { OnSayUndermountains(); return true; }
		if (name == "say_undermountains2") { OnSayUndermountains2(); return true; }
		if (name == "say_undermountains3") { OnSayUndermountains3(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
