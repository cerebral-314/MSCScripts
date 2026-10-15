#pragma context server

// Converted from tutorial/prisoner.script by msc_transpiler.
// Cell Mate for Dridje's Tutorial Map by CrazyMonkeyDude/The Magical Bong

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "tutorial/prisoner"]
class TutorialPrisoner : BaseNpcScript, BaseChat
{
	// Constants
	string NPC_MODEL = "npc/femhuman2.mdl";
	string SOUND_BECKON = "npc/vs_nwncomf4_say.wav";
	string SOUND_HI = "npc/vs_nwncomf4_hi.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NO_JOB = false;
	bool NO_RUMOR = false;
	bool NO_HAIL = false;
	CBaseEntity@ PLAYER_ID = null;
	bool GOT_YE_TORCH = false;
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	bool GET_YE_TORCH = false;
	bool SAID_GREETING = false;
	bool WALL_BROKEN = false;
	bool SAID_WALL = false;
	bool DID_ORC_REACTION = false;

	// unnamed block (first think)
	void TutorialPrisoner_FirstThink()
	{
		NO_JOB = true;
		NO_RUMOR = true;
		NO_HAIL = true;
	}

	// unnamed block (timer)
	void TutorialPrisoner_Timer()
	{
		CallEventDelayed(Random(5, 10), "TutorialPrisoner_Timer");

		if (!SAID_GREETING)
		{
			PlaySound(0, 10, SOUND_BECKON);
			OnBchatMouthMove();
		}

		// Thothie: trying to make her look a bit more worried
		if (BUSY_CHATTING)
			return;
		string checkOrcs = FindInSphere("enemy", 256);
		if (checkOrcs == "none")
			return;
		CBaseEntity@ nearestNme = FindEntity(GetToken(checkOrcs, 0));
		if (RaceOf(nearestNme) != "orc")
			return;
		SetMoveDest(@nearestNme, 9999);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (BUSY_CHATTING)
			return;
		if (!GET_YE_TORCH)
			return;
		if (GOT_YE_TORCH)
			return;
		menuItem.title = "Ask for torch";
		menuItem.type = "callback";
		menuItem.callback = "say_torch";
		RegisterMenuItem(menuItem);

		OnFaceSpeaker(EntityId(player));
	}

	// chat_loop
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat
		OnConvoAnim();

		if (CHAT_STEP == 9.0f)
		{
			InfoMessage("all", "Communication", "Press the use key (Default e) on Kyra to bring up her chat menu.");
			CallEventDelayed(10.0f, "summon_orcs"); // Thothie: let script bring in at dramatically appropriate moment
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Kyra");
		SetHealth(1);
		SetInvincible(true);
		SetNoPush(true);

		SetRace("human"); // Thothie: for scans (see end of script)
		PLAYING_DEAD = "1"; // Thothie: So doesn't register as a valid target
		SetModel(NPC_MODEL);
		SetModelBody(0, 0);
		SetIdleAnim("idle1");

		SetWidth(30);
		SetHeight(96);
		SetSayTextRange(1024);
		CatchSpeech("say_hi", "hail", "hello", "y0", "j0", "wassup", "greet", "gweets", "hi");

		// Thothie: no point in having two loops here.
		CallEventDelayed(0.1f, "face_player");
	}

	// face_player
	void OnFacePlayer()
	{
		// Thothie: If the server starts before the player joins up, this loop will not find a living player, and thus, will not loop the way you had it before
		CallEventDelayed(1.0f, "face_player");

		SetVar("TOKEN_LIST", GetActivePlayers());
		@PLAYER_ID = FindEntity(GetToken("TOKEN_LIST", 0));
		if (IsAlive(PLAYER_ID))
			OnFaceSpeaker(EntityId(PLAYER_ID));

		// merging player_greeting loop into this loop
		if (RangeTo(PLAYER_ID) < 96.0f && !SAID_GREETING) // Thothie: 256 is all the way accross the room
			OnPlayerGreeting();
	}

