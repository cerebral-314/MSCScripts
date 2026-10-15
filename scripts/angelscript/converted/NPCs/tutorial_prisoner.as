#pragma context server

// Converted from NPCs/tutorial_prisoner.script by msc_transpiler.
// Cell Mate for Dridje's Tutorial Map by CrazyMonkeyDude/The Magical Bong

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "NPCs/tutorial_prisoner"]
class TutorialPrisoner : BaseNpcScript, BaseChat
{
	// Constants
	string NPC_MODEL = "npc/femhuman2.mdl";
	string ANIM_IDLE = "idle1";

	// Variables (an unset .script variable reads as its own name)
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	bool GOT_YE_TORCH = false;
	bool SAID_GREETING = false;
	bool GET_YE_TORCH = false;
	bool WALL_BROKEN = false;

	// Variables declared by included files, with the value they start with in this script
	TutorialPrisoner()
	{
		ANIM_WALK = "idle1";
	}

	// unnamed block (first think)
	void TutorialPrisoner_FirstThink()
	{
		NO_JOB = true;
		NO_RUMOR = true;
		GOT_YE_TORCH = false;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!GOT_YE_TORCH && GET_YE_TORCH)
		{
			menuItem.title = "Ask for torch";
			menuItem.type = "callback";
			menuItem.callback = "say_torch";
			RegisterMenuItem(menuItem);
		}

		if (IsPlayer(player))
			OnFaceSpeaker(EntityId(player));
		if (IsPlayer(ENT_LASTSPOKE))
			OnFaceSpeaker(EntityId(EntityOf(ENT_LASTSPOKE)));
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Kyra");
		SetHealth(1);
		SetInvincible(true);
		SetNoPush(true);

		SetRace("beloved");
		SetModel(NPC_MODEL);
		SetModelBody(0, 0);

