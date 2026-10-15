#pragma context server

// Converted from gatecity/masterp.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/help/first_npc.as"

[script "gatecity/masterp"]
class GatecityMasterp : BaseChatScript, FirstNpc
{
	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;
	bool TEMPLE = false;

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("However, there are rumors of a [broken temple] to the north");
		TEMPLE = true;
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetGold(0);
		SetName("Theobold");
		SetFieldOfView(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		CANCHAT = 1;
		TEMPLE = false;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_temple", "temple", "broken");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");
	}

	// say_hi
	// Story reference: If the power of good or evil someday is too strong, or if the
	// temple would not be completly symmetric, it will crack in two in a short time.
	// Many of these "cracked" tempels are scattered across the land, and most of them are filled with
	// monsters of the side that was superior to the other.
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Hail, Adventurer. What can the temple do for you today?");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("A job? I am afraid the temple has no specific jobs for you.");

		CallEventDelayed(0.0f, "3");
	}

	// say_temple
	void OnSayTemple()
	{
		if (TEMPLE)
		{
			SayText("Yes, if good or evil becomes too strong in the area the temple is in, it will eventually crack in two");
			CallEventDelayed(0.0f, "3");
		}
	}

	// say_temple2
	void OnSayTemple2()
	{
		SayText("There are many of these cracked temples scattered accross the land, and are usually filled with");
		SayText("monsters seeking to create yet more unbalance.");
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
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_temple") { OnSayTemple(); return true; }
		if (name == "say_temple2") { OnSayTemple2(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return FirstNpc_DispatchEvent(name, params)
			|| BaseChatScript::DispatchEvent(name, params);
	}
}
