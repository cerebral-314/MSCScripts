#pragma context server

// Converted from gatecity/mayor.script by msc_transpiler.
// Mayor of Gate City

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "gatecity/mayor"]
class GatecityMayor : BaseChatScript
{
	// Variables (an unset .script variable reads as its own name)
	int QUEST_GOBLINCHIEF = 0;
	float ZOMBIE_COUNT = 0.0f;
	int REQ_ZOMBIES = 0;
	string ZOMBIE_QUEST_STARTER = "ZOMBIE_QUEST_STARTER";
	CBasePlayer@ QUESTER_HEAD = null;
	CBasePlayer@ USED_ME = null;
	bool L_ZOMBIE_QUEST_DONE = false;
	bool GAVE_HEAVY_WARN = false;
	bool ZOMBIE_QUEST = false;
	string QUEST_WINNER = "QUEST_WINNER";
	bool ALREADY_GAVE_AXE = false;
	bool QUEST_STARTER_LEFT = false;
	bool REMOVED_SPAWNS = false;
	string SPAWN_LIST = "SPAWN_LIST";
	float RSPAWN_COUNT = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat

		SetUniqueName("dwarf_mayor");

		SetHealth(30); // Start with 30 hit points
		SetGold(50);
		SetName("|Mayor Vilhelm");
		SetFieldOfView(120);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 0); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 0); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword
		SetInvincible(true);
		QUEST_GOBLINCHIEF = 0;
		ZOMBIE_COUNT = 0.0f;
		REQ_ZOMBIES = 40;
		ZOMBIE_QUEST_STARTER = "0";

		SetHearingSensitivity(10);

		SetModelBody(2, 0);

		SetMoveAnim("idle");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor");
		CatchSpeech("zombie_countup", "zombie", 200, "count", "undead");
		CatchSpeech("say_axe", "axe", "golden", "broken");
		CatchSpeech("say_roland", "roland", "where");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		// dbg got +use
		@USED_ME = player;

		if (ZOMBIE_QUEST && ZOMBIE_COUNT < REQ_ZOMBIES)
		{
			menuItem.title = "How many more Zombies!?";
			menuItem.type = "callback";
			menuItem.data = "zombie_countup";
			menuItem.callback = "zombie_countup";
			RegisterMenuItem(menuItem);
		}

		if (Truthy(ItemExists(player, "item_gaxe_handle")))
		{
			menuItem.title = "Ask about broken axe";
			menuItem.type = "callback";
			menuItem.data = "say_axe";
			menuItem.callback = "say_axe";
			RegisterMenuItem(menuItem);
		}

		if (QUEST_GOBLINCHIEF == 0 && Truthy(ItemExists(player, "item_goblinhead")))
		{
			@QUESTER_HEAD = player;
			menuItem.title = "Give Goblin's Head";
			menuItem.type = "payment";
			menuItem.data = "item_goblinhead";
			menuItem.callback = "say_ending";
			RegisterMenuItem(menuItem);
		}

		if (ZOMBIE_COUNT >= REQ_ZOMBIES)
		{
			SetGlobal("ZOMBIE_QUEST_COMPLETE", 1);
			L_ZOMBIE_QUEST_DONE = true; // werid stuff going on with the varg
		}

		if (L_ZOMBIE_QUEST_DONE)
		{
			// if !G_GAVE_AXE
			if (!ALREADY_GAVE_AXE)
			{
				// only give to quest starter
				// unless he's not around no more
				if (!Exists(ZOMBIE_QUEST_STARTER))
				{
					ZOMBIE_QUEST_STARTER = "0";
					@USED_ME = null;
				}
				if (EntityId(USED_ME) == ZOMBIE_QUEST_STARTER)
				{
					if (!GAVE_HEAVY_WARN)
					{
						GAVE_HEAVY_WARN = true;
						SayText("I be warnin' ya - it's a REAL heavy key. Be sure you pack light!");
					}
					menuItem.title = "Collect Zombie Reward";
					menuItem.type = "callback";
					menuItem.callback = "axe_em";
					RegisterMenuItem(menuItem);
				}
			}
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		SayText("I've heard Helena has fended off a fierce orc invasion.");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Welcome to Gate City, Adventurer!");
		CallEventDelayed(0.0f, "3");
	}

	// say_hi2
	void OnSayHi2()
	{
		if (QUEST_GOBLINCHIEF == 0)
			SayText("I may have a [job] for you.");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		bool exitSub = false;

		if (Truthy(GetVar("ZOMBIE_QUEST_COMPLETE")))
		{
			SayText("Nah, I canna possibly ask you to do anymore. Ya've earned yer rest laddie.");
			exitSub = true;
		}
		if (exitSub)
			return;
		if (L_ZOMBIE_QUEST_DONE)
		{
			SayText("Nah, I canna possibly ask you to do anymore. Ya've earned yer rest laddie.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (ZOMBIE_QUEST)
			OnZombieCountup();

		if (ZOMBIE_QUEST)
			return;

		if (QUEST_GOBLINCHIEF == 0)
		{
			SayText("Yes, lately, the city has been bothered by goblins.");
			CallEventDelayed(0.0f, "3");
		}

		if (QUEST_GOBLINCHIEF == 1)
		{
			SayText("Well, there is ONE other thing I can have ya do.");
			CallEventDelayed(4.0f, "zombie_quest_desc");
		}
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		SayText("If the goblin chief is killed, the goblins in the area should leave.");
		CallEventDelayed(0.0f, "3");
	}

	// say_job3
	void OnSayJob3()
	{
		SayText("Bring to me the head of the goblin chief and I'll reward you.");
	}

	// say_ending
	void OnSayEnding()
	{
		QUEST_GOBLINCHIEF = 1;
		SayText("Very good Adventurer! You have proven your worth!");
		CallEventDelayed(0.0f, "3");
	}

	// say_ending2
	void OnSayEnding2()
	{
		SayText("Take this gold as a reward! You will always be welcome in Gate City!");
		Offer(QUESTER_HEAD, "gold", RandomInt(50, 60));
		CallExternal("all", "goblin_remove");
		SetGlobal("G_NO_GLOBINS", 1);
	}

	// zombie_quest_desc
	void OnZombieQuestDesc()
	{
		SayText("Ya see we dwarves, being made of the stuff of Urdual and all, are particularly sensitive to imbalance.");
		CallEventDelayed(4.0f, "zombie_quest_desc2");
	}

	// zombie_quest_desc2
	void OnZombieQuestDesc2()
	{
		SayText("Even, as luck would have it, from beyond the grave.");
		CallEventDelayed(4.0f, "zombie_quest_desc3");
	}

	// zombie_quest_desc3
	void OnZombieQuestDesc3()
	{
		SayText("There's some mighty strange goins on these days, for I swear by the black and white seal more than half the dead are awake.");
		CallEventDelayed(4.0f, "zombie_quest_desc4");
	}

	// zombie_quest_desc4
	void OnZombieQuestDesc4()
	{
		SayText("There's just too many dwarves wandering the catacombs, making it impossible to get to the better mining areas.");
		CallEventDelayed(4.0f, "zombie_quest_desc5");
	}

	// zombie_quest_desc5
	void OnZombieQuestDesc5()
	{
		SayText("And Underkeep's cut off too, which does us no bit of good, not at all.");
		CallEventDelayed(4.0f, "zombie_quest_desc6");
	}

	// zombie_quest_desc6
	void OnZombieQuestDesc6()
	{
		SayText("Kill me " + REQ_ZOMBIES + " zombies - and I'll reward you with the key to the city!");
		CallEventDelayed(4.0f, "zombie_quest_desc7");
	}

	// zombie_quest_desc7
	void OnZombieQuestDesc7()
	{
		SayText("Or well, something shaped vaguely like it, and a mite sharper too!");
		CallEventDelayed(4.0f, "zombie_quest_desc8");
	}

	// zombie_quest_desc8
	void OnZombieQuestDesc8()
	{
		SayText("Gotta get it all done today though, or there'll just be so many it won't be worth doin' no more!");
		ZOMBIE_QUEST = true;
		if (ZOMBIE_QUEST_STARTER != "0")
			return;
		ZOMBIE_QUEST_STARTER = EntityId(QUESTER_HEAD);
	}

	// zombie_countup
	void OnZombieCountup()
	{
		bool exitSub = false;

		if (QUEST_GOBLINCHIEF == 0)
		{
			SayText("Yes, we have a bit of a problem with the Undead. But one thing at a time, young lad: The goblins first!");
			CallEventDelayed(0.0f, "3");
		}

		if (!ZOMBIE_QUEST)
			return;

		if (ZOMBIE_COUNT < REQ_ZOMBIES)
		{
			int zCount = int(ZOMBIE_COUNT);
			float zToGo = REQ_ZOMBIES - ZOMBIE_COUNT;
			zToGo = int(zToGo);

			SayText("Well, countin' by the screams from down there, I think ya've killed about " + zCount + " of em.");
			SayText("I guess that leaves ya about " + Text(zToGo) + " left to kill. Keep at it!");
			PlayAnim("once", "nod");
		}

		if (ZOMBIE_COUNT >= REQ_ZOMBIES)
		{
			if (!L_ZOMBIE_QUEST_DONE)
			{
				if (IsAlive(ZOMBIE_QUEST_STARTER))
				{
					// dont talk about the axe lest the quest starter is nearby
					// assuming said quest starter is still on the server
					if (!QUEST_STARTER_LEFT) // id's mix
					{
						Vector3 starterOrigin = OriginOf(ZOMBIE_QUEST_STARTER);
						if (Distance(Vec(ZOMBIE_QUEST_STARTER), MyOrigin()) > 512.0f)
							exitSub = true;
					}
				}
				if (!exitSub)
				{
					SayText("I see you've come to collect yer reward?");
					InfoMessage(ENT_LASTSPOKE, "NPC Interaction Menu", "Use the +use key to to activate this NPC's interaction menu");
				}
			}

			L_ZOMBIE_QUEST_DONE = true; // seems to be some strange issue going on with the varg
			SetGlobal("ZOMBIE_QUEST_COMPLETE", 1);

			if (!REMOVED_SPAWNS)
				OnRemoveSpawns();
		}
	}

	// axe_em
	void OnAxeEm(CBasePlayer@ winner = null)
	{
		if (ALREADY_GAVE_AXE)
			return;
		QUEST_WINNER = EntityId(winner);
		SayText("Wow, you really did it. Ya must be about as restless as the undead themselves!");
		CallEventDelayed(4.0f, "axe_em2");
	}

	// axe_em2
	void OnAxeEm2()
	{
		if (ALREADY_GAVE_AXE)
			return;
		ALREADY_GAVE_AXE = true;
		Offer(QUEST_WINNER, "axes_golden");
		SayText("Well, here ya go, you've earned it. It's forged with my family's special recipe for undead slayin' axe!");
	}

	// zombie_died
	void OnZombieDied()
	{
		if (!ZOMBIE_QUEST)
			return;
		ZOMBIE_COUNT += 1.0f;
		if (!(ZOMBIE_COUNT >= REQ_ZOMBIES))
			return;
		OnRemoveSpawns();
		InfoMessage("all", "You have killed a lotta zombies!", "You should speak with the mayor again...");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!(RangeTo(ENT_LASTHEARD) < 200.0f))
			return;
		SetMoveDest(ENT_LASTHEARD, 9999);
	}

	// say_axe
	void OnSayAxe(CBasePlayer@ speaker = null)
	{
		bool exitSub = false;

		if (speaker is null)
		{
			// callled from chat, not from menu, make sure he has axe
			CBaseEntity@ speakerId = EntityOf(ENT_LASTSPOKE);
			if (!Truthy(ItemExists(speakerId, "item_gaxe_handle")))
				exitSub = true;
		}
		if (exitSub)
			return;

		SayText("Oh, my, I see ya broke it...");
		CallEventDelayed(4.0f, "say_axe2");
	}

	// say_axe2
	void OnSayAxe2()
	{
		SayText("Now don't get angry! Truth be told it be my great, great, great grandfather's recipe for golden axe...");
		CallEventDelayed(4.0f, "say_axe3");
	}

	// say_axe3
	void OnSayAxe3()
	{
		SayText("He never wrote it down, so I be goin' off memory when I make these.");
		CallEventDelayed(4.0f, "say_axe4");
	}

	// say_axe4
	void OnSayAxe4()
	{
		SayText("But talk Roland. He's the smith here in Gate City, and a fine one too.");
	}

	// say_roland
	void OnSayRoland()
	{
		SayText("He's on the main road, head left as you make your way out.");
		CallEventDelayed(4.0f, "say_axe5");
	}

	// game_playerleave
	void OnGamePlayerleave(CBasePlayer@ player = null)
	{
		if (EntityId(player) != ZOMBIE_QUEST_STARTER)
			return;
		DebugPrint("zombie quest starter disconect");
		QUEST_STARTER_LEFT = true;
	}

	// remove_spawns
	void OnRemoveSpawns()
	{
		REMOVED_SPAWNS = true;
		SPAWN_LIST = "spawners6;spawners7;spawners8;spawners9;spawners10";
		RSPAWN_COUNT = 0.0f;
		OnRemoveSpawnsLoop(); // spooling this out a bit slowly, in case buggers
	}

	// remove_spawns_loop
	void OnRemoveSpawnsLoop()
	{
		string curSpawn = GetToken(SPAWN_LIST, int(RSPAWN_COUNT));
		CBaseEntity@ killSpawn = FindByName(curSpawn);
		DeleteEntity(killSpawn, "remove");

		float nspawns = GetTokenCount(SPAWN_LIST) - 1.0f;
		if (!(RSPAWN_COUNT < nspawns))
			return;
		RSPAWN_COUNT += 1.0f;
		CallEventDelayed(1.0f, "remove_spawns_loop");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "axe_em") { OnAxeEm(PlayerParam(params, 0)); return true; }
		if (name == "axe_em2") { OnAxeEm2(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerleave") { OnGamePlayerleave(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_spawns") { OnRemoveSpawns(); return true; }
		if (name == "remove_spawns_loop") { OnRemoveSpawnsLoop(); return true; }
		if (name == "say_axe") { OnSayAxe(PlayerParam(params, 0)); return true; }
		if (name == "say_axe2") { OnSayAxe2(); return true; }
		if (name == "say_axe3") { OnSayAxe3(); return true; }
		if (name == "say_axe4") { OnSayAxe4(); return true; }
		if (name == "say_ending") { OnSayEnding(); return true; }
		if (name == "say_ending2") { OnSayEnding2(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_job3") { OnSayJob3(); return true; }
		if (name == "say_roland") { OnSayRoland(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "zombie_countup") { OnZombieCountup(); return true; }
		if (name == "zombie_died") { OnZombieDied(); return true; }
		if (name == "zombie_quest_desc") { OnZombieQuestDesc(); return true; }
		if (name == "zombie_quest_desc2") { OnZombieQuestDesc2(); return true; }
		if (name == "zombie_quest_desc3") { OnZombieQuestDesc3(); return true; }
		if (name == "zombie_quest_desc4") { OnZombieQuestDesc4(); return true; }
		if (name == "zombie_quest_desc5") { OnZombieQuestDesc5(); return true; }
		if (name == "zombie_quest_desc6") { OnZombieQuestDesc6(); return true; }
		if (name == "zombie_quest_desc7") { OnZombieQuestDesc7(); return true; }
		if (name == "zombie_quest_desc8") { OnZombieQuestDesc8(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