		SetWidth(30);
		SetHeight(96);
		SetSayTextRange(1024);
		SetHearingSensitivity(10);
		CatchSpeech("say_hi", "hail", "hello", "y0", "j0", "wassup", "greet", "gweets");
		CallEventDelayed(0.1f, "face_player");
	}

	// face_player
	void OnFacePlayer()
	{
		SetVar("TOKEN_LIST", GetActivePlayers());
		CBasePlayer@ playerId = FindPlayer(GetToken("TOKEN_LIST", 0));
		if (!IsAlive(playerId))
			return;
		OnFaceSpeaker(EntityId(playerId));

		CallEventDelayed(0.5f, "face_player");
	}

	// say_torch
	void OnSayTorch(CBasePlayer@ recipient = null)
	{
		OnConvoAnim();
		SayText("Here, you can have it.");
		SayText("Maybe you'll have better luck lighting it.");
		PlayAnim("once", "give_shot");
		Offer(recipient, "item_torch");
		GOT_YE_TORCH = true;
		CallEventDelayed(1.0f, "say_torch2");
	}

	// say_torch2
	void OnSayTorch2()
	{
		OnConvoAnim();
		SayText("Great! That's better.");
		CallEventDelayed(4.0f, "say_torch3");
	}

	// say_torch3
	void OnSayTorch3()
	{
		OnConvoAnim();
		SayText("I was feeling around the walls here");
		CallEventDelayed(2.0f, "say_torch4");
	}

	// say_torch4
	void OnSayTorch4()
	{
		OnConvoAnim();
		SayText("One area felt cracked, and made a hollow noise when I knocked on it.");
		CallEventDelayed(3.0f, "say_torch5");
	}

	// say_torch5
	void OnSayTorch5()
	{
		OnConvoAnim();
		SayText("Find it, and give it a whack with that torch!");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!SAID_GREETING)
		{
			OnPlayerGreeting();
		}
		else if (!WALL_BROKEN)
		{
			OnFaceSpeaker();
			SayText("You have the torch, Adventurer. Find the weak spot.");
		}
		else
		{
			OnFaceSpeaker();
			SayText("Hurry! The guards will be along soon!");
			MessageAll("green", "(She shoos you towards the hole in the wall)");
		}
	}

	// player_spawned
	void OnPlayerSpawned()
	{
		CallEventDelayed(5.0f, "player_greeting");
	}

	// player_greeting
	void OnPlayerGreeting()
	{
		OnConvoAnim();
		if (SAID_GREETING)
			return;
		SayText("Hello, Adventurer!");
		SAID_GREETING = true;
		GET_YE_TORCH = true;
		CallEventDelayed(2.0f, "player_greeting2");
	}

	// player_greeting2
	void OnPlayerGreeting2()
	{
		OnConvoAnim();
		SayText("I woke up a few minutes ago, with you on the other side of the cell.");
		CallEventDelayed(2.0f, "player_greeting3");
	}

	// player_greeting3
	void OnPlayerGreeting3()
	{
		OnConvoAnim();
		SayText("You've been out for quite a while.");
		CallEventDelayed(5.0f, "player_greeting4");
	}

	// player_greeting4
	void OnPlayerGreeting4()
	{
		OnConvoAnim();
		SayText("We're in a holding cell, as you can see.");
		CallEventDelayed(5.0f, "player_greeting5");
	}

	// player_greeting5
	void OnPlayerGreeting5()
	{
		OnConvoAnim();
		SayText("Last I saw were bandits before I was clocked on the head.");
		CallEventDelayed(10.0f, "player_greeting6");
	}

	// player_greeting6
	void OnPlayerGreeting6()
	{
		SayText("It's so dark in here!");
		PlayAnim("once", "pondering2");
		CallEventDelayed(4.0f, "player_greeting7");
	}

	// player_greeting7
	void OnPlayerGreeting7()
	{
		OnConvoAnim();
		SayText("I found this [torch] in a corner, but I can't seem to light it!");
		MessageAll("green", "Press the use key (Default 'e') on Kyra to bring up her chat menu");
	}

	// wall_broken
	void OnWallBroken()
	{
		OnConvoAnim();
		SayText("Great job! Now we can get out of here.");
		CallEventDelayed(2.0f, "wall_broken2");
		WALL_BROKEN = true;
	}

	// wall_broken2
	void OnWallBroken2()
	{
		OnConvoAnim();
		SayText("Though I think I'll hold back for now");
		CallEventDelayed(2.0f, "wall_broken3");
	}

	// wall_broken3
	void OnWallBroken3()
	{
		OnConvoAnim();
		SayText("I'll distract the guards should they return.");
		CallEventDelayed(4.0f, "wall_broken4");
	}

	// wall_broken4
	void OnWallBroken4()
	{
		OnConvoAnim();
		SayText("Go on! I'll be fine!");
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
		Precache("npc/femhuman2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TutorialPrisoner_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "face_player") { OnFacePlayer(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "player_greeting") { OnPlayerGreeting(); return true; }
		if (name == "player_greeting2") { OnPlayerGreeting2(); return true; }
		if (name == "player_greeting3") { OnPlayerGreeting3(); return true; }
		if (name == "player_greeting4") { OnPlayerGreeting4(); return true; }
		if (name == "player_greeting5") { OnPlayerGreeting5(); return true; }
		if (name == "player_greeting6") { OnPlayerGreeting6(); return true; }
		if (name == "player_greeting7") { OnPlayerGreeting7(); return true; }
		if (name == "player_spawned") { OnPlayerSpawned(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_torch") { OnSayTorch(PlayerParam(params, 0)); return true; }
		if (name == "say_torch2") { OnSayTorch2(); return true; }
		if (name == "say_torch3") { OnSayTorch3(); return true; }
		if (name == "say_torch4") { OnSayTorch4(); return true; }
		if (name == "say_torch5") { OnSayTorch5(); return true; }
		if (name == "wall_broken") { OnWallBroken(); return true; }
		if (name == "wall_broken2") { OnWallBroken2(); return true; }
		if (name == "wall_broken3") { OnWallBroken3(); return true; }
		if (name == "wall_broken4") { OnWallBroken4(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
