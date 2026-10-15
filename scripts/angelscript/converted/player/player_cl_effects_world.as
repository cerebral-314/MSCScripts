#pragma context server

// Converted from player/player_cl_effects_world.script by msc_transpiler.
// Manages the game world on the client
// Useful for handling global events clientside
// Day/Night
// ==========

#include "runtime/ScriptEntity.as"
#include "converted/player/player_cl_effects_special.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerClEffectsWorld
{
	// Constants
	string DAY_SKYNAME = "game.map.skyname";
	string DAY_SOUND = "amb/birds01.wav";
	int DAY_START_HOUR = 6;
	string DAY_STATE = "day";
	string AFT_SKYNAME = "AFT_SKYNAME";
	string AFT_SOUND = "none";
	int AFT_START_HOUR = 17;
	string AFT_STATE = "aft";
	string NIGHT_SKYNAME = "space";
	string NIGHT_SOUND = "amb/wolf01.wav";
	int NIGHT_START_HOUR = 20;
	string NIGHT_STATE = "night";

	// Variables (an unset .script variable reads as its own name)
	string PREV_STATE = "PREV_STATE";
	string CURRENT_TOD_STATE = "CURRENT_TOD_STATE";
	bool AM_FADING = false;
	float FADE_COUNT = 0.0f;
	float DUSK_FADE_COUNT = 0.0f;
	float NIGHT_FADE_COUNT = 0.0f;
	string CLPLR_TOD_STATE = "CLPLR_TOD_STATE";
	string CL_TOD_LOCK = "CL_TOD_LOCK";

	// unnamed block (first think)
	void PlayerClEffectsWorld_FirstThink()
	{
		SetGlobal("clglobal.daystate", DAY_STATE);
	}

	// recv_time_initial
	void PlayerClEffectsWorld_OnRecvTimeInitial()
	{
		if (Float(GetVar("clglobal.time.hour")) >= NIGHT_START_HOUR)
			SetGlobal("clglobal.daystate", NIGHT_STATE);
	}

	// recv_time
	void PlayerClEffectsWorld_OnRecvTime(string hour = "", string minute = "", string timeText = "")
	{
		string olddaytime = GetVar("clglobal.daystate");
		SetGlobal("clglobal.time.hour", hour);
		SetGlobal("clglobal.time.min", minute);
		SetGlobal("clglobal.time.text", timeText);

		PREV_STATE = GetVar("clglobal.daystate");

		if (Float(GetVar("clglobal.time.hour")) < NIGHT_START_HOUR)
		{
			if (Float(GetVar("clglobal.time.hour")) >= AFT_START_HOUR)
				OnChangeToAft();
			else if (Float(GetVar("clglobal.time.hour")) >= DAY_START_HOUR)
				CallExternal("all", "environment_change", DAY_STATE);
			else
				OnChangeToNight();
		}
		else
		{
			OnChangeToNight();
		}

		OnTimeChange(olddaytime, GetVar("clglobal.daystate"));
	}

	// change_to_night
	void PlayerClEffectsWorld_OnChangeToNight()
	{
		if (!Truthy(GetVar("global.map.allownight")))
			CallExternal("all", "environment_change", DAY_STATE);
		else
			CallExternal("all", "environment_change", NIGHT_STATE);
	}

	// change_to_aft
	void PlayerClEffectsWorld_OnChangeToAft()
	{
		if (!Truthy(GetVar("global.map.allownight")))
			CallExternal("environment_change", DAY_STATE);
		else
			CallExternal("all", "environment_change", AFT_STATE);
	}

	// environment_change
	// PARAM1 == new environment state
	void PlayerClEffectsWorld_OnEnvironmentChange(string environmentState = "")
	{
		bool exitSub = false;

		if (CL_TOD_LOCK != "none" && environmentState != CL_TOD_LOCK)
			exitSub = true;
		if (exitSub)
			return;

		CURRENT_TOD_STATE = environmentState;

		if (environmentState == DAY_STATE)
		{
			if (AM_FADING)
				OnFinalizeState(DAY_STATE);
			if (!AM_FADING)
			{
				if (PREV_STATE == NIGHT_STATE)
				{
					if (!AM_FADING)
					{
						AM_FADING = true;
						// setvarg clglobal.daystate DAY_STATE
						FADE_COUNT = 1000.0f;
						OnFadeToDay();
					}
				}
				else
				{
					OnFinalizeState(DAY_STATE);
				}
			}
		}
		else if (environmentState == AFT_STATE)
		{
			if (AM_FADING)
				OnFinalizeState(AFT_STATE);
			if (!AM_FADING)
			{
				if (PREV_STATE == DAY_STATE)
				{
					// setvarg clglobal.daystate DAY_STATE
					if (!AM_FADING)
					{
						AM_FADING = true;
						DUSK_FADE_COUNT = 1000.0f;
						OnFadeToDusk();
					}
				}
				else
				{
					SetGlobal("clglobal.daystate", AFT_STATE);
					SetEnvironment("sky.texture", AFT_SKYNAME);
					SetEnvironment("lightgamma", 5);
					SetEnvironment("fog.enabled", 0);
					SetEnvironment("screen.tint", Vector3(0.8156f, 0.368627f, 0.007843f));
				}
			}
		}
		else if (environmentState == NIGHT_STATE)
		{
			if (AM_FADING)
				OnFinalizeState(NIGHT_STATE);
			if (!AM_FADING)
			{
				if (PREV_STATE == AFT_STATE)
				{
					if (!AM_FADING)
					{
						AM_FADING = true;
						SetEnvironment("fog.density", 0.05f);
						SetEnvironment("fog.color", Vector3(0, 0, 0));
						SetEnvironment("fog.start", 4096);
						SetEnvironment("fog.end", 4864);
						SetEnvironment("fog.type", "linear");
						SetEnvironment("fog.enabled", 1);
						NIGHT_FADE_COUNT = 1000.0f;
						OnFadeToNight();
					}
				}
				else
				{
					OnFinalizeState(NIGHT_STATE);
				}
			}
		}
	}

	// finalize_state
	// <tod>
	void PlayerClEffectsWorld_OnFinalizeState(string timeOfDay = "")
	{
		DebugPrint("**** finalize_state " + timeOfDay);

		AM_FADING = false;
		NIGHT_FADE_COUNT = -1.0f;
		FADE_COUNT = -1.0f;
		DUSK_FADE_COUNT = -1.0f;
		CLPLR_TOD_STATE = timeOfDay;

		if (timeOfDay == DAY_STATE)
		{
			SetGlobal("clglobal.daystate", DAY_STATE);
			SetEnvironment("sky.texture", DAY_SKYNAME);
			SetEnvironment("lightgamma", 2.5f);
			SetEnvironment("fog.enabled", 0);
			SetEnvironment("screen.tint", Vector3(0, 0, 0));
		}
		else if (timeOfDay == AFT_STATE)
		{
			SetGlobal("clglobal.daystate", AFT_STATE);
			SetEnvironment("sky.texture", AFT_SKYNAME);
			SetEnvironment("lightgamma", 5);
			SetEnvironment("fog.enabled", 0);
			SetEnvironment("screen.tint", Vector3(0.8156f, 0.368627f, 0.007843f));
		}
		else if (timeOfDay == NIGHT_STATE)
		{
			SetGlobal("clglobal.daystate", NIGHT_STATE);
			SetEnvironment("fog.enabled", 1);
			SetEnvironment("fog.density", 0.05f);
			SetEnvironment("fog.start", 256);
			SetEnvironment("fog.end", 1024);
			SetEnvironment("fog.type", "linear");
			SetEnvironment("fog.color", Vector3(0, 0, 0));
			SetEnvironment("screen.tint", Vector3(0.0200f, 0.020000f, 0.300000f));
			// setenv screen.tint	(0,0,0,0.65) //this is what darkens the wrong lights ><
			SetEnvironment("lightgamma", 4);
		}
	}

	// fade_to_night
	void PlayerClEffectsWorld_OnFadeToNight()
	{
		if (NIGHT_FADE_COUNT == 0.0f)
		{
			OnFinalizeState(NIGHT_STATE);
			PlaySound(Int(Eval("const.snd.static")), Eval("const.snd.maxvol"), NIGHT_SOUND);
		}

		if (!(NIGHT_FADE_COUNT > 0.0f))
			return;
		CallEventDelayed(0.01f, "fade_to_night");

		NIGHT_FADE_COUNT -= 1.0f;

		float progressRatio = Divide(NIGHT_FADE_COUNT, 1000.0f); // $get_skill_ratio(PROGRESS_RATIO,<targ>,<start>)

		// local LIGHT_GAMMA $get_skill_ratio(PROGRESS_RATIO,4.0,5.0)
		// local FOG_DENSI $get_skill_ratio(PROGRESS_RATIO,0.5,0.0001)
		float fogStart = Float(LegacyFunction("get_skill_ratio", progressRatio, 256, 4096));
		float fogEnd = 768.0f + fogStart;
		float tintR = Float(LegacyFunction("get_skill_ratio", progressRatio, 0.02f, 0.8156f));
		float tintG = Float(LegacyFunction("get_skill_ratio", progressRatio, 0.02f, 0.368627f));
		float tintB = Float(LegacyFunction("get_skill_ratio", progressRatio, 0.3f, 0.007843f));
		// bleh, neither strconc nor $stradd() will handle this
		string tintStr = "(" + Text(tintR) + "," + Text(tintB) + "," + Text(tintG) + ",0.1)";

		// dbg **** fade_to_night [ NIGHT_FADE_COUNT ] PROGRESS_RATIO lg LIGHT_GAMMA fd FOG_DENSI fs FOG_START ts TINT_STR
		// dbg **** fade_to_night [ NIGHT_FADE_COUNT ] PROGRESS_RATIO fs FOG_START - FOG_END ts TINT_STR
		// setenv fog.density	FOG_DENSI
		SetEnvironment("fog.start", fogStart);
		SetEnvironment("fog.end", fogEnd);
		SetEnvironment("screen.tint", tintStr);
	}

	// fade_to_dusk
	void PlayerClEffectsWorld_OnFadeToDusk()
	{
		DUSK_FADE_COUNT = 0.0f; // changes to render causes DUSK fade effect to crash, just go straight to finalize

		if (DUSK_FADE_COUNT == 0.0f)
			OnFinalizeState(AFT_STATE);

		if (!(DUSK_FADE_COUNT > 0.0f))
			return;
		CallEventDelayed(0.01f, "fade_to_dusk");

		DUSK_FADE_COUNT -= 1.0f;

		float progressRatio = Divide(DUSK_FADE_COUNT, 1000.0f);
		float lightGamma = Float(LegacyFunction("get_skill_ratio", progressRatio, 4.0f, 2.5f));
		float tintAlpha = Float(LegacyFunction("get_skill_ratio", progressRatio, 0.1f, 0));
		SetEnvironment("lightgamma", lightGamma);

		string screenStr = "(0.8156,0.368627,0.007843," + Text(tintAlpha) + ")";
		// dbg **** fade_to_dusk [ DUSK_FADE_COUNT ] PROGRESS_RATIO ta TINT_ALPHA lg SCREEN_STR
		SetEnvironment("screen.tint", screenStr);
	}

	// fade_to_day
	void PlayerClEffectsWorld_OnFadeToDay()
	{
		if (FADE_COUNT == 0.0f)
		{
			OnFinalizeState(DAY_STATE);
			PlaySound(Int(Eval("const.snd.static")), Eval("const.snd.maxvol"), DAY_SOUND);
		}

		if (!(FADE_COUNT > 0.0f))
			return;
		CallEventDelayed(0.01f, "fade_to_day");

		FADE_COUNT -= 1.0f;

		float progressRatio = Divide(FADE_COUNT, 1000.0f);
		float lightGamma = Float(LegacyFunction("get_skill_ratio", progressRatio, 2.5f, 4.0f));
		float fogDensi = Float(LegacyFunction("get_skill_ratio", progressRatio, 0.0f, 0.1f));
		float fogStart = Float(LegacyFunction("get_skill_ratio", progressRatio, 4096, 256));
		float tintAlpha = Float(LegacyFunction("get_skill_ratio", progressRatio, 0, 0.1f));
		string screenStr = "(0.0200,0.020000,0.300000," + Text(tintAlpha) + ")";
		float fogEnd = 1024.0f + fogStart;

		// dbg **** fade_to_day [ FADE_COUNT ] PROGRESS_RATIO lg LIGHT_GAMMA fd FOG_DENSI fs FOG_START TINT_ALPHA
		// setenv fog.color	(FOG_COLOR,FOG_COLOR,FOG_COLOR)
		SetEnvironment("fog.density", fogDensi);
		SetEnvironment("fog.start", fogStart);
		SetEnvironment("fog.end", fogEnd);
		SetEnvironment("screen.tint", screenStr);
	}

	// time_change
	void PlayerClEffectsWorld_OnTimeChange(string oldDaytime = "", string newDaytime = "")
	{
		// 1: prev daytime  2: New daytime
		// Detect a change in the daytime and start a transition of
		// special effects to the new time
		if (oldDaytime == newDaytime)
			return;

		if (newDaytime == DAY_STATE)
		{
			PlaySound(Int(Eval("const.snd.static")), Eval("const.snd.maxvol"), DAY_SOUND);
		}
		else if (newDaytime == AFT_STATE)
		{
		}
		else if (newDaytime == NIGHT_STATE)
			PlaySound(Int(Eval("const.snd.static")), Eval("const.snd.maxvol"), NIGHT_SOUND);
	}

	// lock_tod
	// <time_to_lock> //update event
	void PlayerClEffectsWorld_OnLockTod(string timeToLock = "")
	{
		CL_TOD_LOCK = timeToLock;
	}

	// reset_tod
	void PlayerClEffectsWorld_OnResetTod()
	{
		SetEnvironment("sky.texture", DAY_SKYNAME);
		SetEnvironment("lightgamma", 2.5f);
		SetEnvironment("fog.enabled", 0);
		SetEnvironment("fog.density", 0);
		SetEnvironment("screen.tint", Vector3(0, 0, 0));

		string currentTodState = CURRENT_TOD_STATE;
		if (currentTodState == "CURRENT_TOD_STATE")
			currentTodState = "day";
		OnFinalizeState(currentTodState);
	}

	// clear_weather
	// FEB2010_13 - clear weather client event
	void PlayerClEffectsWorld_OnClearWeather()
	{
		SetEnvironment("sky.texture", DAY_SKYNAME);
		SetEnvironment("lightgamma", 2.5f);
		SetEnvironment("fog.enabled", 0);
		SetEnvironment("screen.tint", Vector3(0, 0, 0));
		OnFinalizeState(CLPLR_TOD_STATE);
	}

	// change_sky
	void PlayerClEffectsWorld_OnChangeSky(string skyName = "")
	{
		SetEnvironment("sky.texture", skyName);
		InfoMessage("all", skyName, Eval("game.map.skyname"));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnChangeToAft() {} // change_to_aft
	void OnChangeToNight() {} // change_to_night
	void OnFadeToDay() {} // fade_to_day
	void OnFadeToDusk() {} // fade_to_dusk
	void OnFadeToNight() {} // fade_to_night
	void OnFinalizeState(string timeOfDay = "") {} // finalize_state
	void OnTimeChange(string oldDaytime = "", string newDaytime = "") {} // time_change
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_cl_effects_world"]
shared class PlayerClEffectsWorldScript : PlayerClEffectsSpecialScript, PlayerClEffectsWorld
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerClEffectsWorld_FirstThink();
		PlayerClEffectsSpecial_FirstThink();
	}
}
