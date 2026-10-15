#pragma context server

// Converted from deralia/pat.script by msc_transpiler.
// Thothie - quest gets bugged sometimes, fixed. (Var definition + duplicate events)
// Pat the hat thief

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "deralia/pat"]
class Pat : BaseChatScript
{
	// Constants
	bool CAN_CHAT = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	bool FLEE_PLAYER = false;
	string CURRENT_ENEMY = "\x81PNULL\x81P";
	string SOUND_IDLE1 = "voices/human/male_idle4.wav";
	string SOUND_IDLE2 = "voices/human/male_idle5.wav";
	string SOUND_IDLE3 = "voices/human/male_idle6.wav";
	int HAT_QUEST = 1;
	bool SEE_ENEMY = false;

	// unnamed block (first think)
	void Pat_FirstThink()
	{
		FLEE_PLAYER = false;
		CURRENT_ENEMY = "\x81PNULL\x81P";

		// setvar	HAT_QUEST 0	//this is a global var called by deralia/barguy, do not reset it here
		SOUND_IDLE1 = "voices/human/male_idle4.wav";
		SOUND_IDLE2 = "voices/human/male_idle5.wav";
		SOUND_IDLE3 = "voices/human/male_idle6.wav";
	}

	// unnamed block (timer)
	void Pat_Timer()
	{
		CallEventDelayed(Random(0.5f, 1.5f), "Pat_Timer");

		if ((FLEE_PLAYER ? 1 : 0) != 1)
			return;
		SetMoveAnim("run1");
		SetMoveDest("flee", ENT_LASTSEEN, 500);
	}

	// say_rumor
	// Rumours
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		PlayAnim("once", "pondering");
		SayText("Rumours? What do I know of such things? What, huh!? It wasn't me who took those rings!");
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(50);
		SetGold(RandomInt(3, 6));
		SetName("man with a hat");
		SetUniqueName("Pat");
		// fov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("neutral");
		SetRoam(true);
		SetInvincible(true);
		SetModel("npc/human1.mdl");
		SetMoveAnim("walk_scared");
		SetModelBody(0, 4);
		SetModelBody(1, 2);
		SetBlood("red");

		GiveItem("item_hat");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_hat", "hat");
		CatchSpeech("say_rumor", "rumours", "news", "happenings", "rumour");
		CatchSpeech("say_name", "name");
	}

	// HAT_START
	void OnHatStart()
	{
		HAT_QUEST = 1;
	}

	// say_name
	void OnSayName()
	{
		SayText("My name is Pat..");
		SetName("Pat with a hat");
	}

	// wander
	void OnWander()
	{
		SetMoveAnim("walk_scared");
		SEE_ENEMY = false;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("I didn't do it! I swear!");
	}

	// gossip_1
	void OnGossip1()
	{
		SayText("No thieves in the area! I know that!");
	}

	// say_hat
	void OnSayHat()
	{
		if (HAT_QUEST == 1)
		{
			SetRace("orc");
			SetInvincible(false);
			SayText("This is my hat! You can't have it!");
			FLEE_PLAYER = true;
		}

		if (HAT_QUEST == 0)
			SayText("What of MY hat?");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		FLEE_PLAYER = true;
		CallEventDelayed(0.0f, "60");
	}

	// reset
	void OnReset()
	{
		SetMoveAnim("walk_scared");
		FLEE_PLAYER = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(Float(Eval("$randf(0.5,1.5)")), "Pat_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Pat_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "HAT_START") { OnHatStart(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gossip_1") { OnGossip1(); return true; }
		if (name == "reset") { OnReset(); return true; }
		if (name == "say_hat") { OnSayHat(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_name") { OnSayName(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "wander") { OnWander(); return true; }
		if (name == "Pat_Timer") { Pat_Timer(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
