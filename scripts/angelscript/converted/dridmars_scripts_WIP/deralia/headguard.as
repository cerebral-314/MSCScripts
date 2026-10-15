#pragma context server

// Converted from dridmars_scripts_WIP/deralia/headguard.script by msc_transpiler.
// Head Guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "dridmars_scripts_WIP/deralia/headguard"]
class DridmarsScriptsWipDeraliaHeadguard : BaseNpcScript, BaseChat
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	int StartGuardQuest = 0;
	int GuardQuestFinished = 0;
	bool PLAYER_NEAR = false;
	float GUARD_LOOP = 0.0f;
	string LAST_SPOKE_TO = "LAST_SPOKE_TO";
	string PLAYER_SPLOTTED = "PLAYER_SPLOTTED";
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	bool BUSY_CHATTING = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";

	// unnamed block (timer)
	void DridmarsScriptsWipDeraliaHeadguard_Timer()
	{
		int count;
		CallEventDelayed(3.0f, "DridmarsScriptsWipDeraliaHeadguard_Timer");

		SetVar("PLAYER_SUSPECTS", GetActivePlayers());
		PLAYER_NEAR = false;
		GUARD_LOOP = 0.0f;
		count = GetTokenCount("PLAYER_SUSPECTS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckNear();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}

		if (PLAYER_NEAR && LAST_SPOKE_TO != PLAYER_SPLOTTED)
		{
			SetMoveDest(PLAYER_SPLOTTED, 50);
			SetSayTextRange(512);
			SayText("You there! STOP!");
			LAST_SPOKE_TO = PLAYER_SPLOTTED;
		}
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (StartGuardQuest == 1 && Truthy(ItemExists(player, "drink_mead")))
		{
			menuItem.title = "Show Note";
			menuItem.type = "payment";
			menuItem.data = "drink_mead";
			menuItem.callback = "hand_note";
			RegisterMenuItem(menuItem);
		}
	}

	// npc_spawn
	// #include NPCs/human_guard
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(300);
		SetInvincible(true);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Head Guard");
		SetRoam(false);

		SetModel("npc/guard1.mdl");
		SetIdleAnim("c1a0_catwalkidle");
		SetMoveAnim("walk");

		CatchSpeech("say_sus", "suspicious", "sus", "no", "nope", "negative");
		CatchSpeech("say_help", "help", "assist", "job", "task", "quest");

		StartGuardQuest = 0;
		GuardQuestFinished = 0;
	}

	// check_near
	void OnCheckNear()
	{
		string curPlayer = GetToken("PLAYER_SUSPECTS", int(GUARD_LOOP));
		if (RangeTo(curPlayer) < 256.0f)
		{
			PLAYER_NEAR = true;
			PLAYER_SPLOTTED = curPlayer;
		}
		GUARD_LOOP += 1.0f;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (GuardQuestFinished == 0)
			SayText("You there! Have you seen anyone [suspicious] around the city?");

		if (GuardQuestFinished == 1)
			SayText("Thanks for your help, adventurer.");
	}

	// say_sus
	void OnSaySus()
	{
		CHAT_STEPS = 3;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "I'm investigating a report of a mysterious individual sneaking around the city in the dead of night.";
		CHAT_STEP2 = "I've questioned many walking the streets at that time and have no leads.";
		CHAT_STEP3 = "You seem like a resourceful adventurer.  How would you like to [help] me?";
		OnChatLoop();
	}

	// say_help
	void OnSayHelp(CBasePlayer@ talkingPlayer = null)
	{
		CHAT_STEPS = 3;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "Since the investigation seems to be at a standstill, we should start from the beginning.";
		CHAT_STEP2 = "Drayke, who lives opposite the fountain, made the report.";
		CHAT_STEP3 = "See him and inquire about any further details which could help us.";
		OnChatLoop();
		UseTrigger("questdoordrayke");
		StartGuardQuest = 1;
	}

	// hand_note
	void OnHandNote()
	{
		CHAT_STEPS = 4;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "What's this?";
		CHAT_STEP2 = "This letter is signed by a 'Rudolf'.";
		CHAT_STEP3 = "Find this person and inquire about Drayke's whereabouts.";
		CHAT_STEP4 = "Ask around if you can't find him yourself.";
		OnChatLoop();
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
		Precache("npc/guard1.mdl");
		CallEventDelayed(3.0f, "DridmarsScriptsWipDeraliaHeadguard_Timer");
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
		if (name == "check_near") { OnCheckNear(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "hand_note") { OnHandNote(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_help") { OnSayHelp(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_sus") { OnSaySus(); return true; }
		if (name == "DridmarsScriptsWipDeraliaHeadguard_Timer") { DridmarsScriptsWipDeraliaHeadguard_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
