#pragma context server

// Converted from game_master/vote_generic.script by msc_transpiler.
// Handles voting system on the game master.
// -Votes can inlcude votemap change, votekick, voteban, vote lock...

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class VoteGeneric
{
	// Variables (an unset .script variable reads as its own name)
	bool VOTE_BUSY = false;
	string VOTE_TALLY = "VOTE_TALLY";
	string VOTE_EVENT = "VOTE_EVENT";
	string VOTE_OPTIONS = "VOTE_OPTIONS";
	string VOTE_TITLE = "VOTE_TITLE";
	string VOTE_DESC = "VOTE_DESC";
	string VOTE_SILENT = "VOTE_SILENT";
	float VOTES_CASTED = 0.0f;
	int TOTAL_BALLOTS = 0;
	float VOTES_REMOVED = 0.0f;
	string VOTE_WINNERS = "VOTE_WINNERS";
	int VOTE_WINNER_COUNT = 0;
	float GM_COUNT_DOWN_TO = 0.0f;
	string GM_COUNT_MESSAGE = "GM_COUNT_MESSAGE";
	string GM_COUNT_DOWN_EVENT = "GM_COUNT_DOWN_EVENT";
	string L_SV_LOCK_PASSWORD = "L_SV_LOCK_PASSWORD";
	string GM_SKIP_VOTE_ID = "GM_SKIP_VOTE_ID";
	float YES_VOTES = 0.0f;
	float NO_VOTES = 0.0f;

	// unnamed block (first think)
	void VoteGeneric_FirstThink()
	{
		ArrayCreate("A_VOTERS"); // Array will be populated with list of players that can vote in the current ballot
	}

	// gm_create_vote
	// <caller_event> <token_option:data> <title> [descript] [silent:0|1] //Calls back to the caller_event with the index of the option voted for.
	void VoteGeneric_OnGmCreateVote(string callerEvent = "", string voteOptions = "", string title = "", string description = "", string silent = "")
	{
		// If votes tie, the last menu option will be selected as the "winner", assuning it is equivalent to a "no" option. For example, in a yes/no vote, no will be picked if it ties, because it is the last option in the list of options.
		// If all players vote, the voting will end early and and vote tally will be counted.
		if (!VOTE_BUSY && PlayerCount() > 0) // If not already voting
		{
			VOTE_BUSY = true;
			VOTE_TALLY = "0"; // Reset vote tally options

			// Required params
			VOTE_EVENT = callerEvent;
			VOTE_OPTIONS = voteOptions;
			VOTE_TITLE = title;

			// Optional
			VOTE_DESC = description;
			VOTE_SILENT = silent;

			if (VOTE_DESC.isEmpty())
				VOTE_DESC = " ";
			if (VOTE_SILENT.isEmpty())
				VOTE_SILENT = "0";

			CallExternal("players", "ext_set_vote_delay", 20.0f);
			OnGmSendVote();
		}
	}

	// gm_send_vote
	void VoteGeneric_OnGmSendVote()
	{
		SetName("VOTE!");

		InfoMessage("all", VOTE_TITLE, VOTE_DESC);

		OnGetVoters(); // Populates array with list of potential voters
		VOTES_CASTED = 0.0f; // Track number of votes casted
		TOTAL_BALLOTS = GetArrayCount("A_VOTERS");

		CallEventDelayed(0.1f, "gm_send_ballots"); // Gets player list and sends the menu
		CallEventDelayed(5.1f, "gm_send_ballots"); // Send menu again, just in case player closed it.
		CallEventDelayed(20.0f, "gm_tally_votes"); // Default expire timer for voting. Will also expire after enough people have voted.
	}

	// get_voters
	// Gets all players, filters them, and stores them in an array.
	void VoteGeneric_OnGetVoters()
	{
		ArrayClear("A_VOTERS");
		LegacyCommand("getplayersarray", "A_VOTERS");

		VOTES_REMOVED = 0.0f;
		int count = GetArrayCount("A_VOTERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGetVotersFilter();
		}
	}

	// get_voters_filter
	// use 'setvard VOTES_REMOVED 0' before using this event
	void VoteGeneric_OnGetVotersFilter()
	{
		float arrayIndex = loopIteration - VOTES_REMOVED; // Index gets offset when players get removed.
		string player = GetArray("A_VOTERS", Text(arrayIndex));
		if (!Truthy(ScriptVarOf(player, "PLR_IN_WORLD")))
			VOTES_REMOVED += 1.0f;
	}

	// gm_send_ballots
	// Gets player list and sends the menu
	void VoteGeneric_OnGmSendBallots()
	{
		if (!VOTE_BUSY)
			return;
		int count = GetArrayCount("A_VOTERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSendMenus();
		}
	}

	// send_menus
	void VoteGeneric_OnSendMenus()
	{
		OpenMenu(GetArray("A_VOTERS", Text(loopIteration))); // Menu is sent from send_menu in the actual game_master
	}

	// game_menu_getoptions
	void VoteGeneric_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (!VOTE_BUSY)
			return;
		int count = GetTokenCount(VOTE_OPTIONS); // Build ballot menu
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmBuildBallot();
		}
	}

	// gm_build_ballot
	// Creates options for voting
	void VoteGeneric_OnGmBuildBallot()
	{
		MenuItem menuItem;

		if (GetTokenCount(VOTE_TALLY) < GetTokenCount(VOTE_OPTIONS)) // Create token for tracking votes
			VOTE_TALLY = TokenAdd(VOTE_TALLY, "0");

		string str = GetToken(VOTE_OPTIONS, loopIteration);
		string option = LegacyFunction("string_upto", str, ":");

		menuItem.title = option;
		menuItem.type = "callback";
		menuItem.data = str;
		menuItem.callback = "gm_gvote_count";
		RegisterMenuItem(menuItem);
	}

	// game_menu_cancel
	// <playerId> //Player does not wish to participate in vote.
	void VoteGeneric_OnGameMenuCancel(CBasePlayer@ player = null)
	{
		int idx = ArrayFind("A_VOTERS", EntityId(player));

		if (!VOTE_BUSY)
			return;
		if (idx == -1)
			return;
		// Remove player from eligible voters
		VOTES_CASTED += 1.0f;

		if (VOTES_CASTED == TOTAL_BALLOTS) // Everyone voted, so accelerate ending the vote.
			OnGmTallyVotes();
	}

	// gm_gvote_count
	// <VoterId> <optionData>
	void VoteGeneric_OnGmGvoteCount(CBasePlayer@ voterId = null, string optionData = "")
	{
		int idx = ArrayFind("A_VOTERS", EntityId(voterId));

		if (!VOTE_BUSY)
			return;
		if (idx == -1)
			return;

		ArrayRemoveAt("A_VOTERS", idx); // Remove player from eligible voters
		VOTES_CASTED += 1.0f; // Adds another vote casted to the counter

		string voteTitle = LegacyFunction("string_upto", optionData, ":");

		int optionIdx = FindToken(VOTE_OPTIONS, optionData);
		float votes = Float(GetToken(VOTE_TALLY, optionIdx));
		votes += 1.0f;

		VOTE_TALLY = TokenSet(VOTE_TALLY, optionIdx, Text(int(votes)));

		if (!Truthy(VOTE_SILENT))
		{
			string str = NameOf(voterId) + " votes " + voteTitle;
			MessageAll("green", str);
		}

		if (VOTES_CASTED == TOTAL_BALLOTS) // Everyone voted, so accelerate ending the vote.
			OnGmTallyVotes();
	}

	// gm_tally_votes
	void VoteGeneric_OnGmTallyVotes()
	{
		if (!VOTE_BUSY)
			return;
		VOTE_BUSY = false;

		string title = "The people have spoken!";
		string winner = OnFuncGetVoteWinner(); // Returns index of the VOTE_OPTIONS winner

		string voteTitle = LegacyFunction("string_upto", winner, ":");
		string voteData = LegacyFunction("string_from", winner, ":");

		InfoMessage("all", title, voteTitle);

		CallEventOrDelay(VOTE_EVENT, voteTitle, voteData);
	}

	// func_get_vote_winner
	string VoteGeneric_OnFuncGetVoteWinner()
	{
		bool chooseLast = false;
		string result = "";

		VOTE_WINNERS = "none";
		VOTE_WINNER_COUNT = -1; // Number of votes cast for this/these options.
		int count = GetTokenCount(VOTE_TALLY);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGetVoteWinner();
		}

		int winnerAmt = GetTokenCount(VOTE_WINNERS);
		int optionAmt = GetTokenCount(VOTE_OPTIONS);

		if (VOTE_WINNERS == "none") // Choose last option if there are no votes or if there is a tie amongst all options. Equivalent of choosing "no"
			chooseLast = true;
		else if (winnerAmt == optionAmt)
			chooseLast = true;

		if (chooseLast)
		{
			VOTE_WINNERS = int(optionAmt - 1.0f); // Gets index of last vote option
		}

		if (winnerAmt > 1) // If there is a tie, choose a random winner
			VOTE_WINNERS = GetToken(VOTE_WINNERS, RandomInt(0, int(winnerAmt - 1.0f)));

		result = "";
		result = AppendResult(result, GetToken(VOTE_OPTIONS, Int(VOTE_WINNERS)));
		return result;
	}

	// get_vote_winner
	void VoteGeneric_OnGetVoteWinner()
	{
		string voteCountText = GetToken(VOTE_TALLY, loopIteration);
		int voteCount = Int(voteCountText);
		int optionIdx = loopIteration;

		if (voteCount > VOTE_WINNER_COUNT)
		{
			VOTE_WINNERS = optionIdx; // sets option title to vote winner since this one has new most votes
			VOTE_WINNER_COUNT = voteCount;
		}
		else if (voteCount == VOTE_WINNER_COUNT)
			VOTE_WINNERS = TokenAdd(VOTE_WINNERS, Text(optionIdx));
	}

	// gm_votemap
	// <optionTitle> <0|mapDestination> //Called once a votemap vote is completed
	void VoteGeneric_OnGmVotemap(string optionTitle = "", string mapDestination = "")
	{
		if (mapDestination != "0")
			OnGmManualMapChange(mapDestination);
	}

	// gm_votepvp
	// <optionTitle> <0|1> //0 for pvp off, 1 for pvp on.
	void VoteGeneric_OnGmVotepvp(string optionTitle = "", float pvpEnabled = 0.0f)
	{
		if (pvpEnabled == 1.0f && !IsPvp())
		{
			InfoMessage("all", "PVP VOTE PASSED", "PvP mode will begin in 10 seconds...");
			GM_COUNT_DOWN_TO = 9.0f;
			GM_COUNT_MESSAGE = "seconds before PvP begins!";
			GM_COUNT_DOWN_EVENT = "gm_pvp";
			CallEventDelayed(1.0f, "gm_count_down");
		}

		if (pvpEnabled == 0.0f && IsPvp())
		{
			InfoMessage("all", "PVP VOTE PASSED", "PvP mode will end in 60 seconds...");
			GM_COUNT_DOWN_TO = 59.0f;
			GM_COUNT_MESSAGE = "seconds before PvP ends...";
			GM_COUNT_DOWN_EVENT = "gm_pvp";
			CallEventDelayed(1.0f, "gm_count_down");
		}
	}

	// gm_pvp
	void VoteGeneric_OnGmPvp()
	{
		if (!IsPvp())
		{
			InfoMessage("all", "PvP MODE IS ACIVE!", "Players may now damage one another.");
			LegacyCommand("setpvp", 1);
		}
		else
		{
			InfoMessage("all", "PvP MODE DEACTIVATED", "Players may no longer damage one another.");
			LegacyCommand("setpvp", 0);
		}
	}

	// gm_votelock
	// <optionTitle> <0|1>
	void VoteGeneric_OnGmVotelock(string optionTitle = "", float lock = 0.0f)
	{
		string msgDesc;

		if (lock == 1.0f)
		{
			// generate random password (5 nums, not real secure, but need something easy to copy-pasta or remember)
			L_SV_LOCK_PASSWORD = Text(RandomInt(0, 9)) + Text(RandomInt(0, 9)) + Text(RandomInt(0, 9)) + Text(RandomInt(0, 9)) + Text(RandomInt(0, 9));

			SetGlobal("G_SERVER_LOCKED", 1);

			ServerCommand("sv_password " + L_SV_LOCK_PASSWORD);

			string clCmdStr = "password " + L_SV_LOCK_PASSWORD;
			ClientCommand("all", clCmdStr);

			msgDesc = "Password is: " + L_SV_LOCK_PASSWORD;
			ConsoleMessage("all", msgDesc);
			msgDesc += "|This has been sent to your console (copy it).|Server will remain locked until enough|people disconnect or map changes.";

			HelpTip("all", "generic", "SERVER HAS BEEN LOCKED", msgDesc);
		}
		else
		{
			string msgTitle = "Vote Lock has failed.";
			msgDesc = " ";
			InfoMessage("all", msgTitle, msgDesc);
		}
	}

	// gm_votekick
	// <target> <caller> - called by sv_admin
	void VoteGeneric_OnGmVotekick(string target = "", string caller = "")
	{
		GM_SKIP_VOTE_ID = target;
		string voteTitle = "KICK: " + NameOf(GM_SKIP_VOTE_ID);
		string voteDesc = NameOf(caller);
		voteDesc = voteDesc + "  has started a kick vote against " + NameOf(GM_SKIP_VOTE_ID);
		InfoMessage("all", voteTitle, voteDesc);
		OnGmYnvote();
	}

	// gm_voteban
	// <target> <caller> - called by sv_admin
	void VoteGeneric_OnGmVoteban(string target = "", string caller = "")
	{
		GM_SKIP_VOTE_ID = target;
		string voteTitle = "BAN: " + NameOf(GM_SKIP_VOTE_ID);
		string voteDesc = NameOf(caller);
		voteDesc = voteDesc + "  has started a ban vote against " + NameOf(GM_SKIP_VOTE_ID);
		OnGmYnvote();
	}

	// gm_got_yes_vote
	void VoteGeneric_OnGmGotYesVote(string player = "")
	{
		VOTES_CASTED += 1.0f;
		YES_VOTES += 1.0f;

		string msgString = NameOf(player) + " votes yes.";
		InfoMessage("all", msgString, " ");
	}

	// gm_got_no_vote
	void VoteGeneric_OnGmGotNoVote(string player = "")
	{
		VOTES_CASTED += 1.0f;
		NO_VOTES += 1.0f;
		string msgString = NameOf(player) + " votes no.";
		InfoMessage("all", msgString, " ");
	}

	// player_left
	void VoteGeneric_OnPlayerLeft(CBaseEntity@ player = null)
	{
		if (Truthy(GetVar("G_SERVER_LOCKED")) && ActivePlayerCount() < 3)
		{
			SetGlobal("G_SERVER_LOCKED", 0);
			string msgDesc = NameOf(player) + " has left the server.";
			InfoMessage("all", "SERVER IS NO LONGER LOCKED", msgDesc);

			string svCmd = "sv_password " + LegacyFunction("quote");
			svCmd += LegacyFunction("quote");
			ServerCommand(svCmd);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGmCreateVote(string callerEvent = "", string voteOptions = "", string title = "", string description = "", string silent = "") { VoteGeneric_OnGmCreateVote(callerEvent, voteOptions, title, description, silent); } // gm_create_vote
	void OnGmSendVote() { VoteGeneric_OnGmSendVote(); } // gm_send_vote
	void OnGetVoters() { VoteGeneric_OnGetVoters(); } // get_voters
	void OnGetVotersFilter() { VoteGeneric_OnGetVotersFilter(); } // get_voters_filter
	void OnGmSendBallots() { VoteGeneric_OnGmSendBallots(); } // gm_send_ballots
	void OnSendMenus() { VoteGeneric_OnSendMenus(); } // send_menus
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { VoteGeneric_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnGmBuildBallot() { VoteGeneric_OnGmBuildBallot(); } // gm_build_ballot
	void OnGameMenuCancel(CBasePlayer@ player = null) { VoteGeneric_OnGameMenuCancel(player); } // game_menu_cancel
	void OnGmGvoteCount(CBasePlayer@ voterId = null, string optionData = "") { VoteGeneric_OnGmGvoteCount(voterId, optionData); } // gm_gvote_count
	void OnGmTallyVotes() { VoteGeneric_OnGmTallyVotes(); } // gm_tally_votes
	string OnFuncGetVoteWinner() { return VoteGeneric_OnFuncGetVoteWinner(); } // func_get_vote_winner
	void OnGetVoteWinner() { VoteGeneric_OnGetVoteWinner(); } // get_vote_winner
	void OnGmVotemap(string optionTitle = "", string mapDestination = "") { VoteGeneric_OnGmVotemap(optionTitle, mapDestination); } // gm_votemap
	void OnGmVotepvp(string optionTitle = "", float pvpEnabled = 0.0f) { VoteGeneric_OnGmVotepvp(optionTitle, pvpEnabled); } // gm_votepvp
	void OnGmPvp() { VoteGeneric_OnGmPvp(); } // gm_pvp
	void OnGmVotelock(string optionTitle = "", float lock = 0.0f) { VoteGeneric_OnGmVotelock(optionTitle, lock); } // gm_votelock
	void OnGmVotekick(string target = "", string caller = "") { VoteGeneric_OnGmVotekick(target, caller); } // gm_votekick
	void OnGmVoteban(string target = "", string caller = "") { VoteGeneric_OnGmVoteban(target, caller); } // gm_voteban
	void OnGmGotYesVote(string player = "") { VoteGeneric_OnGmGotYesVote(player); } // gm_got_yes_vote
	void OnGmGotNoVote(string player = "") { VoteGeneric_OnGmGotNoVote(player); } // gm_got_no_vote
	void OnPlayerLeft(CBaseEntity@ player = null) { VoteGeneric_OnPlayerLeft(player); } // player_left
	void OnVoteEvent() {} // VOTE_EVENT
	void OnGmManualMapChange(string map = "", string spawnPoint = "") {} // gm_manual_map_change
	void OnGmYnvote() {} // gm_ynvote

	// This file's events and timers by their .script names
	bool VoteGeneric_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "func_get_vote_winner") { Return(OnFuncGetVoteWinner()); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "get_vote_winner") { OnGetVoteWinner(); return true; }
		if (name == "get_voters") { OnGetVoters(); return true; }
		if (name == "get_voters_filter") { OnGetVotersFilter(); return true; }
		if (name == "gm_build_ballot") { OnGmBuildBallot(); return true; }
		if (name == "gm_create_vote") { OnGmCreateVote(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "gm_got_no_vote") { OnGmGotNoVote(Param(params, 0)); return true; }
		if (name == "gm_got_yes_vote") { OnGmGotYesVote(Param(params, 0)); return true; }
		if (name == "gm_gvote_count") { OnGmGvoteCount(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "gm_pvp") { OnGmPvp(); return true; }
		if (name == "gm_send_ballots") { OnGmSendBallots(); return true; }
		if (name == "gm_send_vote") { OnGmSendVote(); return true; }
		if (name == "gm_tally_votes") { OnGmTallyVotes(); return true; }
		if (name == "gm_voteban") { OnGmVoteban(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_votekick") { OnGmVotekick(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_votelock") { OnGmVotelock(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "gm_votemap") { OnGmVotemap(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_votepvp") { OnGmVotepvp(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "player_left") { OnPlayerLeft(EntityParam(params, 0)); return true; }
		if (name == "send_menus") { OnSendMenus(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "game_master/vote_generic"]
shared class VoteGenericScript : ScriptEntity, VoteGeneric
{
	// Variables every script that includes this file declares
	int BAGS_PER_PLAYER = 0;
	float BAG_COUNT = 0.0f;
	CBaseEntity@ BY_ID = null;
	string CNPCA_PAR1 = "CNPCA_PAR1";
	Vector3 CNPCA_PAR2 = Vector3();
	string CNPCA_PAR3 = "CNPCA_PAR3";
	float CNPCA_PAR4 = 0.0f;
	float CNPCA_PAR5 = 0.0f;
	float CNPCA_PAR6 = 0.0f;
	string CNPCA_PAR7 = "CNPCA_PAR7";
	string CNPCA_PAR8 = "CNPCA_PAR8";
	string CNPCB_PAR1 = "CNPCB_PAR1";
	string CNPCB_PAR2 = "CNPCB_PAR2";
	string CNPCB_PAR3 = "CNPCB_PAR3";
	CBaseEntity@ CNPCB_PAR4 = null;
	float CNPCB_PAR5 = 0.0f;
	float CNPCB_PAR6 = 0.0f;
	string CNPCB_PAR7 = "CNPCB_PAR7";
	string CNPCB_PAR8 = "CNPCB_PAR8";
	string CNPCC_PAR1 = "CNPCC_PAR1";
	string CNPCC_PAR2 = "CNPCC_PAR2";
	string CNPCC_PAR3 = "CNPCC_PAR3";
	CBaseEntity@ CNPCC_PAR4 = null;
	float CNPCC_PAR5 = 0.0f;
	float CNPCC_PAR6 = 0.0f;
	string CNPCC_PAR7 = "CNPCC_PAR7";
	string CNPCC_PAR8 = "CNPCC_PAR8";
	string CNPCD_PAR1 = "CNPCD_PAR1";
	Vector3 CNPCD_PAR2 = Vector3();
	string CNPCD_PAR3 = "CNPCD_PAR3";
	CBaseEntity@ CNPCD_PAR4 = null;
	float CNPCD_PAR5 = 0.0f;
	float CNPCD_PAR6 = 0.0f;
	string CNPCD_PAR7 = "CNPCD_PAR7";
	string CNPCD_PAR8 = "CNPCD_PAR8";
	int CONST_SPAWNS_PER_SET = 0;
	string DEMON_RAGE_USERS = "DEMON_RAGE_USERS";
	string DEMON_RAGE_USES = "DEMON_RAGE_USES";
	string DEST_MAP = "DEST_MAP";
	string DEV_ID = "DEV_ID";
	string DEV_PLAYER = "DEV_PLAYER";
	bool DQ_DEATH_CALLBACK_ARRAY_CREATED = false;
	string DQ_MONSTER_KILLED_NAME = "DQ_MONSTER_KILLED_NAME";
	Vector3 DQ_MONSTER_KILLED_ORIGIN = Vector3();
	float FD_LOOP_AMT = 0.0f;
	CBaseEntity@ FD_LOOP_TARG = null;
	bool FORGET_SPELL = false;
	string F_DIST = "F_DIST";
	bool GM_APRIL_CHECKING = false;
	bool GM_APRIL_INVALIDATED = false;
	Vector3 GM_APRIL_SPAWN_POINT = Vector3();
	float GM_BTROLLS_DEAD = 0.0f;
	bool GM_CHANGELEVEL = false;
	bool GM_DEL_QUE_ACTIVE = false;
	string GM_DEST_TRANS = "GM_DEST_TRANS";
	bool GM_DISABLE_SPAWNS = false;
	bool GM_DISABLE_TRANSITIONS = false;
	bool GM_HAD_PLAYER = false;
	bool GM_HANDLE_ACTIVATES = false;
	string GM_HP_TOKENS = "GM_HP_TOKENS";
	string GM_ITEM_NAME = "GM_ITEM_NAME";
	Vector3 GM_ITEM_ORIGIN = Vector3();
	bool GM_ITEM_RESERVE = false;
	CBaseEntity@ GM_ITEM_TARGET = null;
	string GM_ITEM_TO_GIVE = "GM_ITEM_TO_GIVE";
	int GM_LIGHT_PLAYER = 0;
	string GM_MALDORA_LIST = "GM_MALDORA_LIST";
	string GM_NEW_WEATHER = "GM_NEW_WEATHER";
	int GM_N_EPICS = 0;
	bool GM_RACE_ACTIVATE = false;
	float GM_SCRAMBLE_COUNT = 0.0f;
	string GM_SPAWN_POINT = "GM_SPAWN_POINT";
	string GM_SXBOW_RECIEVE = "GM_SXBOW_RECIEVE";
	float GM_TEMP_COUNT = 0.0f;
	string GM_TOTAL_HP = "GM_TOTAL_HP";
	float GM_TOTAL_TRIGGERED = 0.0f;
	string GM_TRIGGER_PREFIX = "GM_TRIGGER_PREFIX";
	bool GM_TRIG_ACTIVATE = false;
	bool GM_TRIG_HP_REQ = false;
	bool GM_TRIG_RACE_REQ = false;
	string GM_TRIG_TARGET = "GM_TRIG_TARGET";
	string GM_TRIG_TOKENS = "GM_TRIG_TOKENS";
	bool GM_VANISH_QUE_ACTIVE = false;
	string GOLD_AMT = "GOLD_AMT";
	string GOLD_POS = "GOLD_POS";
	float G_MAP_UPTIME = 0.0f;
	float G_NGAME_MASTERS = 0.0f;
	Vector3 HOLLOW_ONE_POS = Vector3();
	string ITEM_NAME = "ITEM_NAME";
	Vector3 ITEM_POS = Vector3();
	int LIGHTSYS_N_LIGHTS = 0;
	int LOOP_LIMIT = 0;
	string MAGIC_HAND_NAMES1 = "MAGIC_HAND_NAMES1";
	string MAGIC_HAND_NAMES2 = "MAGIC_HAND_NAMES2";
	string MAGIC_HAND_NAMES3 = "MAGIC_HAND_NAMES3";
	string MAGIC_HAND_SCRIPTS1 = "MAGIC_HAND_SCRIPTS1";
	string MAGIC_HAND_SCRIPTS2 = "MAGIC_HAND_SCRIPTS2";
	string MAGIC_HAND_SCRIPTS3 = "MAGIC_HAND_SCRIPTS3";
	bool MAKING_ITEM = false;
	string MALDORA_LIST = "MALDORA_LIST";
	string MENU_TARGET = "MENU_TARGET";
	bool NO_ADMINS_FOUND = false;
	CBaseEntity@ NPC_DIED = null;
	float NUM_BAGS = 0.0f;
	float N_MALDORAS = 0.0f;
	float N_SPAWN_POINTS = 0.0f;
	string PLAYER_LIST = "PLAYER_LIST";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool PLR_FOUND_FIRST_STICK = false;
	string POINTS_ILIST = "POINTS_ILIST";
	CBaseEntity@ POTION_ID = null;
	CBaseEntity@ QITEM_CALLER = null;
	string QITEM_NAME = "QITEM_NAME";
	float ROT_STEP = 0.0f;
	float ROT_STEP_SIZE = 0.0f;
	string SHAD_TELEPOINTS = "SHAD_TELEPOINTS";
	string SHAD_TRIGGERS = "SHAD_TRIGGERS";
	int SORC_CUR_TELE_SET = 0;
	string SORC_TELE_SET1 = "SORC_TELE_SET1";
	string SORC_TELE_SET2 = "SORC_TELE_SET2";
	string SORC_TELE_SET3 = "SORC_TELE_SET3";
	int SORC_TELE_SETS = 0;
	string SORTED_TOP_PLAYERS = "SORTED_TOP_PLAYERS";
	string SPAWN_POINTS1 = "SPAWN_POINTS1";
	string SPAWN_POINTS2 = "SPAWN_POINTS2";
	string SPAWN_POINTS3 = "SPAWN_POINTS3";
	string SPAWN_POINTS4 = "SPAWN_POINTS4";
	string SPAWN_POINTS5 = "SPAWN_POINTS5";
	string SPAWN_POINTS6 = "SPAWN_POINTS6";
	string SPAWN_POINTS7 = "SPAWN_POINTS7";
	string SPAWN_POINTS8 = "SPAWN_POINTS8";
	string SPAWN_POINTS9 = "SPAWN_POINTS9";
	string SPAWN_TIME = "SPAWN_TIME";
	CBasePlayer@ SPELL_CASTER = null;
	bool SPELL_ERASE = false;
	bool SPELL_ERASE_CONFIRM = false;
	string SPELL_NAME = "SPELL_NAME";
	int SPELL_TO_FORGET_IDX = 0;
	bool STRONGEST_IDX = false;
	string STRONGEST_PLAYER_LIST = "STRONGEST_PLAYER_LIST";
	bool STRONGEST_STAT_LEVEL = false;
	string THE_CHOSEN_ONE = "THE_CHOSEN_ONE";
	bool THE_CHOSEN_ONE_IDX = false;
	float TRIGGER_COUNT = 0.0f;
	bool VOTE_IN_PROGRESS = false;
	string VOTE_WINNAR_COUNT = "VOTE_WINNAR_COUNT";
	string VOTE_WINNAR_IDX = "VOTE_WINNAR_IDX";
	string WIZARD_CENTER = "WIZARD_CENTER";
	float WORM_COUNT = 0.0f;
	float WORM_GOLD = 0.0f;
	CBaseEntity@ WORM_ID = null;
	string WORM_ITEM = "WORM_ITEM";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VoteGeneric_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return VoteGeneric_DispatchEvent(name, params);
	}
}
