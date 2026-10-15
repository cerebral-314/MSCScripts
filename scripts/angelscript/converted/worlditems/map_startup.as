#pragma context server

// Converted from worlditems/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class WorlditemsMapStartup
{
	// Constants
	bool MAP_ALLOWNIGHT = true;

	// unnamed block (first think)
	void WorlditemsMapStartup_FirstThink()
	{
		bool defaultWeather = false;

		if (MAP_WEATHER != "MAP_WEATHER")
			SetGlobal("global.map.weather", MAP_WEATHER);

		string mapName = MapName();
		OnGameNewlevel(mapName);

		SetGlobal("G_RAN_STARTUP_SCRIPT", 1);
		if (MAP_WEATHER == "MAP_WEATHER")
			defaultWeather = true;
		if (int(MAP_WEATHER.length()) < 3) // in case we have onst MAP_WEATHER ''
			defaultWeather = true;
		if (defaultWeather)
		{
			DebugPrint("base_map_startup Set default weather");
			SetGlobal("global.map.weather", "clear;clear;clear");
		}
	}

	// game_newlevel
	// PARAM1 = Mapname
	void WorlditemsMapStartup_OnGameNewlevel(string map = "")
	{
		if (GetVar("G_RAN_STARTUP_SCRIPT") == "G_RAN_STARTUP_SCRIPT")
			SetGlobal("G_RAN_STARTUP_SCRIPT", 1);
		LegacyCommand("add", "G_RAN_STARTUP_SCRIPT", 1); // causing a conflcit - guess it's not initiated when it gets here

		// if PARAM1 equals MAP_NAME
		if (MAP_WEATHER != "MAP_WEATHER")
			SetGlobal("G_OVERRIDE_WEATHER_CODE", MAP_WEATHER);
		else
			SetGlobal("G_OVERRIDE_WEATHER_CODE", 0);

		SetGlobal("global.map.weather", MAP_WEATHER);
		SetGlobal("global.map.allownight", MAP_ALLOWNIGHT);

		if (!MAP_ALLOWNIGHT)
		{
			SetGlobal("ALWAYS_DAY", 1);
			SetGlobal("global.mstime.secs", 215940);
			SetGlobal("global.mstime.updateall", 0);
		}
		// chatlog game_newlevel PARAM1 MAP_ALLOWNIGHT MAP_WEATHER
		DebugPrint("game_newlevel " + map + " " + Text(MAP_ALLOWNIGHT) + " " + MAP_WEATHER);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameNewlevel(string map = "") { WorlditemsMapStartup_OnGameNewlevel(map); } // game_newlevel

	// This file's events and timers by their .script names
	bool WorlditemsMapStartup_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_newlevel") { OnGameNewlevel(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "worlditems/map_startup"]
shared class WorlditemsMapStartupScript : ScriptEntity, WorlditemsMapStartup
{
	// Variables every script that includes this file declares
	string MAP_NAME = "MAP_NAME";
	string MAP_WEATHER = "MAP_WEATHER";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WorlditemsMapStartup_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return WorlditemsMapStartup_DispatchEvent(name, params);
	}
}
