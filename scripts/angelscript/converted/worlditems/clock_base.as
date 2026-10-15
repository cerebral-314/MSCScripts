#pragma context server

// Converted from worlditems/clock_base.script by msc_transpiler.
// Clock brush

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ClockBase
{

	// game_spawn
	void ClockBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetAngle("face.x", 0);
		SetProp(ENT_ME, "speed", 0);
		SetVar("local.lasthour", -1);
		SetVar("local.lastminute", -1);
	}

	// worldevent_time
	// Syncronize the time
	void ClockBase_OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0)
	{
		// ~3300 speed == 1 rotation / second
	}

	// set_hour_hand
	void ClockBase_OnSetHourHand(string hour = "", float speedScale = 0.0f)
	{
		if (Float(hour) == 0.0f)
			return;

		// Calculate the hour hand position
		float hourPosition = Float(hour);
		hourPosition *= 30.0f;

		float minOffset = Float(hour);
		minOffset = Divide(minOffset, 60.0f);
		minOffset *= 30.0f;

		float handPosition = (hourPosition + minOffset) * -1.0f;
		string handPositionText = Text(handPosition);
		SetAngle("face.x", handPositionText);
		SetVar("local.lasthour", hour);

		// Calulate the speed
		float handSpeed = -3220.0f; // Negative to go clockwise
		handSpeed = Divide(handSpeed, 43200.0f); // 12 * 3600
		handSpeed *= speedScale;
		SetProp(ENT_ME, "avelocity", Vector3(handSpeed, 0, 0));
	}

	// set_minute_hand
	void ClockBase_OnSetMinuteHand(float minute = 0.0f, string speedScale = "")
	{
		if (minute == 0.0f)
			return;

		// Calculate the minute hand position
		float handPosition = Divide(minute, 60.0f) * 360.0f * -1.0f;
		SetAngle("face.x", handPosition);
		SetVar("local.lastminute", speedScale);

		// Calulate the speed
		float handSpeed = Divide(-3220.0f, 3600.0f) * Float(speedScale); // Negative to go clockwise
		SetProp(ENT_ME, "avelocity", Vector3(handSpeed, 0, 0));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { ClockBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0) { ClockBase_OnWorldeventTime(hour, minute, timeRatio); } // worldevent_time
	void OnSetHourHand(string hour = "", float speedScale = 0.0f) { ClockBase_OnSetHourHand(hour, speedScale); } // set_hour_hand
	void OnSetMinuteHand(float minute = 0.0f, string speedScale = "") { ClockBase_OnSetMinuteHand(minute, speedScale); } // set_minute_hand

	// This file's events and timers by their .script names
	bool ClockBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_hour_hand") { OnSetHourHand(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "set_minute_hand") { OnSetMinuteHand(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "worldevent_time") { OnWorldeventTime(Float(Param(params, 0)), Float(Param(params, 1)), Int(Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "worlditems/clock_base"]
shared class ClockBaseScript : ScriptEntity, ClockBase
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ClockBase_DispatchEvent(name, params);
	}
}
