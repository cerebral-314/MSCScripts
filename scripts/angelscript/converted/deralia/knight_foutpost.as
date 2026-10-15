#pragma context server

// Converted from deralia/knight_foutpost.script by msc_transpiler.
// Foutpost Reinforcement NPC

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "deralia/knight_foutpost"]
class KnightFoutpost : BaseNpcScript, BaseChat
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	int FoutpostTrans = 0;
	int SAID_HI = 0;

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (SAID_HI != 0)
		{
			menuItem.title = "Leaving?";
			menuItem.type = "callback";
			menuItem.callback = "say_leave1";
			RegisterMenuItem(menuItem);
		}

		if (FoutpostTrans == 1)
		{
			menuItem.title = "Ask to Join";
			menuItem.type = "callback";
			menuItem.callback = "ask_join1";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(500);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Royal Knight");
		SetRoam(false);
		SetModel("npc/royal_guard1.mdl");
		SetInvincible(true);
		SetIdleAnim("idle1");

		CatchSpeech("say_hi", "hello", "hi", "hail", "hey", "sup");
		CatchSpeech("say_leave1", "leaving", "leave");

		FoutpostTrans = 0;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlaySound(5, 10, "voices/deralia/royalknight/royal1.wav");
		SayText("I don't have much time to talk, adventurer.  We're [leaving] shortly.");
		SAID_HI = 1;
	}

	// say_leave1
	void OnSayLeave1()
	{
		PlaySound(5, 10, "voices/deralia/royalknight/royal2.wav");
		SayText("The King has finally agreed to send reinforcements to an outpost to the north.");
		CallEventDelayed(5.0f, "say_leave2");
	}

	// say_leave2
	void OnSayLeave2()
	{
		PlaySound(5, 10, "voices/deralia/royalknight/royal3.wav");
		SayText("The Orcs have been more aggressive in their recent attacks.");
		CallEventDelayed(4.0f, "say_leave3");
	}

	// say_leave3
	void OnSayLeave3()
	{
		PlaySound(5, 10, "voices/deralia/royalknight/royal4.wav");
		SayText("We've received word from Vadrel that another attack would be imminent.");
		FoutpostTrans = 1;
	}

	// ask_join1
	void OnAskJoin1()
	{
		PlaySound(5, 10, "voices/deralia/royalknight/royal5.wav");
		SayText("Well, you seem to know how to use a weapon... or so I hope.");
		CallEventDelayed(5.0f, "ask_join2");
	}

	// ask_join2
	void OnAskJoin2()
	{
		PlaySound(5, 10, "voices/deralia/royalknight/royal6.wav");
		SayText("Just don't expect me to babysit you... or bring back your corpse.");

		CallEventDelayed(4.0f, "start_vote");
	}

	// start_vote
	void OnStartVote()
	{
		// <caller_event> <token_option:data> <title> [descript] [silent 0/1]
		string voteTitle = "Join the Reinforcements to the Forgotton Outpost?";
		string options = "Yes!:foutpost;No!:0";
		CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votemap", options, voteTitle, "Voting begins now!", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/royal_guard1.mdl");
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
		if (name == "ask_join1") { OnAskJoin1(); return true; }
		if (name == "ask_join2") { OnAskJoin2(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_leave1") { OnSayLeave1(); return true; }
		if (name == "say_leave2") { OnSayLeave2(); return true; }
		if (name == "say_leave3") { OnSayLeave3(); return true; }
		if (name == "start_vote") { OnStartVote(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
