#pragma context server

// Converted from player/player_cl_effects_water.script by msc_transpiler.
// Player client-side effects
// Splashing effects
// ================

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerClEffectsWater
{
	// Constants
	string SPRITE_1 = "wsplash3.spr";
	float OFS_POS = 5.0f;
	float OFS_NEG = -5.0f;
	int OFS_POS2 = 15;
	int OFS_NEG2 = -15;
	int BIG_SPLASH_SPEED = 300;
	string BIG_SPLASH_SND = "body/splash1.wav";

	// game_playermove
	// Thothie DEC2010_31 - Check if every entity on the map is in water, every frame?
	// - hell now, performance budjget
	// {  game_render	//1: Index of entity being rendered  |  2: "1" == Rendering In Mirror
	// if !PARAM2
	// if $getcl(PARAM1,inwater)
	// if !$getcl(PARAM1,underwater)
	// local l.pos $getcl(PARAM1,waterorigin)
	// if l.pos isnot '0'
	// local l.speed $veclen($getcl(PARAM1,velocity))
	// if l.speed
	// local l.splashdelay game.time
	// subtract l.splashdelay $getcl(PARAM1,baseline.fuser3)
	// if l.splashdelay > 0.2
	// if( l.speed < BIG_SPLASH_SPEED ) callevent water_createsplash l.pos	//small splash
	// else calleventloop 3 water_createsplash_big l.pos			//3 big splashes
	// cleffect setprop PARAM1 baseline.fuser3 	game.time
	// if PARAM1 != game.localplayer.index
	// if $rand(0,3) == 0
	// callevent water_getsnd_wade
	// sound.play3d water.snd game.sound.maxvol l.pos
	// }
	// Called from physics
	void PlayerClEffectsWater_OnGamePlayermove()
	{
		if (Float(Eval("game.pmove.oldwaterlevel")) == 0.0f && Truthy(Eval("game.pmove.waterlevel")))
		{
			// Entered water
			if (Float(Eval("game.pmove.fallvelocity")) < BIG_SPLASH_SPEED)
				OnWaterGetsndWade();
			else
				SetVar("water.snd", BIG_SPLASH_SND);

			LegacyCommand("sound.pm_play", "water.snd", Eval("game.sound.maxvol"), Eval("const.snd.voice"));
		}
	}

	// water_createsplash
	// 1: Splash Origin
	void PlayerClEffectsWater_OnWaterCreatesplash(string splashOrigin = "")
	{
		splashOrigin = Text(Vec(splashOrigin) + Vector3(RandomInt(int(OFS_NEG), int(OFS_POS)), RandomInt(int(OFS_NEG), int(OFS_POS)), RandomInt(0, 1)));
		SetVar("water.splashscale", 0.2f);
		ClientEffect("tempent", "sprite", SPRITE_1, splashOrigin, "setup_sprite1_splash");
	}

	// water_createsplash_big
	// 1: Splash Origin
	void PlayerClEffectsWater_OnWaterCreatesplashBig(string splashOrigin = "")
	{
		splashOrigin = Text(Vec(splashOrigin) + Vector3(RandomInt(OFS_NEG2, OFS_POS2), RandomInt(OFS_NEG2, OFS_POS2), RandomInt(-3, 0)));
		SetVar("water.splashscale", 1);
		ClientEffect("tempent", "sprite", SPRITE_1, splashOrigin, "setup_sprite1_splash");
	}

	// water_getsnd_wade
	void PlayerClEffectsWater_OnWaterGetsndWade()
	{
		SetVar("water.snd", "player/pl_wade");
		LegacyCommand("stradd", "water.snd", RandomInt(1, 4));
		LegacyCommand("stradd", "water.snd", ".wav");
	}

	// setup_sprite1_splash
	void PlayerClEffectsWater_OnSetupSprite1Splash()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "framerate", 20);
		ClientEffect("tempent", "set_current_prop", "frames", 14);
		ClientEffect("tempent", "set_current_prop", "scale", "water.splashscale");
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePlayermove() { PlayerClEffectsWater_OnGamePlayermove(); } // game_playermove
	void OnWaterCreatesplash(string splashOrigin = "") { PlayerClEffectsWater_OnWaterCreatesplash(splashOrigin); } // water_createsplash
	void OnWaterCreatesplashBig(string splashOrigin = "") { PlayerClEffectsWater_OnWaterCreatesplashBig(splashOrigin); } // water_createsplash_big
	void OnWaterGetsndWade() { PlayerClEffectsWater_OnWaterGetsndWade(); } // water_getsnd_wade
	void OnSetupSprite1Splash() { PlayerClEffectsWater_OnSetupSprite1Splash(); } // setup_sprite1_splash

	// This file's events and timers by their .script names
	bool PlayerClEffectsWater_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_playermove") { OnGamePlayermove(); return true; }
		if (name == "setup_sprite1_splash") { OnSetupSprite1Splash(); return true; }
		if (name == "water_createsplash") { OnWaterCreatesplash(Param(params, 0)); return true; }
		if (name == "water_createsplash_big") { OnWaterCreatesplashBig(Param(params, 0)); return true; }
		if (name == "water_getsnd_wade") { OnWaterGetsndWade(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_cl_effects_water"]
shared class PlayerClEffectsWaterScript : ScriptEntity, PlayerClEffectsWater
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("wsplash3.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerClEffectsWater_DispatchEvent(name, params);
	}
}
