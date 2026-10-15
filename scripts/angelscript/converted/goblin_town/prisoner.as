#pragma context server

// Converted from goblin_town/prisoner.script by msc_transpiler.
// Spawn properties
// Prisoner Quest in Goblin Town
// Husband from Gate City was travelling between towns selling
// his goods. He was captured by goblins and held prisoner.
// Wife wants you to find him. When found, he gives you a letter
// to deliver to her stating he is fine and will be home soon.
// Wife gives reward when the letter is delivered.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "goblin_town/prisoner"]
class GoblinTownPrisoner : BaseChatScript
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	int HEARING_RANGE = 175;

	// Variables (an unset .script variable reads as its own name)
	int QUEST_GOBLINPRISONER = 0;
	CBaseEntity@ PLAYER = null;
	Vector3 PLAYER_O = Vector3();
	CBaseEntity@ NPC = null;
	Vector3 NPC_O = Vector3();
	float distance = 0.0f;

	// game_precache
	void OnGamePrecache()
	{
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(30); // Start with 30 out of 30 max hit points
		SetGold(50);
		SetName("Almund the Traveling Merchant");
		// fov 120
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(1, 2);
		QUEST_GOBLINPRISONER = 0;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");

		CatchSpeech("say_no", "no", "nope");

		CatchSpeech("say_yes", "yes", "yup", "yea");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OnPlayerdist();
		if (distance <= HEARING_RANGE)
		{
			if (QUEST_GOBLINPRISONER == 0)
				SayText("Are you here to rescue me?");
			if (QUEST_GOBLINPRISONER == 1)
				SayText("I can find my way home now");
		}
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		OnPlayerdist();
		if (distance <= HEARING_RANGE)
		{
			if (QUEST_GOBLINPRISONER == 0)
				SayText("I guess I am doomed to rot in this cage...");
			if (QUEST_GOBLINPRISONER == 1)
				SayText("I can find my way home now");
		}
	}

	// say_yes
	void OnSayYes(CBasePlayer@ player = null)
	{
		OnPlayerdist();
		if (distance <= HEARING_RANGE)
		{
			if (QUEST_GOBLINPRISONER == 1)
				SayText("I can find my way home now.");
			if (QUEST_GOBLINPRISONER == 0)
			{
				QUEST_GOBLINPRISONER = 1;
				SayText("Thank you! My family must be worried about me!");
				CallEventDelayed(0.0f, "3");
			}
		}
	}

	// ending
	void OnEnding()
	{
		SayText("I was captured by these goblins while traveling between towns.");
		CallEventDelayed(0.0f, "3");
	}

	// ending2
	void OnEnding2()
	{
		SayText("They stole all of my goods, but that doesn't matter.");
		CallEventDelayed(0.0f, "3");
	}

	// reward
	void OnReward()
	{
		SayText("Please take this letter to my wife, Kendra, in Gate City.");
		Offer(ENT_LASTSPOKE, "item_letter_almund");
	}

	// playerdist
	void OnPlayerdist()
	{
		@PLAYER = EntityOf(ENT_LASTSPOKE);
		PLAYER_O = OriginOf(PLAYER);
		@NPC = self;
		NPC_O = OriginOf(NPC);
		distance = Distance(NPC_O, PLAYER_O);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ending") { OnEnding(); return true; }
		if (name == "ending2") { OnEnding2(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "playerdist") { OnPlayerdist(); return true; }
		if (name == "reward") { OnReward(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
