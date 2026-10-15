#pragma context server

// Converted from edana/Hoguld.script by msc_transpiler.
// Hoguld in Edana

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_xmass.as"

[script "edana/Hoguld"]
class Hoguld : BaseNpcScript, BaseChat, BaseXmass
{
	// Constants
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	int ASKED = 0;
	bool ACCEPTED = false;

	// unnamed block (timer)
	void Hoguld_Timer()
	{
		CallEventDelayed(30.0f, "Hoguld_Timer");
		if ((ACCEPTED ? 1 : 0) == 1)
			return;
		if (ASKED == 1)
			return;
		if (!Truthy(LegacyFunction("cansee", "ally", 180)))
			return;

		SetMoveDest(ENT_LASTSEEN, 128);
		SayText("Is anybody going to Deralia soon?");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		// ov		120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Hoguld");
		SetRoam(true);
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetMoveAnim("walk");

		CatchSpeech("say_hi", "hi", "hail", "hello", "greet");
		CatchSpeech("saY_job", "yes", "sure", "why not?", "ok", "yea");
		CatchSpeech("say_no", "no", "noway", "never");

		OnRandomspawn();

		ASKED = 0;
		ACCEPTED = false;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if ((ACCEPTED ? 1 : 0) == 1)
			return;
		if (ASKED == 1)
			return;
		SayText("Hello there! You look like the traveling sort. Are you going to Deralia anytime soon?");
		SetMoveDest(ENT_LASTSPOKE, 999);
		ASKED = 1;
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		if (ASKED != 1)
			return;
		SayText("Oh....ok...thanks anyway");
		ASKED = 0;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (ASKED != 1)
			return;
		SayText("Excellent! I was wondering if you'd be so kind as to deliver this letter for me?");
		SetMoveDest(ENT_LASTSPOKE, 999);
		Offer(ENT_LASTSPOKE, "item_letter");
		CallEventDelayed(0.0f, "3");
		ACCEPTED = true;
	}

	// say_letter2
	void OnSayLetter2()
	{
		SayText("As you can see, it's addressed to Willem Coflin in Deralia. If you can deliver that sometime, I'd be most happy!");
		SetMoveDest(ENT_LASTSPOKE, 999);
	}

	// randomspawn
	void OnRandomspawn()
	{
		if (!(RandomInt(0, 99) > 50))
			return;
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(30.0f, "Hoguld_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "randomspawn") { OnRandomspawn(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_letter2") { OnSayLetter2(); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		if (name == "Hoguld_Timer") { Hoguld_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
