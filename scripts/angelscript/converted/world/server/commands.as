#pragma context server

// Converted from world/server/commands.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/developer/devcmds.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Commands
{
	// Constants
	float FREQ_WEATHER = 10.0f;
	string WEATHER_SPRITE = "rain.spr";
	string SPRITE_SPLASH = "rain_splash.spr";
	string SPRITE_MIST = "rain_mist.spr";
	string SPRITE_RIPPLE = "rain_ripple.spr";
	string SOUND_RAIN = "weather/rain.wav";
	string SCRIPT_SFX1 = "effects/sfx_lightning";
	string LTNG_SND = "weather/Storm_exclamation.wav";

	// Variables (an unset .script variable reads as its own name)
	bool TIMESET_DELAY = false;
	bool WEATHERSET_DELAY = false;
	CBaseEntity@ CALLING_PLAYER = null;
	bool WARNED_DRIDJE = false;
	bool CAN_VOTE = false;
	string POINTS_TNLIST = "POINTS_TNLIST";
	string POINTS_TPLIST = "POINTS_TPLIST";
	string TEST_PLR = "TEST_PLR";
	bool HIGH_IDX = false;
	bool HIGH_SCORE = false;
	string POINTS_PLIST = "POINTS_PLIST";
	string POINTS_NLIST = "POINTS_NLIST";
	string TIP_TEXT = "TIP_TEXT";
	string RESIST_NAMES = "RESIST_NAMES";
	string RESIST_VALUES = "RESIST_VALUES";
	string CREST_SELECTION = "CREST_SELECTION";
	string LEADING_GUILDS = "LEADING_GUILDS";

	// unnamed block (first think)
	void Commands_FirstThink()
	{
		TIMESET_DELAY = false;
		WEATHERSET_DELAY = false;
	}

	// game_precache
	void Commands_OnGamePrecache()
	{
		// (never true here, the rest is skipped) if SCRIPT_TOKENS isnot 'SCRIPT_TOKENS'
	}

	// dev_precache
	void Commands_OnDevPrecache()
	{
		string scriptFile = GetToken("SCRIPT_TOKENS", loopIteration);
		PrecacheFile(scriptFile);
	}

	// game_playercmd
	// returns console command from player (only works on world script)
	void Commands_OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "")
	{
		bool isSlash = false;
		string slashCommand = "SLASH_COMMAND";
		Vector3 spawnPoint = Vec("SPAWN_POINT");
		bool exitSub = false;
		string newName = "L_NEW_NAME";
		string petTypeToName = "PET_TYPE_TO_NAME";
		bool typeValid = false;
		bool invalidName = false;
		bool doFnTime = false;
		string toggleMode = "TOGGLE_MODE";
		string crestName = "CREST_NAME";

		if (Truthy(GetVar("G_SPECIAL_COMMANDS")) && ToLowerCase(MapName()) == "ms_soccer")
		{
			if (StartsWith(argument2, "score"))
			{
				CallExternal(FindByName("soccer_ball"), "ext_say_scores");
				return;
			}
			if (StartsWith(argument2, "ball"))
			{
				CallExternal(FindByName("soccer_ball"), "ext_send_menu", @EntityOf(ENT_CURRENTPLAYER));
				return;
			}
		}

		if (StartsWith(command, "/"))
		{
			isSlash = true;
			slashCommand = ToLowerCase(command);
		}

		if (isSlash)
		{
			if (slashCommand == "/stuck")
			{
				spawnPoint = Vec(ScriptVarOf(ENT_CURRENTPLAYER, "MY_HOME"));
				Vector3 curLoc = OriginOf(ENT_CURRENTPLAYER);
				if (Distance(curLoc, spawnPoint) > 256.0f)
				{
					PlayerMessageDark(ENT_CURRENTPLAYER, "[/STUCK]: You are too far from your spawn point to use /stuck.");
					ConsoleMessage(ENT_CURRENTPLAYER, "[/STUCK]: You are too far from your spawn point to use /stuck.");
					CallExternal(ENT_CURRENTPLAYER, "ext_stuck_adj");
				}
				else
				{
					string spawnName = GetQuestData(ENT_CURRENTPLAYER, "d");
					LegacyCommand("tospawn", ENT_CURRENTPLAYER, spawnName);
					PlayerMessage(ENT_CURRENTPLAYER, "Moving you to another spawn point...");
					ConsoleMessage(ENT_CURRENTPLAYER, "Moving you to another spawn point...");
					CallExternal(ENT_CURRENTPLAYER, "delay_to_ms_player_spawn");
				}
			}

			if (slashCommand == "/halo")
				CallExternal(ENT_CURRENTPLAYER, "toggle_halo");
			if (slashCommand == "/devlo")
				CallExternal(ENT_CURRENTPLAYER, "toggle_dev_halo");

			return;
		}

		if (ToLowerCase(command) == "motd")
		{
			CallExternal(ENT_CURRENTPLAYER, "force_motd");
		}
		else if (command == "resetbank")
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "Reset bank command recieved...");
			CallExternal(ENT_CURRENTPLAYER, "ext_reset_bank");
		}
		else if (command == "petname")
		{
			string petTypes = GetQuestData(ENT_CURRENTPLAYER, "pets");
			if (petTypes == "0")
			{
				ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: You have no pets.");
				exitSub = true;
			}
			if (!exitSub)
			{
				if (argument.isEmpty())
				{
					ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: Usage1: petname <name>");
					ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: Usage2: petname <pet_type> <name>");
					ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: Available Pet Types: " + petTypes);
					ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: - Use alphanumerics only!");
					ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: - If desired name requires spaces, use " + LegacyFunction("quote", "quotes"));
					exitSub = true;
				}
				if (!exitSub)
				{
					if (argument2.isEmpty())
					{
						newName = argument;
						petTypeToName = GetToken(petTypes, 0);
					}
					else
					{
						petTypeToName = argument;
						newName = argument2;
					}

					// case player defines invalid name
					if (Contains(petTypes, petTypeToName))
						typeValid = true;
					if (!typeValid)
					{
						ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: You have no pets of this type. ( " + petTypeToName + " )");
						ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: Available Pet Types: " + petTypes);
						exitSub = true;
					}
					if (!exitSub)
					{
						if (Contains(newName, "%"))
							invalidName = true;
						if (Contains(newName, "/"))
							invalidName = true;
						if (Contains(newName, "\\"))
							invalidName = true;
						if (invalidName)
							ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: Inavalid name - alphanumerics and spaces only, please");
						if (!invalidName)
						{
							string qName = petTypeToName + "_name";
							Quest("set", ENT_CURRENTPLAYER, qName, newName);
							ConsoleMessage(ENT_CURRENTPLAYER, "PETNAME: " + petTypeToName + " new name is: " + newName);
							CallExternal("all", "ext_companion_update_name");
						}
					}
				}
			}
		}
		else if (command == "listpoints")
		{
			@CALLING_PLAYER = EntityOf(ENT_CURRENTPLAYER);
			OnDoListPoints();
		}
		else if (command == "listresist")
		{
			@CALLING_PLAYER = EntityOf(ENT_CURRENTPLAYER);
			OnDoListResists();
		}
		else if (command == "flip")
		{
			string myName = NameOf(ENT_CURRENTPLAYER) + " Flips a Gold Piece";
			int dieRoll = RandomInt(1, 2);
			if (dieRoll == 1)
			{
				InfoMessage("all", myName, "It comes up HEADS");
				ConsoleMessage(ENT_CURRENTPLAYER, "Your coin comes up HEADS");
			}
			if (dieRoll == 2)
			{
				InfoMessage("all", myName, "It comes up TAILS");
				ConsoleMessage(ENT_CURRENTPLAYER, "Your coin comes up TAILS");
			}
		}
		else if (command == "roll")
		{
			string dSides = argument;
			if (dSides.isEmpty())
				dSides = "20";
			OnRollDie(dSides);
		}
		else if (command == "day")
		{
			// setvard PARAM1 settime
			// setvard PARAM2 12
			CallExternal(ENT_CURRENTPLAYER, "ext_tod_lock", "day");
			ConsoleMessage(ENT_CURRENTPLAYER, "Shifting your time of day effects to day.");
			ConsoleMessage(ENT_CURRENTPLAYER, "This does not affect world time nor other players.");
			ClientEvent("update", ENT_CURRENTPLAYER, Eval("const.localplayer.scriptID"), "environment_change", "day");
		}
		else if (command == "help")
		{
			if (argument.isEmpty())
				CallExternal(ENT_CURRENTPLAYER, "help_toggle");
		}
		else if (command == "dusk")
		{
			CallExternal(ENT_CURRENTPLAYER, "ext_tod_lock", "aft");
			ConsoleMessage(ENT_CURRENTPLAYER, "Shifting your time of day effects to dusk.");
			ConsoleMessage(ENT_CURRENTPLAYER, "This does not affect world time nor other players.");
			ClientEvent("update", ENT_CURRENTPLAYER, Eval("const.localplayer.scriptID"), "environment_change", "aft");
		}
		else if (command == "night")
		{
			CallExternal(ENT_CURRENTPLAYER, "ext_tod_lock", "night");
			ConsoleMessage(ENT_CURRENTPLAYER, "Shifting your time of day effects to night.");
			ConsoleMessage(ENT_CURRENTPLAYER, "This does not affect world time nor other players.");
			ClientEvent("update", ENT_CURRENTPLAYER, Eval("const.localplayer.scriptID"), "environment_change", "night");
		}
		else if (command == "clearsky")
		{
			// callexternal all game_playercmd_setweather clear 1 1
			if (GetVar("G_WEATHER_LOCK") != "0")
				ConsoleMessage(ENT_CURRENTPLAYER, "Weather is currently locked.");
			if (GetVar("G_WEATHER_LOCK") == "0")
				CallExternal(ENT_CURRENTPLAYER, "ext_weather_set_clear");
		}
		else if (command == "setweather")
		{
			if (GetVar("G_WEATHER_LOCK") != "0")
				ConsoleMessage(ENT_CURRENTPLAYER, "Weather is currently locked.");
			if (GetVar("G_WEATHER_LOCK") == "0")
				CallExternal(ENT_CURRENTPLAYER, "ext_weather_manual_change", argument);
		}
		else if (command == "time")
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "== TIME: " + GetVar("CURRENT_TIME") + " ==");
			PlayerMessage(ENT_CURRENTPLAYER, "== TIME: " + GetVar("CURRENT_TIME") + " ==");
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				doFnTime = true;
			if (Truthy(Eval("game.central")))
				doFnTime = true;
			if (doFnTime)
			{
				int month = Int(Eval("game.time.month"));
				string day = Eval("game.time.day");
				string year = Eval("game.time.year");
				string hour = Eval("game.time.hour");
				string min = Eval("game.time.minute");
				string outMsg = "(FN Time: ";
				outMsg += GetToken("???;JAN;FEB;MAR;APR;MAY;JUN;JUL;AUG;SEP;OCT;NOV;DEC", month) + year + "_" + day + " " + hour + ":" + min + ")";

				ConsoleMessage(ENT_CURRENTPLAYER, outMsg);
			}
		}
		else if (command == "xyz")
		{
			Vector3 pLoc = OriginOf(ENT_CURRENTPLAYER);
			float pX = pLoc.x;
			float pY = pLoc.y;
			float pTz = pLoc.z;
			pTz = int(pTz);
			float pZ = GroundHeight(pLoc); // $vec.z(P_LOC)
			Vector3 pAng = AnglesOf(ENT_CURRENTPLAYER);
			float pPitch = pAng.x;
			float pYaw = pAng.y;
			float pRoll = pAng.z;
			pX = int(pX);
			pY = int(pY);
			pZ = int(pZ);
			pPitch = int(pPitch);
			pYaw = int(pYaw);
			pRoll = int(pRoll);

			ConsoleMessage(ENT_CURRENTPLAYER, "Floor: ( " + Text(pX) + " " + Text(pY) + " " + Text(pZ) + " ) Center: ( " + Text(pX) + " " + Text(pY) + " " + Text(pTz) + " ) angles: ( " + Text(pPitch) + " " + Text(pYaw) + " " + Text(pRoll) + " )");
			PlayerMessage(ENT_CURRENTPLAYER, "Floor: ( " + Text(pX) + " " + Text(pY) + " " + Text(pZ) + " ) Center: ( " + Text(pX) + " " + Text(pY) + " " + Text(pTz) + " ) angles: ( " + Text(pPitch) + " " + Text(pYaw) + " " + Text(pRoll) + " )");
		}
		else if (command == "betadate")
		{
			OnGiveTimestamp();
		}
		else if (command == "settime")
		{
			// settime <hour> <minute>
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				TIMESET_DELAY = false;
			if (TIMESET_DELAY)
				ConsoleMessage(ENT_CURRENTPLAYER, "You must wait a bit before changing the time again.");
			if (!TIMESET_DELAY)
			{
				TIMESET_DELAY = true;
				CallEventDelayed(FREQ_WEATHER, "reset_timeset_delay");
				OnSetTime(Float(argument), Float(argument2));
				CallExternal(ENT_CURRENTPLAYER, "ext_tod_lock", "none");
			}
		}
		else if (command == "show_health")
		{
			// let players on low end systems disable hud and still see their health
			toggleMode = argument;
			if (toggleMode != "0" && toggleMode != "1")
				toggleMode = "toggle";
			CallExternal(EntityOf(ENT_CURRENTPLAYER), "console_health_toggle", toggleMode);
		}
		else if (command == "wallpapercrest")
		{
			if (SteamIdOf(ENT_CURRENTPLAYER) == "STEAM_0:0:15435276")
			{
				crestName = "crest_w_1";
				if (Truthy(ItemExists(ENT_CURRENTPLAYER, crestName)))
				{
					ConsoleMessage(ENT_CURRENTPLAYER, "You already have your wallpaper crest.");
					exitSub = true;
				}
				if (!exitSub)
				{
					ConsoleMessage(ENT_CURRENTPLAYER, "Granting Avocado's wallpaper crest");
					CallExternal(GetVar("GAME_MASTER"), "give_item", @EntityOf(ENT_CURRENTPLAYER), crestName);
				}
			}
			if (SteamIdOf(ENT_CURRENTPLAYER) == "STEAM_0:1:7087443")
			{
				crestName = "crest_w_2";
				if (Truthy(ItemExists(ENT_CURRENTPLAYER, crestName)))
				{
					ConsoleMessage(ENT_CURRENTPLAYER, "You already have your wallpaper crest.");
					exitSub = true;
				}
				if (!exitSub)
				{
					ConsoleMessage(ENT_CURRENTPLAYER, "Granting Lockdown's wallpaper crest");
					CallExternal(GetVar("GAME_MASTER"), "give_item", @EntityOf(ENT_CURRENTPLAYER), crestName);
				}
			}
		}
		else if (command == "health_bars")
		{
			toggleMode = argument;
			if (toggleMode != "0" && toggleMode != "1")
				toggleMode = "toggle";
			CallExternal(EntityOf(ENT_CURRENTPLAYER), "healthbar_toggle", toggleMode);
		}
		else if (command == "dumpquest")
		{
			string quest = argument;
			ConsoleMessage(ENT_CURRENTPLAYER, "Quest " + quest + " is: " + GetQuestData(ENT_CURRENTPLAYER, quest));
		}

		if (command == "dridje_sphere")
		{
			// check steamid here
			if (SteamIdOf(ENT_CURRENTPLAYER) == "STEAM_0:1:4985228")
			{
				CBaseEntity@ sphere = FindByName("dridje_sphere");
				if (Exists(sphere))
				{
					if (!WARNED_DRIDJE)
					{
						WARNED_DRIDJE = true;
						ConsoleMessage(ENT_CURRENTPLAYER, "One sphere at a time, please. ;)");
						return;
					}
					else
					{
						WARNED_DRIDJE = false;
						ConsoleMessage(ENT_CURRENTPLAYER, "I said... ONE at a TIME.");
						// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
						DoDamageEx(ENT_CURRENTPLAYER, "direct", 42069, 100, GetVar("GAME_MASTER"), GetVar("GAME_MASTER"), "none", "apostle_effect");
						return;
					}
				}

				spawnPoint = OriginOf(ENT_CURRENTPLAYER);
				Vector3 myAngles = AnglesOf(ENT_CURRENTPLAYER);
				float myYaw = myAngles.y;
				spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));
				CreateNpc("monsters/companion/dridje", spawnPoint, @EntityOf(ENT_CURRENTPLAYER));
			}
		}
		else if (command == "msversion")
			ConsoleMessage(ENT_CURRENTPLAYER, "MS.DLL reports version " + Eval("game.revision") + " ( central " + Eval("game.central") + " )");

		if (command == "gimmecrest")
		{
			OnDoCrest(EntityOf(ENT_CURRENTPLAYER));
		}
		else if (command == "gimmestaff")
		{
			if (Truthy(Eval("game.central")))
			{
				string me = SteamIdOf(ENT_CURRENTPLAYER);
				if (!Contains(GetVar("G_DEVSTAFF_OWNERS"), me))
					return;
			}

			CallExternal(GetVar("GAME_MASTER"), "give_item", @EntityOf(ENT_CURRENTPLAYER), "dev_staff");
		}

		if (command == ".")
		{
			string outPar1 = argument;
			string outPar2 = argument2;
			string outPar3 = voteOption;
			string outPar4 = voteOption2;
			string outPar5 = voteOption3;
			string outPar6 = voteOption4;
			string outPar7 = value;
			string outPar8 = value2;
			OnDevCommand(outPar1, outPar2, outPar3, outPar4, outPar5, outPar6, outPar7, outPar8);
		}
	}

	// reset_timeset_delay
	void Commands_OnResetTimesetDelay()
	{
		TIMESET_DELAY = false;
	}

	// reset_weatherset_delay
	void Commands_OnResetWeathersetDelay()
	{
		WEATHERSET_DELAY = false;
	}

	// give_timestamp
	void Commands_OnGiveTimestamp()
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "SC.DLL date " + BETA_TIMESTAMP + " MS.DLL version " + Eval("game.revision"));
		PlayerMessage(ENT_CURRENTPLAYER, "SC.DLL timestamp is " + BETA_TIMESTAMP + " MS.DLL version " + Eval("game.revision"));
	}

	// set_time
	// <hour> <minute>
	void Commands_OnSetTime(float hour = 0.0f, float minute = 0.0f)
	{
		if (!(Float(Eval("game.event.params")) >= 2.0f))
			return;

		hour = Modulo(hour, 24.0f);
		minute = Modulo(minute, 60.0f);

		OnTimeGetseconds(); // Get the number of seconds passed
		string mstimeSecs = GetVar("global.mstime.secs"); // since the beginning of game (MS Time)

		float secs = int(hour) * 3600.0f; // Get the desired time in seconds

		float minsToSecs = int(minute) * 60.0f;

		secs += minsToSecs;

		// Get the time offset from the start of the current day
		// Compare it to the requested time of day, to check if I should
		// advance to the next day.
		// --------------------------------------------------
		string daystartSecsText = GetVar("global.mstime.secs"); // Get start of this day
		float daystartSecs = Divide(Float(daystartSecsText), 86400.0f);
		daystartSecs = int(daystartSecs) * 86400.0f;
		daystartSecsText = Text(daystartSecs);

		float timefromdaystart = Float(GetVar("global.mstime.secs")); // Get time offset from start of day
		timefromdaystart -= daystartSecs;

		// If Requested time of day is earlier than Current time of day, fast forward a full day
		if (secs < timefromdaystart)
			secs += 86400.0f;

		// Add requested time to start of day
		float newtime = daystartSecs + secs;
		string newtimeText = Text(newtime);

		// Store in global
		SetGlobal("global.mstime.secs", newtimeText);

		SetGlobal("global.mstime.updateall", 0); // Force update to all
	}

	// roll_die
	// param1 = sides of die
	void Commands_OnRollDie(string sides = "")
	{
		string myName = NameOf(ENT_CURRENTPLAYER);
		string nSidesText = LegacyFunction("alphanum", sides); // sanatize
		int nSides = Int(nSidesText);
		myName += " Rolls a " + nSidesText + " Sided Die!";
		int dieRoll = RandomInt(1, nSides);
		string msgString = "It comes up " + dieRoll;
		InfoMessage("all", myName, msgString);
		ConsoleMessage(ENT_CURRENTPLAYER, "You rolled " + dieRoll + " on your " + nSidesText + " sided die.");
	}

	// check_can_vote
	void Commands_OnCheckCanVote(CBaseEntity@ player = null)
	{
		bool exitSub = false;

		int voteDelay = Int(ScriptVarOf(player, "VOTE_DISABLED"));

		if (voteDelay != 0)
		{
			PlayerMessageYellow(player, "VOTE SYSTEM: You cannot start another vote so soon.");
			ConsoleMessage(player, "You cannot start another vote so soon.");
			exitSub = true;
		}
		if (exitSub)
			return;

		CAN_VOTE = true;
	}

	// loop_get_points
	void Commands_OnLoopGetPoints()
	{
		int curIdx = loopIteration;
		string curPlayer = GetToken("PLAYER_LIST", curIdx);
		float playerStat = Float(ScriptVarOf(curPlayer, "PLR_TOTAL_DMG")); // newfunc in player_main/game_master +1000 for heal/iceshield -1000 for death
		float playerSubStat = Float(ScriptVarOf(curPlayer, "PLR_DMG")); // fraction points
		playerSubStat *= 0.001f;
		playerStat += playerSubStat;
		POINTS_TNLIST = TokenAdd(POINTS_TNLIST, NameOf(curPlayer));
		POINTS_TPLIST = TokenAdd(POINTS_TPLIST, Text(playerStat));
	}

	// loop_sort_points
	void Commands_OnLoopSortPoints()
	{
		int curIdx = loopIteration;
		TEST_PLR = curIdx;
		HIGH_IDX = false;
		HIGH_SCORE = false;
		int count = GetTokenCount(POINTS_TPLIST);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLoopFindHighest();
		}
		loopIteration = outerIteration;
		POINTS_PLIST = TokenAdd(POINTS_PLIST, GetToken(POINTS_TPLIST, (HIGH_IDX ? 1 : 0)));
		POINTS_NLIST = TokenAdd(POINTS_NLIST, GetToken(POINTS_TNLIST, (HIGH_IDX ? 1 : 0)));
		POINTS_TPLIST = TokenRemove(POINTS_TPLIST, (HIGH_IDX ? 1 : 0));
		POINTS_TNLIST = TokenRemove(POINTS_TNLIST, (HIGH_IDX ? 1 : 0));
	}

	// loop_find_highest
	void Commands_OnLoopFindHighest()
	{
		int curIdx = loopIteration;
		string curScoreText = GetToken(POINTS_TPLIST, curIdx);
		int curScore = Int(curScoreText);
		// dbg loop_find_highest CUR_IDX  $get_token(POINTS_TNLIST,CUR_IDX) is CUR_SCORE vs HIGH_SCORE
		if (curScore > (HIGH_SCORE ? 1 : 0))
		{
			HIGH_SCORE = curScore != 0;
			HIGH_IDX = curIdx != 0;
		}
	}

	// loop_show_points
	void Commands_OnLoopShowPoints()
	{
		int curIdx = loopIteration;
		string curN = GetToken(POINTS_NLIST, curIdx);
		float curP = Float(GetToken(POINTS_PLIST, curIdx));
		curP *= 1000.0f;
		string outMsg = curN;
		outMsg = outMsg + " has " + int(curP) + " damage points";
		ConsoleMessage(CALLING_PLAYER, outMsg);
		// infomsg CALLING_PLAYER " " OUT_MSG
		PlayerMessageGreen(CALLING_PLAYER, outMsg);
		TIP_TEXT = TIP_TEXT + outMsg + " |";
	}

	// do_list_points
	void Commands_OnDoListPoints()
	{
		SetVar("PLAYER_LIST", GetActivePlayers());
		POINTS_TNLIST = "";
		POINTS_TPLIST = "";
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLoopGetPoints();
		}

		// dbg list_points - POINTS_TPLIST POINTS_TNLIST
		POINTS_NLIST = "";
		POINTS_PLIST = "";
		count = GetTokenCount(POINTS_TPLIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLoopSortPoints();
		}
		ConsoleMessage(CALLING_PLAYER, "Damage Point Listings:");
		PlayerMessageGreen(CALLING_PLAYER, "Damage Point Listings:");
		TIP_TEXT = "";
		count = GetTokenCount(POINTS_NLIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLoopShowPoints();
		}
		ConsoleMessage(CALLING_PLAYER, "Damage points are acquire by harming monsters and aiding allies");
		ConsoleMessage(CALLING_PLAYER, "The player with the highest dmg point score has contributed the most to your victory");
		HelpTip(CALLING_PLAYER, "generic", "Damage Point Listings", TIP_TEXT);
	}

	// do_list_resists
	void Commands_OnDoListResists()
	{
		RESIST_NAMES = ScriptVarOf(CALLING_PLAYER, "PLR_RESIST_ELEMENTS");
		RESIST_VALUES = ScriptVarOf(CALLING_PLAYER, "PLR_RESIST_VALUES");
		ConsoleMessage(CALLING_PLAYER, "Resistance ratios (lower = more resistant, 1.0 = normal, 0.0 = immune)");
		TIP_TEXT = "";
		int count = GetTokenCount(RESIST_NAMES);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnListResistLoop();
		}
		float stunValue = DamageTakenOf(CALLING_PLAYER, "stun") * 100.0f;
		stunValue = int(100.0f - stunValue);
		stunValue = Float(Text(stunValue) + "%");
		TIP_TEXT = TIP_TEXT + "Stun = " + Text(stunValue) + " ||";
		int darkLevel = Int(ScriptVarOf(CALLING_PLAYER, "PLR_DARK_LEVEL"));
		TIP_TEXT = TIP_TEXT + "Darkness Level = " + darkLevel + " |";
		HelpTip(CALLING_PLAYER, "generic", "Resistance Listings", TIP_TEXT);
	}

	// list_resist_loop
	void Commands_OnListResistLoop()
	{
		int curIdx = loopIteration;
		ConsoleMessage(CALLING_PLAYER, GetToken(RESIST_NAMES, curIdx) + " = " + GetToken(RESIST_VALUES, curIdx));

		float resistVal = Float(GetToken(RESIST_VALUES, curIdx));
		resistVal *= 100.0f;
		float outVal = 100.0f - resistVal;
		outVal = int(outVal);
		outVal = Float(Text(outVal) + "%");
		TIP_TEXT = TIP_TEXT + GetToken(RESIST_NAMES, curIdx) + " = " + Text(outVal) + " |";
	}

	// do_crest
	// <caller>
	void Commands_OnDoCrest(CBaseEntity@ caller = null)
	{
		CREST_SELECTION = OnFuncGuildsLeading(caller);

		if (CREST_SELECTION != "0")
			CreateNpc("crest_dealer", Vector3(10000, 10000, 10000), @caller, CREST_SELECTION);
	}

	// func_guilds_leading
	// <playerId>
	string Commands_OnFuncGuildsLeading(CBaseEntity@ player = null)
	{
		string result = "";

		LEADING_GUILDS = "0";
		string steamId = SteamIdOf(player);

		int count = GetGlobalArrayCount("ARRAY_CRESTS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLoopGuildsLeading(steamId);
		}

		result = "";
		result = AppendResult(result, LEADING_GUILDS);
		return result;
	}

	// loop_guilds_leading
	// <callerSteamId>
	void Commands_OnLoopGuildsLeading(string callerSteamId = "")
	{
		string leaders = GetGlobalArray("ARRAY_CREST_OWNERS", Text(loopIteration));

		if (Contains(leaders, callerSteamId))
		{
			if (LEADING_GUILDS == "0")
				LEADING_GUILDS = GetGlobalArray("ARRAY_CRESTS", Text(loopIteration));
			else
				LEADING_GUILDS = TokenAdd(LEADING_GUILDS, GetGlobalArray("ARRAY_CRESTS", Text(loopIteration)));
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_playercmd
	void OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "")
	{
		Devcmds_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); // developer/devcmds
		Commands_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2);
	}

	void OnGamePrecache() { Commands_OnGamePrecache(); } // game_precache
	void OnDevPrecache() { Commands_OnDevPrecache(); } // dev_precache
	void OnResetTimesetDelay() { Commands_OnResetTimesetDelay(); } // reset_timeset_delay
	void OnResetWeathersetDelay() { Commands_OnResetWeathersetDelay(); } // reset_weatherset_delay
	void OnGiveTimestamp() { Commands_OnGiveTimestamp(); } // give_timestamp
	void OnSetTime(float hour = 0.0f, float minute = 0.0f) { Commands_OnSetTime(hour, minute); } // set_time
	void OnRollDie(string sides = "") { Commands_OnRollDie(sides); } // roll_die
	void OnCheckCanVote(CBaseEntity@ player = null) { Commands_OnCheckCanVote(player); } // check_can_vote
	void OnLoopGetPoints() { Commands_OnLoopGetPoints(); } // loop_get_points
	void OnLoopSortPoints() { Commands_OnLoopSortPoints(); } // loop_sort_points
	void OnLoopFindHighest() { Commands_OnLoopFindHighest(); } // loop_find_highest
	void OnLoopShowPoints() { Commands_OnLoopShowPoints(); } // loop_show_points
	void OnDoListPoints() { Commands_OnDoListPoints(); } // do_list_points
	void OnDoListResists() { Commands_OnDoListResists(); } // do_list_resists
	void OnListResistLoop() { Commands_OnListResistLoop(); } // list_resist_loop
	void OnDoCrest(CBaseEntity@ caller = null) { Commands_OnDoCrest(caller); } // do_crest
	string OnFuncGuildsLeading(CBaseEntity@ player = null) { return Commands_OnFuncGuildsLeading(player); } // func_guilds_leading
	void OnLoopGuildsLeading(string callerSteamId = "") { Commands_OnLoopGuildsLeading(callerSteamId); } // loop_guilds_leading
	void OnFreqWeather() {} // FREQ_WEATHER
	void OnTimeGetseconds() {} // time_getseconds

	// This file's events and timers by their .script names
	bool Commands_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_can_vote") { OnCheckCanVote(EntityParam(params, 0)); return true; }
		if (name == "dev_precache") { OnDevPrecache(); return true; }
		if (name == "do_crest") { OnDoCrest(EntityParam(params, 0)); return true; }
		if (name == "do_list_points") { OnDoListPoints(); return true; }
		if (name == "do_list_resists") { OnDoListResists(); return true; }
		if (name == "func_guilds_leading") { Return(OnFuncGuildsLeading(EntityParam(params, 0))); return true; }
		if (name == "game_playercmd") { OnGamePlayercmd(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "give_timestamp") { OnGiveTimestamp(); return true; }
		if (name == "list_resist_loop") { OnListResistLoop(); return true; }
		if (name == "loop_find_highest") { OnLoopFindHighest(); return true; }
		if (name == "loop_get_points") { OnLoopGetPoints(); return true; }
		if (name == "loop_guilds_leading") { OnLoopGuildsLeading(Param(params, 0)); return true; }
		if (name == "loop_show_points") { OnLoopShowPoints(); return true; }
		if (name == "loop_sort_points") { OnLoopSortPoints(); return true; }
		if (name == "reset_timeset_delay") { OnResetTimesetDelay(); return true; }
		if (name == "reset_weatherset_delay") { OnResetWeathersetDelay(); return true; }
		if (name == "roll_die") { OnRollDie(Param(params, 0)); return true; }
		if (name == "set_time") { OnSetTime(Float(Param(params, 0)), Float(Param(params, 1))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/server/commands"]
shared class CommandsScript : DevcmdsScript, Commands
{
	// Variables declared by included files, with the value they start with in this script
	CommandsScript()
	{
		FREQ_WEATHER = 10.0f;
		WEATHER_SPRITE = "rain.spr";
		SPRITE_SPLASH = "rain_splash.spr";
		SPRITE_MIST = "rain_mist.spr";
		SPRITE_RIPPLE = "rain_ripple.spr";
		SOUND_RAIN = "weather/rain.wav";
		SCRIPT_SFX1 = "effects/sfx_lightning";
		LTNG_SND = "weather/Storm_exclamation.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rain.spr");
		Precache("rain_splash.spr");
		Precache("rain_mist.spr");
		Precache("rain_ripple.spr");
		Precache("snow1.spr");
		Precache("char_breath.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Commands_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Commands_DispatchEvent(name, params)
			|| DevcmdsScript::DispatchEvent(name, params);
	}
}
