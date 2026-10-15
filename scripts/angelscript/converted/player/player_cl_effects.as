#pragma context server

// Converted from player/player_cl_effects.script by msc_transpiler.
// Player client-side effects
// Player fall
// ===========

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerClEffects
{
	// Constants
	int MAX_BOB_DURATION = 3;
	int MAX_BOB_DIP = 20;

	// Variables (an unset .script variable reads as its own name)
	float GROUNDBOB_DURATION = 0.0f;
	float GROUNDBOB_DIP = 0.0f;
	float GROUNDBOB_STARTTIME = 0.0f;
	bool BREATHE_PLAYING = false;

	// player_hitgroundhard
	// 1: Downward Velocity
	void PlayerClEffects_OnPlayerHitgroundhard(float downVelocity = 0.0f)
	{
		float dip = downVelocity * 0.05f;

		// //debugprint NEW FALL - game.time | L_DIP
		if (!(dip >= 12.0f)) // Only dip if over a certain amount
			return;

		// If under, keep the current dip or no dip
		GROUNDBOB_DURATION = downVelocity * 0.001f;
		GROUNDBOB_DIP = dip;
		GROUNDBOB_STARTTIME = GameTime();

		if (!(GROUNDBOB_DIP >= 12.0f))
			return;
		GROUNDBOB_DURATION = Clamp(GROUNDBOB_DURATION, 0.0f, MAX_BOB_DURATION);
		GROUNDBOB_DIP = Clamp(GROUNDBOB_DIP, 0.0f, MAX_BOB_DIP);

		OnPlayerHitgroundAdjview();
		CallEventDelayed(GROUNDBOB_DURATION, "player_hitground_fixview");
	}

	// player_hitground_adjview
	void PlayerClEffects_OnPlayerHitgroundAdjview()
	{
		float lclBobamt = 0.0f;

		if (int(GROUNDBOB_STARTTIME) == 0)
			return;

		float lclBobtime = Clamp(GameTime() - GROUNDBOB_STARTTIME, 0.0f, MAX_BOB_DURATION);

		if (!(lclBobamt <= GROUNDBOB_DURATION))
			return;

		lclBobamt = lclBobtime;

		float lclTimescale = Divide(2.0f, GROUNDBOB_DURATION);

		lclBobamt *= lclTimescale;
		lclBobamt -= 1.0f;

		lclBobamt *= lclBobamt;
		lclBobamt *= GROUNDBOB_DIP;

		lclBobamt -= GROUNDBOB_DIP;
		string lclBobamtText = Text(lclBobamt);

		// if( LCL_BOBAMT > 0 )
		// {
		// //debugprint Current Time: game.time
		// //debugprint StartTime:    GROUNDBOB_STARTTIME
		// //debugprint BobTime:      LCL_BOBTIME
		// //debugprint Duration:     GROUNDBOB_DURATION
		// }
		SetVar(Eval("game.cleffect.view_ofs.z"), lclBobamtText);
		lclBobamt *= 1.01f;
		lclBobamtText = Text(lclBobamt);
		SetVar(Eval("game.cleffect.viewmodel_ofs.z"), lclBobamtText); // Viewmodel dips a bit lower than view

		CallEventDelayed(0.01f, "player_hitground_adjview");
	}

	// player_hitground_fixview
	void PlayerClEffects_OnPlayerHitgroundFixview()
	{
		// debugpring STOP!! game.time | GROUNDBOB_STARTTIME
		GROUNDBOB_STARTTIME = 0.0f;
		SetVar(Eval("game.cleffect.view_ofs.z"), 0);
		SetVar(Eval("game.cleffect.viewmodel_ofs.z"), "LCL_BOBAMT");
	}

	// player_breathe
	// Player breathing
	// ================
	void PlayerClEffects_OnPlayerBreathe()
	{
		string lclBreathesound = "LCL_BREATHESOUND";

		if (!(Float(Eval("game.player.stamina.ratio")) < 0.05f))
			return;
		if (BREATHE_PLAYING)
			return;

		lclBreathesound += Text(RandomInt(1, 3)) + ".wav";

		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), lclBreathesound);

		BREATHE_PLAYING = true;
		CallEventDelayed(6.0f, "player_breathe_done");
	}

	// player_breathe_done
	void PlayerClEffects_OnPlayerBreatheDone()
	{
		BREATHE_PLAYING = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnPlayerHitgroundhard(float downVelocity = 0.0f) { PlayerClEffects_OnPlayerHitgroundhard(downVelocity); } // player_hitgroundhard
	void OnPlayerHitgroundAdjview() { PlayerClEffects_OnPlayerHitgroundAdjview(); } // player_hitground_adjview
	void OnPlayerHitgroundFixview() { PlayerClEffects_OnPlayerHitgroundFixview(); } // player_hitground_fixview
	void OnPlayerBreathe() { PlayerClEffects_OnPlayerBreathe(); } // player_breathe
	void OnPlayerBreatheDone() { PlayerClEffects_OnPlayerBreatheDone(); } // player_breathe_done
	void OnGroundbobDuration() {} // GROUNDBOB_DURATION

	// This file's events and timers by their .script names
	bool PlayerClEffects_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "player_breathe") { OnPlayerBreathe(); return true; }
		if (name == "player_breathe_done") { OnPlayerBreatheDone(); return true; }
		if (name == "player_hitground_adjview") { OnPlayerHitgroundAdjview(); return true; }
		if (name == "player_hitground_fixview") { OnPlayerHitgroundFixview(); return true; }
		if (name == "player_hitgroundhard") { OnPlayerHitgroundhard(Float(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_cl_effects"]
shared class PlayerClEffectsScript : ScriptEntity, PlayerClEffects
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerClEffects_DispatchEvent(name, params);
	}
}