	// say_torch
	void OnSayTorch(CBasePlayer@ recipient = null)
	{
		CBasePlayer@ torchRecipient = recipient;
		// Thothie: This giving torch thing won't work if the player says 'torch' so...
		if (!IsPlayer(recipient))
			@recipient = ToPlayer(EntityOf(ENT_LASTSPOKE));

		PlayAnim("critical", "give_shot");
		Offer(torchRecipient, "item_torch");
		GOT_YE_TORCH = true; // Thothie: Ye forgot a flag for this, or she just keeps passing out torches
		CHAT_STEPS = 5;
		CHAT_STEP = 0.0f;
		CHAT_STEP1 = "Here, you can have it. Maybe you can light it.";
		CHAT_STEP2 = "Great! That's better.";
		CHAT_STEP3 = "I was feeling around the walls here";
		CHAT_STEP4 = "One area was missing a stone, and made a hollow noise when I knocked on it.";
		CHAT_STEP5 = "Find it, and give it a whack with that torch!";
		OnChatLoop();
		NO_HAIL = false;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (!WALL_BROKEN)
		{
			// callevent face_speaker //Thothie: requires a param, but pointless due to the face_player loop
			SayText("You have the torch, Adventurer. Find the weak spot.");
		}
		else
		{
			// callevent face_speaker //Thothie: requires a param, but pointless due to the face_player loop
			SayText("Hurry! They will notice soon!");
		}
	}

	// player_greeting
	void OnPlayerGreeting()
	{
		CHAT_STEPS = 9;
		CHAT_STEP = 0.0f;
		CHAT_STEP1 = "Hello, Adventurer!";
		CHAT_STEP2 = "You've been out for quite a while.";
		CHAT_STEP3 = "I woke up a few minutes ago, with you on the other side of the cell.";
		CHAT_STEP4 = "We're in a holding cell, as you can see.";
		CHAT_STEP5 = "Last I saw were bandits before I was clocked on the head.";
		CHAT_STEP6 = "I overheard the guards speaking about an Orc invasion.";
		CHAT_STEP7 = "It's the perfect time to escape!";
		CHAT_STEP8 = "It's so dark in here!";
		CHAT_STEP9 = "I found this torch in a corner, but I can't seem to light it!";
		OnChatLoop();
		CatchSpeech("say_torch", "torch");
		GET_YE_TORCH = true;
		SAID_GREETING = true;

		PlaySound(0, 10, SOUND_HI);
	}

	// summon_orcs
	void OnSummonOrcs()
	{
		UseTrigger("orc_attack");
		CallEventDelayed(1.0f, "orc_reaction");
	}

	// wall_broken
	void OnWallBroken()
	{
		WALL_BROKEN = true; // Thothie: think you skipped this flag

		if (BUSY_CHATTING) // Thothie: come back to this later if saying something else (prevent doubling up)
			CallEventDelayed(5.0f, "wall_broken");

		if (BUSY_CHATTING)
			return;

		if (SAID_WALL)
			return;
		CHAT_STEPS = 4;
		CHAT_STEP = 0.0f;
		CHAT_STEP1 = "Great job! Now we can get out of here.";
		CHAT_STEP2 = "Though I think I'll hold back for now";
		CHAT_STEP3 = "I'll distract them so you can escape.";
		CHAT_STEP4 = "Go on! I'll be fine!";
		OnChatLoop();
		SAID_WALL = true;
	}

	// orc_reaction
	// Thothie: My own orc_reaction event
	void OnOrcReaction()
	{
		if (BUSY_CHATTING) // Thothie: come back to this later if saying something else
			CallEventDelayed(5.0f, "orc_reaction");
		if (BUSY_CHATTING)
			return;

		if (DID_ORC_REACTION)
			return;
		DID_ORC_REACTION = true;

		float myZ = OriginOf(ENT_ME).z;
		SetMoveDest(Vector3(2300, 3360, myZ), 9999); // Thothie: Roughly the center of the adjacent room

		PlayAnim("critical", "fear1");

		SayText("By the gods! The orcs are attacking!");
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
		CallEventDelayed(Float(Eval("$randf(5.0,10.0)")), "TutorialPrisoner_Timer");
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
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "face_player") { OnFacePlayer(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "orc_reaction") { OnOrcReaction(); return true; }
		if (name == "player_greeting") { OnPlayerGreeting(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_torch") { OnSayTorch(PlayerParam(params, 0)); return true; }
		if (name == "summon_orcs") { OnSummonOrcs(); return true; }
		if (name == "wall_broken") { OnWallBroken(); return true; }
		if (name == "TutorialPrisoner_Timer") { TutorialPrisoner_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
