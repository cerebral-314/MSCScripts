#pragma context server

// Converted from NPCs/script_assistant.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "NPCs/script_assistant"]
class ScriptAssistant : BaseChatArrayScript
{
	// Constants
	string CONTROLLER_HEAD_LR = "controller0";
	string CONTROLLER_HEAD_UD = "controller1";
	int SUMMON_DIST = 256;

	// Variables (an unset .script variable reads as its own name)
	string SUMMON_SCRIPT = "SUMMON_SCRIPT";
	float N_SUMMONS = 0.0f;
	bool MAP_SHIELD_ON = false;
	bool WATER_OPEN = false;
	float SUMMON_ANG = 0.0f;
	string MENU_MODE = "MENU_MODE";
	string CVAR_SCRIPTS = "CVAR_SCRIPTS";
	string DEV_SCRIPTS = "DEV_SCRIPTS";
	string PLAYER_LIST = "PLAYER_LIST";
	int DID_INTRO = 0;
	string MENU_TARGET = "MENU_TARGET";
	bool ADDED_SUMMON = false;
	Vector3 SCRIPT_POS = Vector3();

	// Variables declared by included files, with the value they start with in this script
	ScriptAssistant()
	{
		CHAT_USE_CONV_ANIMS = false;
		CHAT_NO_CLOSE_MOUTH = true;
	}

	// unnamed block (first think)
	void ScriptAssistant_FirstThink()
	{
		ArrayCreate("PROBLEM_LIST");
		ArrayCreate("ARRAY_SUMMONS");
		SUMMON_SCRIPT = "0";
		N_SUMMONS = 0.0f;
		MAP_SHIELD_ON = true;
		WATER_OPEN = false;
		SUMMON_ANG = 90.0f;
		MENU_MODE = "0";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Dungeon Master's Assistant");
		SetModel("monsters/venevus.mdl");
		SetWidth(32);
		SetHeight(72);
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");

		SetSayTextRange(1024);

		SetProp(ENT_ME, "scale", 0.75f);

		CatchSpeech("menu_whoami", "hi", "hail", "hello", "who", "j0", "waddup", "you");
		CatchSpeech("menu_list_problems", "problem");
		CatchSpeech("menu_map_help", "help");
		CatchSpeech("menu_toggle_water", "water");
		CatchSpeech("menu_toggle_shield", "shield");
		CatchSpeech("summon", "send_menu");
		CatchSpeech("menu_remove_all", "remove");

		CallEventDelayed(0.1f, "scan_for_master");
		CallEventDelayed(0.05f, "check_problems");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;
		int count;

		if (MENU_MODE == "0")
		{
			if (GetArrayCount("PROBLEM_LIST") == 0)
			{
				if (int(DEV_SCRIPTS.length()) > 12)
				{
					menuItem.title = "[Summon] a creation...";
					menuItem.type = "callback";
					menuItem.callback = "menu_summon";
					RegisterMenuItem(menuItem);
				}

				if (N_SUMMONS > 0.0f)
				{
					menuItem.title = "Remove a creation...";
					menuItem.type = "callback";
					menuItem.callback = "menu_remove_specific";
					RegisterMenuItem(menuItem);

					menuItem.title = "[Remove] all creations.";
					menuItem.type = "callback";
					menuItem.callback = "menu_remove_all";
					RegisterMenuItem(menuItem);
				}
			}
			else
			{
				OnShowHelp();
			}

			if (!WATER_OPEN)
				menuItem.title = "Open the [water] ways.";
			else
				menuItem.title = "Close the [water] ways.";
			menuItem.type = "callback";
			menuItem.callback = "menu_toggle_water";
			RegisterMenuItem(menuItem);

			if (!MAP_SHIELD_ON)
				menuItem.title = "Raise the [shield].";
			else
				menuItem.title = "Lower the [shield].";
			menuItem.type = "callback";
			menuItem.callback = "menu_toggle_shield";
			RegisterMenuItem(menuItem);

			if (GetArrayCount("PROBLEM_LIST") == 0)
				OnShowHelp();
		}

		if (MENU_MODE == "summon")
		{
			OnChatNow("Which of your creations shall I summon?", "4.0", "none", "none", "add_to_que", "clear_que");
			count = GetTokenCount(DEV_SCRIPTS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnListSummonOptions();
			}
			MENU_MODE = "0";
		}

		if (MENU_MODE == "remove_specific")
		{
			OnChatNow("Which of your creations shall I remove?", "4.0", "none", "none", "add_to_que", "clear_que");
			count = GetArrayCount("ARRAY_SUMMONS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnListSummonsLoop();
			}
			MENU_MODE = "0";
		}
	}

