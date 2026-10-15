#pragma context server

// Converted from world/server/player_vote.script by msc_transpiler.
// Includes functionality relating to players attempting to vote via console or chat
// Player (chat or console) votes:
// votemap
// votelock
// votekick
// voteban
// ms_admin_contact - e-mail contact for kick/banned players
// msvote_map_type - all|root|nonfn - all legit maps|root towns only|all+illegit (def: all)
// msvote_farm_all_day - 0|1 - disable|enable voting for current map
// msvote_pvp_enable - 1|0 - enable|disable voting for PvP
// msvote_map_enable - 1|0 - enable|disable map votes
// msvote_kick_enable - 1|0 - enable|disable kick votes
// msvote_ban_enable - 1|0 - enable|disable ban votes
// msvote_ban_time - Amount of time a voteban bans a player (def:60 minutes)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerVote
{
	// Variables (an unset .script variable reads as its own name)
	int MAP_VOTE_DELAY = 0;
	bool CAN_VOTE = false;
	float CUSTOM_COUNT = 0.0f;
	CBaseEntity@ L_VOTE_CALLER = null;

	// unnamed block (first think)
	void PlayerVote_FirstThink()
	{
		MAP_VOTE_DELAY = 20;
	}

	// game_playercmd
	void PlayerVote_OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "")
	{
		string voteParam1 = command;
		string voteParam2 = argument;
		string voteParam3 = argument2;
		string voteParam4 = voteOption;
		string voteParam5 = voteOption2;
		if (voteParam1 == "say_text")
		{
			voteParam1 = argument2;
			voteParam2 = voteOption;
			voteParam3 = voteOption2;
			voteParam4 = voteOption3;
			voteParam5 = voteOption4;
		}

		if (StartsWith(voteParam1, "vote"))
		{
			// dbg check_vote_options VOTE_PARAM1 VOTE_PARAM2 VOTE_PARAM3 VOTE_PARAM4 VOTE_PARAM5 VOTE_PARAM6 VOTE_PARAM7
			OnCheckVoteOptions(voteParam1, voteParam2);
		}
	}

	// check_vote_options
	void PlayerVote_OnCheckVoteOptions(string voteType = "", string mapName = "")
	{
		string outMsg = "OUT_MSG";
		bool exitSub = false;

		CAN_VOTE = false;
		OnCheckCanVote(EntityOf(ENT_CURRENTPLAYER)); // Sets CAN_VOTE to 1 if some checks are passed
		if (!CAN_VOTE)
			return;

		if (voteType == "votemap")
		{
			int allowMapvote = Int(Eval("game.cvar.msvote_map_enable"));
			if (allowMapvote == 0)
			{
				outMsg = "VOTEMAP: This server does not allow map votes.";
				ConsoleMessage(ENT_CURRENTPLAYER, outMsg);
				PlayerMessageDark(ENT_CURRENTPLAYER, outMsg);
			}
			if (allowMapvote != 0)
			{
				string mapToVote = mapName;
				OnPlayerVotemap(EntityOf(ENT_CURRENTPLAYER), mapToVote);
			}
		}

		if (voteType == "votepvp")
		{
			int allowPvpvote = Int(Eval("game.cvar.msvote_pvp_enable"));
			if (allowPvpvote == 0)
			{
				outMsg = "VOTEPVP: This server does not allow PVP votes.";
				ConsoleMessage(ENT_CURRENTPLAYER, outMsg);
				PlayerMessageDark(ENT_CURRENTPLAYER, outMsg);
			}
			if (allowPvpvote != 0)
			{
				if (PlayerCount() < 2 && !Truthy(GetVar("G_DEVELOPER_MODE")))
				{
					outMsg = "VOTEPVP: Requires at least 2 players to vote for PVP.";
					ConsoleMessage(ENT_CURRENTPLAYER, outMsg);
					PlayerMessageDark(ENT_CURRENTPLAYER, outMsg);
					exitSub = true;
				}
				if (!exitSub)
					OnPlayerVotepvp(EntityOf(ENT_CURRENTPLAYER));
			}
		}

		// if ( PARAM1 equals 'votekick' )
		// {
		// if ( game.players < 3 )
		// {
		// if !G_DEVELOPER_MODE
		// dplayermessage ent_currentplayer VOTEKICK: Need at least three players to start a kick vote
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		// local ALLOW_KICKVOTE game.cvar.msvote_kick_enable
		// if ( !ALLOW_KICKVOTE )
		// {
		// local OUT_MSG "VOTEKICK: This server does not allow kickvotes."
		// consolemsg ent_currentplayer OUT_MSG
		// dplayermessage ent_currentplayer OUT_MSG
		// }
		// if ALLOW_KICKVOTE
		// local L_PLAYER_NAME PARAM2
		// if ( L_PLAYER_NAME startswith 'PARAM' ) local L_PLAYER_NAME 'PARAMETER' //weirdness voting from console
		// local L_CALLER $get(ent_currentplayer,id)
		// callevent player_votekick L_PLAYER_NAME L_CALLER
		// }
		// if ( PARAM1 equals 'voteban' )
		// {
		// if ( game.players < 3 )
		// {
		// if !G_DEVELOPER_MODE
		// dplayermessage ent_currentplayer VOTEBAN: Need at least three players to start a ban vote
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		// local ALLOW_BANVOTE game.cvar.msvote_ban_enable
		// if ( !ALLOW_BANVOTE ) consolemsg ent_currentplayer VOTEBAN: This server does not allow ban votes.
		// if ALLOW_BANVOTE
		// local L_PLAYER_NAME PARAM2
		// if ( L_PLAYER_NAME startswith 'PARAM' ) local L_PLAYER_NAME 'PARAMETER' //weirdness voting from console
		// local L_CALLER $get(ent_currentplayer,id)
		// callevent player_voteban L_PLAYER_NAME L_CALLER
		// }
		if (voteType == "votelock")
		{
			if (Truthy(GetVar("G_SERVER_LOCKED")))
			{
				PlayerMessageDark(ENT_CURRENTPLAYER, "Server is already vote locked. ( Password: " + Eval("game.cvar.sv_password") + " )");
				ConsoleMessage(ENT_CURRENTPLAYER, "Server is already vote locked. ( Password: " + Eval("game.cvar.sv_password") + " )");

				exitSub = true;
			}
			if (!exitSub)
			{
				if (!Truthy(Eval("game.cvar.msvote_lock_enable")))
				{
					PlayerMessageDark(ENT_CURRENTPLAYER, "This server does not allow votes to lock the server.");
					ConsoleMessage(ENT_CURRENTPLAYER, "This server does not allow votes to lock the server.");
					exitSub = true;
				}
				if (!exitSub)
				{
					if (PlayerCount() < 3 && !Truthy(GetVar("G_DEVELOPER_MODE")))
					{
						PlayerMessageDark(ENT_CURRENTPLAYER, "Need at least three players to start a vote to lock the server.");
						ConsoleMessage(ENT_CURRENTPLAYER, "Need at least three players to start a vote to lock the server.");
						exitSub = true;
					}
					if (!exitSub)
						OnPlayerVotelock(EntityOf(ENT_CURRENTPLAYER));
				}
			}
		}
	}

	// player_votemap
	// Map voting (standard player option)
	// PARAM3 = fromconsole?
	void PlayerVote_OnPlayerVotemap(CBaseEntity@ caller = null, string mapName = "")
	{
		bool exitSub = false;
		bool noGaunletMessage = false;

		string mapToVote = ToLowerCase(mapName);
		string voteTypeCvar = Eval("game.cvar.msvote_map_type");

		int voteBusy = Int(ScriptVarOf(GetVar("GAME_MASTER"), "VOTE_BUSY"));

		if (voteBusy != 0)
		{
			ConsoleMessage(caller, "Votemap: Vote system is busy.");
			PlayerMessageRed(caller, "Votemap: Vote system is busy.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (GameTime() < MAP_VOTE_DELAY && !Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			PlayerMessageYellow(caller, "Votemap: You cannot start a map vote for the first " + MAP_VOTE_DELAY + " seconds, except by transition.");
			ConsoleMessage(caller, "Votemap: You cannot start a map vote for the first " + MAP_VOTE_DELAY + " seconds, except by transition.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (StartsWith(mapToVote, "param"))
		{
			PlayerMessageGreen(caller, "Votemap: You can vote for specific maps by typing votemap [mapname] in main chat.");
			PlayerMessageGreen(caller, "Check your console (~) for a list of maps not connected to the world.");

			ConsoleMessage(caller, "Votemap: You can vote for specific maps by typing votemap [mapname] in main chat.");
			ConsoleMessage(caller, "Here's a list of maps you may vote for that are not otherwise reachable:");

			CUSTOM_COUNT = 0.0f;
			ConsoleMessage(caller, "=========== DISCONNECTED MAPS ===========");
			CallEventDelayed(0.1f, "list_custom_maps");
			exitSub = true;
		}
		if (exitSub)
			return;

		bool legalFnMap = false;

		string searchSet = "MAPS_FN1";
		int searchIdx = FindToken(searchSet, mapToVote);
		if (searchIdx > -1 && GetToken(searchSet, searchIdx) == mapToVote)
			legalFnMap = true;
		searchSet = "MAPS_FN2";
		searchIdx = FindToken(searchSet, mapToVote);
		if (searchIdx > -1 && GetToken(searchSet, searchIdx) == mapToVote)
			legalFnMap = true;
		searchSet = "MAPS_FN3";
		searchIdx = FindToken(searchSet, mapToVote);
		if (searchIdx > -1 && GetToken(searchSet, searchIdx) == mapToVote)
			legalFnMap = true;
		searchSet = "MAPS_FN4";
		searchIdx = FindToken(searchSet, mapToVote);
		if (searchIdx > -1 && GetToken(searchSet, searchIdx) == mapToVote)
			legalFnMap = true;

		if (Truthy(Eval("game.central")) && FindToken(GetVar("G_NOT_ON_FN"), mapToVote) > -1)
		{
			legalFnMap = false;
			PlayerMessageDark(caller, "Votemap: " + mapToVote + " is a special utility map that cannot be used on [FN]");
			ConsoleMessage(caller, "Votemap: " + mapToVote + " is a special utility map that cannot be used on [FN]");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (voteTypeCvar == "root")
		{
			bool allowVote = false;
			if (mapToVote == "edana")
				allowVote = true;
			if (mapToVote == "deralia")
				allowVote = true;
			if (mapToVote == "helena")
				allowVote = true;
			if (FindToken(GetVar("MAPS_UNCONNECTED1"), mapToVote) > -1)
				allowVote = true;
			// add when needed:
			// if ( $get_find_token(MAPS_UNCONNECTED2,L_MAP_TO_VOTE) > -1 ) local ALLOW_VOTE 1
			if (!allowVote)
			{
				PlayerMessageYellow(caller, "Votemap: You may only vote for root towns (edana, deralia, helena) and disconnected maps on this server.");
				ConsoleMessage(caller, "You may only vote for root towns (edana, deralia, helena) and disconnected maps on this server.");
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (FindToken(GetVar("MAPS_HIDDEN"), mapToVote) > -1)
		{
			if (ToLowerCase(MapName()) != ToLowerCase(mapToVote)) // voting to same map is ok since you already found it.
			{
				PlayerMessageYellow(caller, "Votemap: " + mapToVote + " is a hidden map, you must find the entrance.");
				ConsoleMessage(caller, mapToVote + " is a hidden map, you must find the entrance.");
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (FindToken(GetVar("MAPS_MAZE"), mapToVote) > -1)
		{
			if (GetQuestData(caller, "m") == mapToVote)
			{
				noGaunletMessage = true;
				PlayerMessageGreen(caller, "Votemap: You can vote for this hidden map as you still qualify.");
			}
			else
			{
				PlayerMessageYellow(caller, "Votemap: " + mapToVote + " is hidden within a maze, you must navigate the maze to find its entrance.");
				ConsoleMessage(caller, mapToVote + " is hidden within a maze, you must navigate the maze to find its entrance.");
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (FindToken(GetVar("MAPS_GAUNTLET"), mapToVote) > -1)
		{
			if (GetQuestData(caller, "m") == mapToVote)
			{
				if (!noGaunletMessage && GetQuestData(caller, "mv") == mapToVote)
				{
					// last validated map, and his destination map match gauntlet, so let him vote for it
					PlayerMessageGreen(caller, "Votemap: You can vote for this gauntlet map as you still qualify.");
				}
			}
			else
			{
				PlayerMessageYellow(caller, "Votemap: " + mapToVote + " is part of a gauntlet series, you must begin at the start of the series.");
				ConsoleMessage(caller, "Votemap: " + mapToVote + " is part of a gauntlet series, you must begin at the start of the series.");
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (!MapExists(mapToVote))
		{
			PlayerMessageYellow(caller, "Votemap: " + mapToVote + " is not found on this server.");
			ConsoleMessage(caller, mapToVote + " is not found on this server.");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (ToLowerCase(MapName()) == mapToVote && !Truthy(Eval("game.cvar.msvote_farm_all_day")))
		{
			PlayerMessageYellow(caller, "Votemap: You cannot vote for the map you are currently on.");
			ConsoleMessage(caller, "You cannot vote for the map you are currently on.");
			exitSub = true;
		}
		if (exitSub)
			return;

		string voteTitle = "Change to " + mapToVote + "?";

		string options = "Yes!:" + mapToVote + ";No!:0"; // Im kinda shocked that this works. It concatenates each value to each other in L_OPTIONS

		CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votemap", options, voteTitle, "Voting begins now!", 0);
	}

	// list_custom_maps
	void PlayerVote_OnListCustomMaps()
	{
		bool exitSub = false;
		float totalMaps = GetTokenCount(GetVar("MAPS_UNCONNECTED1")) - 1.0f;
		if (CUSTOM_COUNT == totalMaps && Float(GetVar("MAPS_UNCONNECTEDS")) > 1.0f)
		{
			CUSTOM_COUNT = 0.0f;
			CallEventDelayed(0.1f, "list_custom_maps2");
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!(CUSTOM_COUNT <= totalMaps))
			return;
		string custMap = GetToken(GetVar("MAPS_UNCONNECTED1"), int(CUSTOM_COUNT));
		if (MapExists(custMap))
			ConsoleMessage(L_VOTE_CALLER, custMap);
		// if ( CUSTOM_COUNT == TOTAL_MAPS ) consolemsg L_VOTE_CALLER ===================================
		CUSTOM_COUNT += 1.0f;
		CallEventDelayed(0.1f, "list_custom_maps");
	}

	// player_votepvp
	void PlayerVote_OnPlayerVotepvp(CBaseEntity@ caller = null)
	{
		bool exitSub = false;
		string title;
		string options;
		string descript;

		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "VOTE_BUSY")))
		{
			ConsoleMessage(caller, "votepvp - Vote system is busy.");
			PlayerMessageRed(caller, "votepvp - Vote system is busy.");
			exitSub = true;
		}
		if (exitSub)
			return;

		@L_VOTE_CALLER = caller;

		if (!IsPvp())
		{
			title = "ACTIVATE PVP MODE";
			options = "Yes!:1;No!:0";
			descript = NameOf(L_VOTE_CALLER) + " has started a vote to enable player vs player combat!";
		}
		else
		{
			title = "DEACTIVATE PVP MODE";
			options = "Yes!:0;No!:1";
			descript = NameOf(L_VOTE_CALLER) + " has started a vote to end player vs player combat.";
		}

		CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votepvp", options, title, descript, 0); // <caller_event> <token_option:data> <title> [descript] [silent:0|1]
	}

	// player_votelock
	// <caller>
	void PlayerVote_OnPlayerVotelock(CBaseEntity@ caller = null)
	{
		string msg = "L_MSG";

		if (ActivePlayerCount() < 3)
		{
			msg = "Votelock not allowed with less than 3 players on the server!";
			ConsoleMessage(caller, msg);
			PlayerMessageRed(caller, msg);
			return;
		}

		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "VOTE_BUSY")))
		{
			msg = "Vote system is busy.";
			ConsoleMessage(caller, msg);
			PlayerMessageRed(caller, msg);
			return;
		}

		// gm_create_vote //<caller_event> <token_option:data> <title> [descript] [silent:0|1]
		string title = "Lock the server?";
		string desc = NameOf(caller) + " has started a vote to lock the server.";
		CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votelock", "Yes!:1;No!:0", title, desc, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "") { PlayerVote_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); } // game_playercmd
	void OnCheckVoteOptions(string voteType = "", string mapName = "") { PlayerVote_OnCheckVoteOptions(voteType, mapName); } // check_vote_options
	void OnPlayerVotemap(CBaseEntity@ caller = null, string mapName = "") { PlayerVote_OnPlayerVotemap(caller, mapName); } // player_votemap
	void OnListCustomMaps() { PlayerVote_OnListCustomMaps(); } // list_custom_maps
	void OnPlayerVotepvp(CBaseEntity@ caller = null) { PlayerVote_OnPlayerVotepvp(caller); } // player_votepvp
	void OnPlayerVotelock(CBaseEntity@ caller = null) { PlayerVote_OnPlayerVotelock(caller); } // player_votelock
	void OnCheckCanVote(CBaseEntity@ player = null) {} // check_can_vote

	// This file's events and timers by their .script names
	bool PlayerVote_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_vote_options") { OnCheckVoteOptions(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_playercmd") { OnGamePlayercmd(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "list_custom_maps") { OnListCustomMaps(); return true; }
		if (name == "player_votelock") { OnPlayerVotelock(EntityParam(params, 0)); return true; }
		if (name == "player_votemap") { OnPlayerVotemap(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "player_votepvp") { OnPlayerVotepvp(EntityParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/server/player_vote"]
shared class PlayerVoteScript : ScriptEntity, PlayerVote
{
	// Variables every script that includes this file declares
	string BETA_TIMESTAMP = "BETA_TIMESTAMP";
	CBaseEntity@ CALLING_PLAYER = null;
	string CREST_SELECTION = "CREST_SELECTION";
	float FREQ_WEATHER = 0.0f;
	bool HIGH_IDX = false;
	bool HIGH_SCORE = false;
	string LEADING_GUILDS = "LEADING_GUILDS";
	float LISTMAPS_COUNT = 0.0f;
	string LISTMAPS_MSG_EPC = "LISTMAPS_MSG_EPC";
	string LISTMAPS_MSG_HAR = "LISTMAPS_MSG_HAR";
	string LISTMAPS_MSG_LOW = "LISTMAPS_MSG_LOW";
	string LISTMAPS_MSG_MED = "LISTMAPS_MSG_MED";
	string LISTMAPS_MSG_VHR = "LISTMAPS_MSG_VHR";
	string LISTMAPS_START = "LISTMAPS_START";
	string LISTMAPS_STOP = "LISTMAPS_STOP";
	string LISTMAPS_TARGET = "LISTMAPS_TARGET";
	string LTNG_SND = "LTNG_SND";
	string POINTS_NLIST = "POINTS_NLIST";
	string POINTS_PLIST = "POINTS_PLIST";
	string POINTS_TNLIST = "POINTS_TNLIST";
	string POINTS_TPLIST = "POINTS_TPLIST";
	string RESIST_NAMES = "RESIST_NAMES";
	string RESIST_VALUES = "RESIST_VALUES";
	string SCRIPT_SFX1 = "SCRIPT_SFX1";
	string SOUND_RAIN = "SOUND_RAIN";
	string SPRITE_MIST = "SPRITE_MIST";
	string SPRITE_RIPPLE = "SPRITE_RIPPLE";
	string SPRITE_SPLASH = "SPRITE_SPLASH";
	string TEST_PLR = "TEST_PLR";
	bool TIMESET_DELAY = false;
	int TIME_UPDATE_INTERVAL = 0;
	string TIP_TEXT = "TIP_TEXT";
	bool WARNED_DRIDJE = false;
	bool WEATHERSET_DELAY = false;
	string WEATHER_SPRITE = "WEATHER_SPRITE";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerVote_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerVote_DispatchEvent(name, params);
	}
}
