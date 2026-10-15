#pragma context server

// Converted from world/server/time_vote.script by msc_transpiler.
// Thothie - Respawn all in this vote makes everyone get stuck in a big wad, sometimes so irroverably people start reconnecting, leads to server lag, yelling, other bad things, suffice to say, commented out
// Handles vote commands

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class TimeVote
{

	// game_vote_end
	// 1: votetype   2: Player that started vote   3: "success"/"failed"   4: Vote data
	void TimeVote_OnGameVoteEnd(string voteType = "", string player = "", string outcome = "", float voteData = 0.0f)
	{
		if (voteType == "advtime")
		{
			// Players voted to advance time
			if (outcome == "success")
			{
				SetVar("script.newhour", GetVar("CURRENT_TIME_HOUR"));
				if (voteData == 0.0f)
					LegacyCommand("add", "script.newhour", 3);
				else if (voteData == 1.0f)
					LegacyCommand("add", "script.newhour", 6);
				else if (voteData == 2.0f)
					LegacyCommand("add", "script.newhour", 12);

				Effect("screenfade", "all", 0.5f, 10, Vector3(0, 0, 0), 255, "fadeout");
				CallEventDelayed(4.0f, "adv_time");
				CallEventDelayed(5.0f, "adv_fadin");
			}
		}
	}

	// adv_time
	void TimeVote_OnAdvTime()
	{
		OnSetTime(0.0f, Float(GetVar("CURRENT_TIME_MIN")));
		InfoMessage("all", "Time Change", "Later that day...");
	}

	// adv_fadin
	void TimeVote_OnAdvFadin()
	{
		Effect("screenfade", "all", 2, 3, Vector3(0, 0, 0), 255, "fadein");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameVoteEnd(string voteType = "", string player = "", string outcome = "", float voteData = 0.0f) { TimeVote_OnGameVoteEnd(voteType, player, outcome, voteData); } // game_vote_end
	void OnAdvTime() { TimeVote_OnAdvTime(); } // adv_time
	void OnAdvFadin() { TimeVote_OnAdvFadin(); } // adv_fadin
	void OnSetTime(float hour = 0.0f, float minute = 0.0f) {} // set_time

	// This file's events and timers by their .script names
	bool TimeVote_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "adv_fadin") { OnAdvFadin(); return true; }
		if (name == "adv_time") { OnAdvTime(); return true; }
		if (name == "game_vote_end") { OnGameVoteEnd(Param(params, 0), Param(params, 1), Param(params, 2), Float(Param(params, 3))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/server/time_vote"]
shared class TimeVoteScript : ScriptEntity, TimeVote
{
	// Variables every script that includes this file declares
	string BETA_TIMESTAMP = "BETA_TIMESTAMP";
	CBaseEntity@ CALLING_PLAYER = null;
	bool CAN_VOTE = false;
	string CREST_SELECTION = "CREST_SELECTION";
	float CUSTOM_COUNT = 0.0f;
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
	CBaseEntity@ L_VOTE_CALLER = null;
	int MAP_VOTE_DELAY = 0;
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

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return TimeVote_DispatchEvent(name, params);
	}
}
