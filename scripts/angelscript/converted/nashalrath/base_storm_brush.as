#pragma context server

// Converted from nashalrath/base_storm_brush.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseStormBrush
{
	// Constants
	int BASE_RENDERAMT = 255;
	int BASE_RENDERMODE = 5;

	// Variables (an unset .script variable reads as its own name)
	float RND_AMT = 0.0f;

	// game_spawn
	void BaseStormBrush_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetProp(ENT_ME, "rendermode", BASE_RENDERMODE);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// storm_show
	void BaseStormBrush_OnStormShow()
	{
		SetProp(ENT_ME, "rendermode", BASE_RENDERMODE);
		SetProp(ENT_ME, "renderamt", BASE_RENDERAMT);
	}

	// storm_hide
	void BaseStormBrush_OnStormHide()
	{
		SetProp(ENT_ME, "rendermode", BASE_RENDERMODE);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// storm_change_speed
	void BaseStormBrush_OnStormChangeSpeed(float spinSpeed = 0.0f)
	{
		SetProp(ENT_ME, "avelocity", Vector3(0, spinSpeed, 0));
	}

	// storm_fade_in
	void BaseStormBrush_OnStormFadeIn()
	{
		RND_AMT = 0.0f;
		OnStormFadeInLoop();
	}

	// storm_fade_in_loop
	void BaseStormBrush_OnStormFadeInLoop()
	{
		if (!(RND_AMT < BASE_RENDERAMT))
			return;
		RND_AMT += 4.0f;
		if (RND_AMT > BASE_RENDERAMT)
			RND_AMT = BASE_RENDERAMT;
		SetProp(ENT_ME, "rendermode", BASE_RENDERMODE);
		SetProp(ENT_ME, "renderamt", RND_AMT);
		if (!(RND_AMT < BASE_RENDERAMT))
			return;
		// dbg storm_fade_in_loop RND_AMT
		CallEventDelayed(0.1f, "storm_fade_in_loop");
	}

	// storm_fade_out
	void BaseStormBrush_OnStormFadeOut()
	{
		RND_AMT = BASE_RENDERAMT;
		OnStormFadeOutLoop();
	}

	// storm_fade_out_loop
	void BaseStormBrush_OnStormFadeOutLoop()
	{
		if (!(RND_AMT > 0.0f))
			return;
		RND_AMT -= 4.0f;
		if (RND_AMT < 0.0f)
			RND_AMT = 0.0f;
		SetProp(ENT_ME, "rendermode", BASE_RENDERMODE);
		SetProp(ENT_ME, "renderamt", RND_AMT);
		if (!(RND_AMT > 0.0f))
			return;
		// dbg storm_fade_out_loop RND_AMT
		CallEventDelayed(0.1f, "storm_fade_out_loop");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseStormBrush_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnStormShow() { BaseStormBrush_OnStormShow(); } // storm_show
	void OnStormHide() { BaseStormBrush_OnStormHide(); } // storm_hide
	void OnStormChangeSpeed(float spinSpeed = 0.0f) { BaseStormBrush_OnStormChangeSpeed(spinSpeed); } // storm_change_speed
	void OnStormFadeIn() { BaseStormBrush_OnStormFadeIn(); } // storm_fade_in
	void OnStormFadeInLoop() { BaseStormBrush_OnStormFadeInLoop(); } // storm_fade_in_loop
	void OnStormFadeOut() { BaseStormBrush_OnStormFadeOut(); } // storm_fade_out
	void OnStormFadeOutLoop() { BaseStormBrush_OnStormFadeOutLoop(); } // storm_fade_out_loop

	// This file's events and timers by their .script names
	bool BaseStormBrush_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "storm_change_speed") { OnStormChangeSpeed(Float(Param(params, 0))); return true; }
		if (name == "storm_fade_in") { OnStormFadeIn(); return true; }
		if (name == "storm_fade_in_loop") { OnStormFadeInLoop(); return true; }
		if (name == "storm_fade_out") { OnStormFadeOut(); return true; }
		if (name == "storm_fade_out_loop") { OnStormFadeOutLoop(); return true; }
		if (name == "storm_hide") { OnStormHide(); return true; }
		if (name == "storm_show") { OnStormShow(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "nashalrath/base_storm_brush"]
shared class BaseStormBrushScript : ScriptEntity, BaseStormBrush
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseStormBrush_DispatchEvent(name, params);
	}
}
