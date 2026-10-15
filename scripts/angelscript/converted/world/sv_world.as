#pragma context server

// Converted from world/sv_world.script by msc_transpiler.
// Manages the game world
// Useful for controlling ongoing global events

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SvWorld
{

	// unnamed block (first think)
	void SvWorld_FirstThink()
	{
		SetGlobal("G_MAP_NAME", Eval("game.map.title"));
		SetGlobal("G_MAP_DESC", Eval("game.map.desc"));
		SetGlobal("G_WARN_HP", Eval("game.map.hpwarn"));
	}

	// game_spawn
	void SvWorld_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		bool overrideWeather = false;

		// FEB2009_17 (also 21) - attempts to fix the last of the sticky weather bugs
		if (GetVar("G_OVERRIDE_WEATHER_CODE") != "0")
			overrideWeather = true;
		if (GetVar("G_OVERRIDE_WEATHER_CODE") == "G_OVERRIDE_WEATHER_CODE")
			overrideWeather = false;
		if (overrideWeather)
			SetGlobal("global.map.weather", GetVar("G_OVERRIDE_WEATHER_CODE"));
		else
			SetGlobal("global.map.weather", Eval("game.map.weather"));

		string mapName = ToLowerCase(MapName());
		if (StartsWith(mapName, "pvp"))
			CallEventDelayed(5.0f, "set_pvp");
	}

	// set_pvp
	void SvWorld_OnSetPvp()
	{
		DebugPrint("set_pvp 1");
		LegacyCommand("setcvar", "ms_pklevel", 1);
		LegacyCommand("setpvp", 1);
	}

	// game_playerjoin
	// Called when a player joins
	// PARAM1=PlayerID
	void SvWorld_OnGamePlayerjoin(CBasePlayer@ player = null)
	{
		// set global HP
		// if ms_difficulty is set to 1, difficulty is determined by total HP of players on server
		// every 400 hp's ramps difficulty by 1 by default
		// on maps that have an HP warning, every HP_WARNING hp will ramp the diff by one
		int hpTick = Int(GetVar("G_WARN_HP"));
		if (Float(GetVar("G_WARN_HP")) == 0.0f)
			hpTick = 400;
		float totalHp = Float(Eval("game.players.totalhp")); // check hard code
		totalHp = Divide(totalHp, hpTick);
		SetGlobal("G_HP_RAMP", int(totalHp));
		DebugPrint(NameOf(player) + " joined, HP total is now " + Text(totalHp) + " ramp " + GetVar("G_HP_RAMP"));
	}

	// game_playerleave
	void SvWorld_OnGamePlayerleave(CBasePlayer@ player = null)
	{
		DebugPrint("sv_world game_playerleave " + NameOf(player));
		CallExternal("all", "player_left", @player);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { SvWorld_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnSetPvp() { SvWorld_OnSetPvp(); } // set_pvp
	void OnGamePlayerjoin(CBasePlayer@ player = null) { SvWorld_OnGamePlayerjoin(player); } // game_playerjoin
	void OnGamePlayerleave(CBasePlayer@ player = null) { SvWorld_OnGamePlayerleave(player); } // game_playerleave

	// This file's events and timers by their .script names
	bool SvWorld_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_playerjoin") { OnGamePlayerjoin(PlayerParam(params, 0)); return true; }
		if (name == "game_playerleave") { OnGamePlayerleave(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_pvp") { OnSetPvp(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "world/sv_world"]
shared class SvWorldScript : ScriptEntity, SvWorld
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

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SvWorld_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SvWorld_DispatchEvent(name, params);
	}
}