	// check_problems
	void OnCheckProblems()
	{
		int cvarDev = Int(Eval("game.cvar.ms_dev_mode"));
		CVAR_SCRIPTS = Eval("game.cvar.ms_dynamicnpc");

		if (cvarDev == 0)
			ArrayAdd("PROBLEM_LIST", "ms_dev_mode is not set to 1 in the listenserver.cfg!");

		if (int(CVAR_SCRIPTS.length()) < 2)
			ArrayAdd("PROBLEM_LIST", "ms_dynamicnpc does not seem to be set in the listenserver.cfg!");

		DEV_SCRIPTS = "";
		int count = GetTokenCount(CVAR_SCRIPTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnParseMsDynamicnpc();
		}
	}

	// scan_for_master
	void OnScanForMaster()
	{
		if (DID_INTRO != 0)
			return;
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckPlayers();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(1.0f, "scan_for_master");
	}

	// check_players
	void OnCheckPlayers()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (DID_INTRO != 0)
			return;
		if (!(RangeTo(curTarg) < 256.0f))
			return;
		DID_INTRO = 1;
		CHAT_CURRENT_SPEAKER = curTarg;
		CallEventDelayed(2.0f, "do_intro");
	}

	// do_intro
	void OnDoIntro()
	{
		int count;
		if (GetArrayCount("PROBLEM_LIST") > 0)
		{
			OnChatNow("Master! Something is wrong!", "2.0", "none", "none", "add_to_que");

			count = GetArrayCount("PROBLEM_LIST");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnListProblems();
			}

			if (GetArrayCount("PROBLEM_LIST") > 1)
				OnChatNow("I'm afraid this will have to be fixed before we can continue.", "4.0", "none", "none", "add_to_que");
			else
				OnChatNow("These problems will have to be remedied before we can continue.", "4.0", "none", "none", "add_to_que");
		}
		else
		{
			OnChatNow("Master... We are ready to begin.", "2.0", "none", "none", "add_to_que");
		}
	}

	// list_problems
	void OnListProblems()
	{
		string curProb = GetArray("PROBLEM_LIST", Text(loopIteration));

		DebugPrint("list_problems " + curProb);

		if (loopIteration == 1)
			OnChatNow("Also...", "1.0", "none", "none", "add_to_que");

		float probLenRatio = int(curProb.length());
		if (probLenRatio > 60.0f)
			probLenRatio = 60.0f;
		probLenRatio = Divide(probLenRatio, 60.0f);

		DebugPrint("list_problems lineratio " + Text(probLenRatio));

		float chatTime = Ratio(probLenRatio, 2, 4.5f);

		OnChatNow(curProb, Text(probLenRatio), "none", "none", "add_to_que");
	}

	// parse_ms_dynamicnpc
	void OnParseMsDynamicnpc()
	{
		bool scriptInvalid = false;
		string curScript = GetToken(CVAR_SCRIPTS, loopIteration);

		if (StartsWith(curScript, "test_scripts"))
		{
			if (Contains(curScript, ".script"))
			{
				ArrayAdd("PROBLEM_LIST", "A script in ms_dynamicnpc has a .script extention...");
				ArrayAdd("PROBLEM_LIST", "...Extentions should not be included in script names.");
				scriptInvalid = true;
			}
			if (Contains(curScript, "\\"))
			{
				ArrayAdd("PROBLEM_LIST", "A script in has a back slash (\\) in its name - please only use forward slahes (/) - usually under the question mark.");
				scriptInvalid = true;
			}

			if (!scriptInvalid)
				DEV_SCRIPTS = TokenAdd(DEV_SCRIPTS, curScript);
		}
		else
		{
			ArrayAdd("PROBLEM_LIST", "There is a script not prefixed with test_scripts/ in ms_dynamicnpc...");
			ArrayAdd("PROBLEM_LIST", "I can only summon scripts found in the msc/test_scripts folder.");
		}
	}

	// list_summons_loop
	void OnListSummonsLoop()
	{
		MenuItem menuItem;
		int curIdx = loopIteration;
		string curSum = GetArray("ARRAY_SUMMONS", Text(curIdx));
		if (!IsAlive(curSum))
			return;

		menuItem.title = NameOf(curSum);
		menuItem.type = "callback";
		menuItem.data = curIdx;
		menuItem.callback = "menu_remove_by_idx";
		RegisterMenuItem(menuItem);
	}

	// menu_remove_by_idx
	void OnMenuRemoveByIdx(CBasePlayer@ target = null, int summonIndex = 0)
	{
		PlayAnim("critical", "castspell");
		string curSum = GetArray("ARRAY_SUMMONS", Text(summonIndex));
		SetMoveDest(OriginOf(curSum), 9999);
		string chatText = GetProp(curSum, "name.full.capital") + " has been removed.";
		OnChatNow(chatText, "3.0", "none", "none", "add_to_que", "clear_que");
		ArraySet("ARRAY_SUMMONS", summonIndex, 0);
		DeleteEntity(curSum, "fade");
		N_SUMMONS -= 1.0f;
	}

	// show_help
	void OnShowHelp()
	{
		MenuItem menuItem;
		menuItem.title = "What is this place?";
		menuItem.type = "callback";
		menuItem.callback = "menu_map_help";
		RegisterMenuItem(menuItem);

		menuItem.title = "Who are you?";
		menuItem.type = "callback";
		menuItem.callback = "menu_whoami";
		RegisterMenuItem(menuItem);

		if (GetArrayCount("PROBLEM_LIST") > 0)
		{
			menuItem.title = "What were the [problems] again?";
			menuItem.type = "callback";
			menuItem.callback = "menu_list_problems";
			RegisterMenuItem(menuItem);
		}
	}

	// list_summon_options
	void OnListSummonOptions()
	{
		MenuItem menuItem;
		int curIdx = loopIteration;
		menuItem.title = GetToken(DEV_SCRIPTS, curIdx);
		menuItem.type = "callback";
		menuItem.data = GetToken(DEV_SCRIPTS, curIdx);
		menuItem.callback = "menu_summon_script";
		RegisterMenuItem(menuItem);
	}

	// menu_list_problems
	void OnMenuListProblems()
	{
		OnChatClearQue();
		int count = GetArrayCount("PROBLEM_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnListProblems();
		}
	}

	// menu_map_help
	void OnMenuMapHelp()
	{
		OnChatNow("This map is for testing your creations, my master!", "3.0", "castspell", "none", "clear_que", "add_to_que");
		OnChatNow("Here, you can safely summon creatures, and your other creations...", "4.0", "none", "none", "add_to_que");
		OnChatNow("Scripts you created in the test_scripts/ folder.", "3.0", "none", "none", "add_to_que");
		OnChatNow("I can summon any such script here, and offer various tools to help you in their testing.", "5.0", "none", "none", "add_to_que");
		OnExplainCvars();
		if (GetArrayCount("PROBLEM_LIST") > 0)
			OnChatNow("I could start summoning your creations right now, but alas, there are these [problems]...", "5.0", "none", "none", "add_to_que");
	}

	// menu_whoami
	void OnMenuWhoami()
	{
		OnChatNow("I, am your humble assistant...", "2.0", "castspell", "none", "clear_que", "add_to_que");
		OnChatNow("It is my task to aid in the testing of your creations.", "4.0", "none", "none", "add_to_que");
		OnChatNow("I can summon your creations, remove them, and provide aid in a few other methods of testing.", "4.0", "none", "none", "add_to_que");
		OnExplainCvars();
		if (GetArrayCount("PROBLEM_LIST") > 0)
			OnChatNow("I could start assisiting you right now, but alas, there are these [problems]...", "5.0", "none", "none", "add_to_que");
	}

	// explain_cvars
	void OnExplainCvars()
	{
		OnChatNow("Such creations must be scripts in the test_scripts/ folder...", "3.0", "none", "none", "add_to_que");
		OnChatNow("And added to ms_dynamicnpc cvar, set in your listenserver.cfg.", "none", "none", "add_to_que");
		OnChatNow("You can add multiple creations, by adding their script names, and seperating them by semi-colons (;).", "4.0", "none", "none", "add_to_que");
		OnChatNow("For instance...", "2.0", "none", "none", "add_to_que");
		OnChatNow("ms_dynamic_npc test_scripts/test_spider;test_scripts/test_orc", "4.0", "none", "none", "add_to_que");
		OnChatNow("Lastly, the server must be in developer mode, so ms_dev_mode must be set to 1 in the listenserver.cfg as well.", "5.0", "none", "none", "add_to_que");
	}

	// menu_summon
	void OnMenuSummon(CBasePlayer@ target = null)
	{
		MENU_MODE = "summon";
		MENU_TARGET = EntityId(target);
		CallEventDelayed(0.1f, "send_menu");
	}

	// send_menu
	void OnSendMenu()
	{
		if (!IsAlive(MENU_TARGET))
			MENU_TARGET = EntityId(EntityOf(ENT_LASTSPOKE));
		OpenMenu(MENU_TARGET);
	}

	// menu_summon_script
	void OnMenuSummonScript(CBasePlayer@ target = null, string summonScript = "")
	{
		SUMMON_SCRIPT = summonScript;
		PlayAnim("critical", "castspell");
		OnFaceSummon();
		SUMMON_ANG += 90.0f;
		if (SUMMON_ANG > 359.0f)
			SUMMON_ANG = 0.0f;
		MENU_MODE = "0";
	}

	// castspell
	// frame event
	void OnCastspell()
	{
		DebugPrint("castspell " + SUMMON_SCRIPT);
		if (SUMMON_SCRIPT == "0")
			return;
		CreateNpc(SUMMON_SCRIPT, SCRIPT_POS);
		SUMMON_SCRIPT = "0";
		N_SUMMONS += 1.0f;
		ClientEvent("new", "all", "effects/sfx_summon_circle", SCRIPT_POS, 3);
		CallEventDelayed(1.0f, "name_summon");
	}

	// name_summon
	void OnNameSummon()
	{
		int count;
		string summonName = GetProp(ENT_LASTCREATED, "name.full.capital");
		string chatStr = summonName + " has been summoned.";
		OnChatNow(chatStr, "3.0", "none", "none", "add_to_que");
		if (Truthy(ScriptVarOf(ENT_LASTCREATED, "NPC_IS_FISH")) && !WATER_OPEN)
		{
			OnChatNow("This appears to be a fish, so I shall open the [water] ways.", "3.0", "none", "none", "add_to_que");
			OnMenuToggleWater();
			CallEventDelayed(1.0f, "dunk_it");
		}
		AddVelocity(ENT_LASTCREATED, RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, -1000)));

		if (GetArrayCount("ARRAY_SUMMONS") > 1)
		{
			ADDED_SUMMON = false;
			count = GetArrayCount("ARRAY_SUMMONS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddSummonLoop();
			}
			if (!ADDED_SUMMON)
				ArrayAdd("ARRAY_SUMMONS", @EntityOf(ENT_LASTCREATED));
		}
		else
		{
			ArrayAdd("ARRAY_SUMMONS", @EntityOf(ENT_LASTCREATED));
		}
	}

	// add_summon_loop
	void OnAddSummonLoop()
	{
		if (ADDED_SUMMON)
			return;
		string curSum = GetArray("ARRAY_SUMMONS", Text(loopIteration));
		if (IsAlive(curSum))
			return;
		ArraySet("ARRAY_SUMMONS", loopIteration, @EntityOf(ENT_LASTCREATED));
		ADDED_SUMMON = true;
	}

	// menu_toggle_shield
	void OnMenuToggleShield()
	{
		OnFaceSummon();
		PlayAnim("critical", "castspell");
		UseTrigger("twal_shield");
		if (MAP_SHIELD_ON)
		{
			MAP_SHIELD_ON = false;
			OnChatNow("The [shield] is lowered.", "3.0", "none", "none", "add_to_que");
		}
		else
		{
			MAP_SHIELD_ON = true;
			OnChatNow("The [shield] is raised.", "3.0", "none", "none", "add_to_que");
		}
	}

	// menu_toggle_water
	void OnMenuToggleWater()
	{
		OnFaceSummon();
		PlayAnim("critical", "castspell");
		UseTrigger("door_water");
		if (WATER_OPEN)
		{
			WATER_OPEN = false;
			OnChatNow("The [water] ways are sealed.", "3.0", "none", "none", "add_to_que");
		}
		else
		{
			WATER_OPEN = true;
			OnChatNow("The [water] ways are opened.", "3.0", "none", "none", "add_to_que");
		}
	}

	// face_summon
	void OnFaceSummon()
	{
		SCRIPT_POS = OriginOf(ENT_ME);
		SCRIPT_POS += RelativePosition(Vector3(0, SUMMON_ANG, 0), Vector3(0, SUMMON_DIST, 0));
		SetMoveDest(SCRIPT_POS, 9999);
	}

	// menu_remove_all
	void OnMenuRemoveAll()
	{
		int count;
		PlayAnim("critical", "castspell");
		OnFaceSummon();
		OnChatNow("All your creations have been removed...", "3.0", "none", "none", "add_to_que");
		N_SUMMONS = 0.0f;
		if (GetArrayCount("ARRAY_SUMMONS") > 1)
		{
			count = GetArrayCount("ARRAY_SUMMONS");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnRemoveSummonsLoop();
			}
		}
		else
		{
			if (GetArray("ARRAY_SUMMONS", "0") != "0")
				DeleteEntity(GetArray("ARRAY_SUMMONS", "0"), "fade");
			if (GetArray("ARRAY_SUMMONS", "1") != "0")
				DeleteEntity(GetArray("ARRAY_SUMMONS", "1"), "fade");
			ArraySet("ARRAY_SUMMONS", 0, 0);
			ArraySet("ARRAY_SUMMONS", 1, 0);
		}
	}

	// remove_summons_loop
	void OnRemoveSummonsLoop()
	{
		string curSum = GetArray("ARRAY_SUMMONS", Text(loopIteration));
		if (!IsAlive(curSum))
			return;
		DeleteEntity(curSum, "fade");
		ArraySet("ARRAY_SUMMONS", loopIteration, 0);
	}

	// menu_remove_specific
	void OnMenuRemoveSpecific(CBasePlayer@ target = null)
	{
		MENU_MODE = "remove_specific";
		MENU_TARGET = EntityId(target);
		CallEventDelayed(0.1f, "send_menu");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/venevus.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ScriptAssistant_FirstThink();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_summon_loop") { OnAddSummonLoop(); return true; }
		if (name == "castspell") { OnCastspell(); return true; }
		if (name == "check_players") { OnCheckPlayers(); return true; }
		if (name == "check_problems") { OnCheckProblems(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "explain_cvars") { OnExplainCvars(); return true; }
		if (name == "face_summon") { OnFaceSummon(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "list_problems") { OnListProblems(); return true; }
		if (name == "list_summon_options") { OnListSummonOptions(); return true; }
		if (name == "list_summons_loop") { OnListSummonsLoop(); return true; }
		if (name == "menu_list_problems") { OnMenuListProblems(); return true; }
		if (name == "menu_map_help") { OnMenuMapHelp(); return true; }
		if (name == "menu_remove_all") { OnMenuRemoveAll(); return true; }
		if (name == "menu_remove_by_idx") { OnMenuRemoveByIdx(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "menu_remove_specific") { OnMenuRemoveSpecific(PlayerParam(params, 0)); return true; }
		if (name == "menu_summon") { OnMenuSummon(PlayerParam(params, 0)); return true; }
		if (name == "menu_summon_script") { OnMenuSummonScript(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "menu_toggle_shield") { OnMenuToggleShield(); return true; }
		if (name == "menu_toggle_water") { OnMenuToggleWater(); return true; }
		if (name == "menu_whoami") { OnMenuWhoami(); return true; }
		if (name == "name_summon") { OnNameSummon(); return true; }
		if (name == "parse_ms_dynamicnpc") { OnParseMsDynamicnpc(); return true; }
		if (name == "remove_summons_loop") { OnRemoveSummonsLoop(); return true; }
		if (name == "scan_for_master") { OnScanForMaster(); return true; }
		if (name == "send_menu") { OnSendMenu(); return true; }
		if (name == "show_help") { OnShowHelp(); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
