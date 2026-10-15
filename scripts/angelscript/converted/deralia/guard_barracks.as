#pragma context server

// Converted from deralia/guard_barracks.script by msc_transpiler.
// Guards, Patrol

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/human_guard.as"
#include "converted/monsters/base_chat.as"

[script "deralia/guard_barracks"]
class GuardBarracks : HumanGuardScript, BaseChat
{
	// Constants
	float BG_SPEED = 1.0f;

	// Variables (an unset .script variable reads as its own name)
	int TALK = 0;
	CBasePlayer@ QUEST_WIN = null;
	bool BUSY_TALKING_JOB = false;
	string MENU_MODE = "MENU_MODE";
	CBaseEntity@ JOB_TARGET = null;
	bool NO_CHAT = false;
	bool TOOK_JOB = false;

	// Variables declared by included files, with the value they start with in this script
	GuardBarracks()
	{
		BG_ROAM = 1;
	}

	// unnamed block (timer)
	// Greet player and other NPCs
	void GuardBarracks_Timer()
	{
		CallEventDelayed(RandomInt(25, 45), "GuardBarracks_Timer");

		if (IS_HUNTING)
			return;

		if (!Truthy(LegacyFunction("cansee", "ally", 128)))
			return;

		OnNpcatkSetmovedest(ENT_LASTSEEN, "128");

		PlaySound(0, 5, "npc/hello1.wav");
		Say("[.83]", "[.33]", "[.91]", "[.91]", "[.38]", "[.36]");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuard_OnNpcSpawn(npc); // NPCs/human_guard

		SetName("Cathain, Militia Quartermaster");

		SetRoam(true);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_help", "help");
		CatchSpeech("say_rumour", "news", "happenings", "rumour", "rumours");
		CatchSpeech("say_island", "island");

		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (!TRADE_RING && MENU_MODE == "sewers")
		{
			menuItem.title = "Take the Sewer Job";
			menuItem.type = "callback";
			menuItem.callback = "go_to_sewers";
			RegisterMenuItem(menuItem);
		}

		if (!TRADE_RING)
			return;
		int rquestStep = Int(GetQuestData(player, "r"));
		if (rquestStep != 12)
			return;
		menuItem.title = "Offer 500 gold";
		menuItem.type = "payment";
		menuItem.data = "gold:500;item_ring";
		menuItem.callback = "got_ring";
		RegisterMenuItem(menuItem);
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour();
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		TALK = RandomInt(1, 5);
		OnRespond1();
		OnRespond2();
	}

	// respond1
	void OnRespond1()
	{
		if (TALK != 1)
			return;
		SayText("I should've joined the army...");
	}

	// respond2
	void OnRespond2()
	{
		if (TALK == 1)
			return;
		SayText("Be on your way sir.");
	}

	// say_help
	void OnSayHelp(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Ergh, help yourself.");
	}

	// say_rumour
	void OnSayRumour(string speaker = "")
	{
		SayText("Hmmm, why would you ask such things? Best be on your way traveller.");
	}

	// say_island
	void OnSayIsland()
	{
		SayText("Huh, what? How did you ... the people in this city talk too much.");
	}

	// got_ring
	void OnGotRing(CBasePlayer@ player = null)
	{
		Offer(player, "item_ring_percept");
		@QUEST_WIN = player;
		SayText("There ya go, snapped back together, good as new.");
		CallEventDelayed(2.0f, "got_ring2");
		Quest("set", QUEST_WIN, "r", 0);
	}

	// got_ring2
	void OnGotRing2()
	{
		SetMoveAnim("walk");
		SetRoam(true);
		PlayAnim("once", "walk");
		SetMoveDest(@QUEST_WIN, 200, "flee");
		SayText("Make good use of it!");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (BUSY_TALKING_JOB)
			return;
		BUSY_TALKING_JOB = true;
		SetRoam(false);
		MENU_MODE = "sewers";
		if (IsAlive(player))
		{
			SetMoveDest(@player, 9999);
			@JOB_TARGET = player;
		}
		else
		{
			SetMoveDest(ENT_LASTSPOKE, 9999);
			@JOB_TARGET = EntityOf(ENT_LASTSPOKE);
		}
		SayText("Eh? You want a job aye? Well have I got one for you...");
		CallEventDelayed(3.0f, "say_job2");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		if (TOOK_JOB)
			return;
		SayText("We sent a construction team, down into the sewers, a little while ago, and lost em.");
		CallEventDelayed(5.0f, "say_job3");
	}

