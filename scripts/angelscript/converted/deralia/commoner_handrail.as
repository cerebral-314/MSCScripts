#pragma context server

// Converted from deralia/commoner_handrail.script by msc_transpiler.
// *** Default human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "deralia/commoner_handrail"]
class CommonerHandrail : BaseNpcScript, BaseChat
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	int RND_TALK = 0;
	bool MENTIONED_BOAT = false;
	int CHAT_STEPS = 0;
	float CHAT_STEP = 0.0f;
	bool BUSY_CHATTING = false;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Ask about the row boat";
		menuItem.type = "callback";
		menuItem.callback = "say_boat";
		RegisterMenuItem(menuItem);

		if (!MENTIONED_BOAT)
			return;
		menuItem.title = "Rent the Rowboat (5 gp)";
		menuItem.type = "payment";
		menuItem.data = "gold:5";
		menuItem.callback = "borrow_boat";
		menuItem.cb_failed = "payment_failed";
		RegisterMenuItem(menuItem);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(15);
		SetWidth(5);
		SetHeight(64);
		SetRace("beloved");
		SetName("Commoner");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 2);
		SetIdleAnim("handrailidle");
		// setmoveanim	walk
		SetInvincible(true);

		CatchSpeech("say_hi", "hello", "hi", "hail", "greet", "hey");
		CatchSpeech("say_boat", "boat", "row", "oar");
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		RND_TALK = RandomInt(1, 3);
		if (RND_TALK == 1)
			OnRespond1();
		if (RND_TALK == 2)
			OnRespond2();
		if (RND_TALK == 3)
			OnRespond3();
	}

	// respond1
	void OnRespond1()
	{
		SayText("Sometimes I just come here and look up at the stars.");
	}

	// respond2
	void OnRespond2()
	{
		SayText("...");
	}

	// respond3
	void OnRespond3()
	{
		SayText("I'd love to row that boat and never come back, if these arms weren't so sore.");
		MENTIONED_BOAT = true;
	}

	// borrow_boat
	void OnBorrowBoat()
	{
		// gm_create_vote //<caller_event> <token_option:data> <title> [descript] [silent:0|1]
		CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votemap", "Yes!:gertenheld_cape;No!:0", "Row to Gertenheld Cape?");
		CallExternal("players", "ext_set_map", "gertenheld_cape", "from_deralia", "from_deralia"); // Set players valid map and transition points
	}

	// payment_failed
	void OnPaymentFailed()
	{
		SayText("Oh, ya can't lift yer five pennies? I cannae lift me oars. Thats too bad.");
	}

	// say_boat
	void OnSayBoat()
	{
		MENTIONED_BOAT = true;

		if (BUSY_CHATTING)
			return;

		CHAT_STEPS = 3;
		CHAT_STEP = 0.0f;
		BUSY_CHATTING = true;
		CHAT_STEP1 = "That little boat down there? I... rent it out sometimes.";
		CHAT_STEP2 = "It doesn't go as far as Charon's galleon, of course, but the little thing can get into places where his beast can't.";
		CHAT_STEP3 = "For instance, you can row up to Gertenheld cape, and see the lighthouse. Easy row that.";
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
		Precache("npc/human1.mdl");
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
		if (name == "borrow_boat") { OnBorrowBoat(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "payment_failed") { OnPaymentFailed(); return true; }
		if (name == "respond1") { OnRespond1(); return true; }
		if (name == "respond2") { OnRespond2(); return true; }
		if (name == "respond3") { OnRespond3(); return true; }
		if (name == "say_boat") { OnSayBoat(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
