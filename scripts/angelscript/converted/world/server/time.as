#pragma context server

// Converted from world/server/time.script by msc_transpiler.
// Thothie - Changing default time to noon (tired of starting in the dark)
// Manages the game world
// Useful for controlling ongoing global events
// World Time
// ==========
// Configuration
// -------------

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Time
{
	// Constants
	int TIME_UPDATE_INTERVAL = 30;

	// unnamed block (first think)
	void Time_FirstThink()
	{
		SetGlobal("TIME_RATIO", 20); // Pass X minutes in-game to every one real minute
	}

	// unnamed block (first think)
	// The workings
	// ------------
	void Time_FirstThink2()
	{
		if (GetVar("CURRENT_TIME") != "CURRENT_TIME")
			return;

		// Spam crash control system
		SetGlobal("CURRENT_TIME_HOUR", 0);
		SetGlobal("CURRENT_TIME_MIN", 0);
		SetGlobal("global.mstime.secs", 0);
		SetGlobal("global.mstime.lastupdate", 0); // Reset update time
		SetGlobal("global.mstime.updateall", 0); // Reset world update time

		SetGlobal("global.mstime.secs", 215940); // Reset time to NOON
	}

	// unnamed block (timer)
	// Calculate the time
	void Time_Timer()
	{
		CallEventDelayed(1.0f, "Time_Timer");

		OnGlobalTimeUpdate(); // Update MS time

		string dayofsSecsText = GetVar("global.mstime.secs"); // Only calculate for 24 hours
		float dayofsSecs = Modulo(Float(dayofsSecsText), 86400.0f); // (Find seconds passed from start of day)
		dayofsSecsText = Text(dayofsSecs);

		SetGlobal("CURRENT_TIME_HOUR", dayofsSecsText); // Get hours
		LegacyCommand("divide", "CURRENT_TIME_HOUR", 3600);
		SetGlobal("CURRENT_TIME_HOUR", int(Float(GetVar("CURRENT_TIME_HOUR"))));

		SetGlobal("CURRENT_TIME_MIN", dayofsSecsText); // Get minutes
		LegacyCommand("mod", "CURRENT_TIME_MIN", 3600);
		LegacyCommand("divide", "CURRENT_TIME_MIN", 60);
		SetGlobal("CURRENT_TIME_MIN", int(Float(GetVar("CURRENT_TIME_MIN"))));

		OnFormatTime(Float(GetVar("CURRENT_TIME_HOUR")), Float(GetVar("CURRENT_TIME_MIN"))); // Get HH:MM Format

		// //dbg CURRENT_TIME | H: CURRENT_TIME_HOUR | M: CURRENT_TIME_MIN
		if (!(Float(GetVar("global.mstime.secs")) >= Float(GetVar("global.mstime.updateall"))))
			return;

		CallExternal("all", "worldevent_time", GetVar("CURRENT_TIME_HOUR"), GetVar("CURRENT_TIME_MIN"), GetVar("TIME_RATIO")); // Update the world every so often

		float intervalsecs = TIME_UPDATE_INTERVAL * 60.0f;

		string lastupdatetimeText = GetVar("global.mstime.secs");
		float lastupdatetime = Divide(Float(lastupdatetimeText), intervalsecs);
		lastupdatetime = int(lastupdatetime) * intervalsecs;
		lastupdatetimeText = Text(lastupdatetime);

		SetGlobal("global.mstime.updateall", lastupdatetimeText); // Set the next update
		LegacyCommand("add", "global.mstime.updateall", intervalsecs);
	}

	// global_time_update
	// Updates MS time and stores it in global.mstime.secs
	void Time_OnGlobalTimeUpdate()
	{
		float timeElapsed = GameTime() - Float(GetVar("global.mstime.lastupdate")); // Find out real time passed since last update

		float secs = timeElapsed * Float(GetVar("TIME_RATIO")); // Scale it to game time

		LegacyCommand("add", "global.mstime.secs", secs);

		SetGlobal("global.mstime.lastupdate", GameTime());
	}

	// format_time
	// Get this into HH:MM format
	void Time_OnFormatTime(float hour = 0.0f, float minute = 0.0f)
	{
		string mins;

		SetGlobal("CURRENT_TIME", "");
		if (hour < 10.0f)
			SetGlobal("CURRENT_TIME", "0");
		LegacyCommand("stradd", "CURRENT_TIME", int(hour));

		if (minute < 10.0f)
			mins = "0";
		else
			mins = "";
		mins += int(minute);

		LegacyCommand("stradd", "CURRENT_TIME", ":");
		LegacyCommand("stradd", "CURRENT_TIME", mins);
	}

	// game_spawn
	// Called when map start
	void Time_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetGlobal("global.mstime.lastupdate", 0);

		// xmass mode
		if (Float(Eval("game.time.month")) == 12.0f)
		{
			// Thothie JAN2010_11 - Extending Xmass mode to all of December
			SetGlobal("G_CHRISTMAS_MODE", 1);
		}
	}

	// game_playerjoin
	// Inform clients of the time
	void Time_OnGamePlayerjoin(CBasePlayer@ player = null)
	{
		OnWorldUpdateplayertime();
	}

	// worldevent_time
	// 1: HOUR  2: MIN  3: TIME RATIO
	void Time_OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0)
	{
		OnWorldUpdateplayertime();
	}

	// world_updateplayertime
	void Time_OnWorldUpdateplayertime()
	{
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "recv_time", GetVar("CURRENT_TIME_HOUR"), GetVar("CURRENT_TIME_MIN"), GetVar("TIME_RATIO"), GetVar("global.map.allownight"));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGlobalTimeUpdate() { Time_OnGlobalTimeUpdate(); } // global_time_update
	void OnFormatTime(float hour = 0.0f, float minute = 0.0f) { Time_OnFormatTime(hour, minute); } // format_time
	void OnGameSpawn(string playerRace = "", string playerGender = "") { Time_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGamePlayerjoin(CBasePlayer@ player = null) { Time_OnGamePlayerjoin(player); } // game_playerjoin
	void OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0) { Time_OnWorldeventTime(hour, minute, timeRatio); } // worldevent_time
	void OnWorldUpdateplayertime() { Time_OnWorldUpdateplayertime(); } // world_updateplayertime

	// This file's events and timers by their .script names
	bool Time_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "format_time") { OnFormatTime(Float(Param(params, 0)), Float(Param(params, 1))); return true; }
		if (name == "game_playerjoin") { OnGamePlayerjoin(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "global_time_update") { OnGlobalTimeUpdate(); return true; }
		if (name == "world_updateplayertime") { OnWorldUpdateplayertime(); return true; }
		if (name == "worldevent_time") { OnWorldeventTime(Float(Param(params, 0)), Float(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "Time_Timer") { Time_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/server/time"]
shared class TimeScript : ScriptEntity, Time
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
	string TIP_TEXT = "TIP_TEXT";
	bool WARNED_DRIDJE = false;
	bool WEATHERSET_DELAY = false;
	string WEATHER_SPRITE = "WEATHER_SPRITE";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "Time_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Time_FirstThink();
		Time_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Time_DispatchEvent(name, params);
	}
}