	// say_job3
	void OnSayJob3()
	{
		if (TOOK_JOB)
			return;
		SayText("So we sent a chunk of the militia after them... And we lost THEM.");
		CallEventDelayed(5.0f, "say_job4");
	}

	// say_job4
	void OnSayJob4()
	{
		if (TOOK_JOB)
			return;
		SayText("I can't spare anymore men on that ancient maze, but if we don't fix things down there soon...");
		CallEventDelayed(5.0f, "say_job5");
	}

	// say_job5
	void OnSayJob5()
	{
		if (TOOK_JOB)
			return;
		SayText("...It's going to get... Very odorous, up here in Deralia...");
		CallEventDelayed(5.0f, "say_job6");
	}

	// say_job6
	void OnSayJob6()
	{
		if (TOOK_JOB)
			return;
		SayText("I can't pay you, mind ye. However, all sorts of recluse wizards and such have setup shop down there in the past...");
		CallEventDelayed(5.0f, "say_job7");
	}

	// say_job7
	void OnSayJob7()
	{
		if (TOOK_JOB)
			return;
		SayText("So there's bound to be a fair amount of loot - if you can get out alive.");
		CallEventDelayed(5.0f, "say_job8");
	}

	// say_job8
	void OnSayJob8()
	{
		if (TOOK_JOB)
			return;
		SayText("If you're interested, give me a heads up, and I'll show you the way. I'm too busy to go down there myself, mind you.");
		BUSY_TALKING_JOB = false;
		CallEventDelayed(5.0f, "say_job9");
	}

	// say_job9
	void OnSayJob9()
	{
		NO_CHAT = true; // suspend other chat menus
		OpenMenu(JOB_TARGET);
	}

	// go_to_sewers
	void OnGoToSewers()
	{
		TOOK_JOB = true;
		SayText("Alright, I'll show you the way in just a few minutes... Now where'd I put that damned key...");
		CallExternal(GetVar("GAME_MASTER"), "gm_map_vote", @JOB_TARGET, "deraliasewers", "Do you wish to enter Deralia Sewers?", 1, 1);
		CallExternal("players", "ext_set_map", "deraliasewers", "from_deralia", "from_deralia");
		PlayerMessageGreen(JOB_TARGET, "Starting vote for Deraliasewers...");
		NO_CHAT = false;
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		SetRoam(true);
		NO_CHAT = false;
		TOOK_JOB = false;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		CallEventDelayed(Float(Eval("$rand(25,45)")), "GuardBarracks_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HumanGuard_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseGuardFriendlyNew_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "go_to_sewers") { OnGoToSewers(); return true; }
		if (name == "got_ring") { OnGotRing(PlayerParam(params, 0)); return true; }
		if (name == "got_ring2") { OnGotRing2(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "respond1") { OnRespond1(); return true; }
		if (name == "respond2") { OnRespond2(); return true; }
		if (name == "say_help") { OnSayHelp(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_island") { OnSayIsland(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_job3") { OnSayJob3(); return true; }
		if (name == "say_job4") { OnSayJob4(); return true; }
		if (name == "say_job5") { OnSayJob5(); return true; }
		if (name == "say_job6") { OnSayJob6(); return true; }
		if (name == "say_job7") { OnSayJob7(); return true; }
		if (name == "say_job8") { OnSayJob8(); return true; }
		if (name == "say_job9") { OnSayJob9(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "GuardBarracks_Timer") { GuardBarracks_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| HumanGuardScript::DispatchEvent(name, params);
	}
}
