#pragma context server

// Converted from effects/sfx_explode.script by msc_transpiler.
// Brief explosion with outward rotating sprites by Thothie

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SfxExplode
{
	// Constants
	string SPRITE_NAME = "explode1.spr";
	Vector3 SPRITE_COLOR = Vector3();
	int SPRITE_RENDERAMT = 200;
	string SPRITE_RENDERMODE = "add";
	int SPRITE_FRAMERATE = 30;
	int SPRITE_NFRAMES = 9;
	float SPRITE_SCALE = 1.0f;
	int SPRITE_VOF = 32;
	string SOUND_BURST = "weapons/explode3.wav";

	// Variables (an unset .script variable reads as its own name)
	string FX_CENTER = "FX_CENTER";
	string FX_RADIUS = "FX_RADIUS";
	float FX_DURATION = 0.0f;
	float CYCLE_ANGLE = 0.0f;

	// client_activate
	// <origin> <radius>
	void SfxExplode_OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_CENTER = owner;
		FX_RADIUS = hand;

		// fx duration determined by radius (gives more time for sprites to spread)
		FX_DURATION = 1.0f;
		if (Float(FX_RADIUS) < 64.0f)
			FX_DURATION = 0.5f;
		if (Float(FX_RADIUS) > 256.0f)
			FX_DURATION = 2.0f;

		float fxRadius = Float(FX_RADIUS);
		fxRadius *= 2.0f;

		ClientEffect("light", "new", FX_CENTER, fxRadius, SPRITE_COLOR, 2.0f);

		CallEventDelayed(3.0f, "remove_me");
		CYCLE_ANGLE = 0.0f;
		for (int i = 0; i < 17; i++)
		{
			loopIteration = i;
			OnCreateSprites();
		}

		PlaySound3D(SOUND_BURST, 10, Vec(FX_CENTER));
	}

	// remove_me
	void SfxExplode_OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// create_sprites
	void SfxExplode_OnCreateSprites()
	{
		Vector3 sprPos = Vec(FX_CENTER);
		sprPos += RelativePosition(Vector3(0, CYCLE_ANGLE, 0), Vector3(0, 1, SPRITE_VOF));
		ClientEffect("tempent", "sprite", SPRITE_NAME, sprPos, "setup_sprite", "update_sprite");
		CYCLE_ANGLE += 20.0f;
	}

	// update_sprite
	void SfxExplode_OnUpdateSprite()
	{
		// dbg *** update_sprite
		// not sure if this rotation is working :\
		Vector3 spriteOrg = Vec(LegacyFunction("getcl", "FX_OWNER", "origin"));
		float myAngle = Float(Eval("game.tempent.fuser1"));

		myAngle += 20.0f;
		if (myAngle > 359.0f)
			myAngle = 0.0f;
		ClientEffect("tempent", "set_current_prop", "fuser1", myAngle);
		spriteOrg += RelativePosition(Vector3(0, myAngle, 0), Vector3(0, Float(FX_RADIUS), SPRITE_VOF));
	}

	// setup_sprite
	void SfxExplode_OnSetupSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "rendercolor", SPRITE_COLOR);
		ClientEffect("tempent", "set_current_prop", "renderamt", SPRITE_RENDERAMT);
		ClientEffect("tempent", "set_current_prop", "rendermode", SPRITE_RENDERMODE);
		ClientEffect("tempent", "set_current_prop", "framerate", SPRITE_FRAMERATE);
		ClientEffect("tempent", "set_current_prop", "frames", SPRITE_NFRAMES);
		ClientEffect("tempent", "set_current_prop", "scale", SPRITE_SCALE);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "fuser1", CYCLE_ANGLE);

		Vector3 spriteVel = RelativeVelocity(Vector3(0, CYCLE_ANGLE, 0), Vector3(0, 200, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", spriteVel);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "") { SfxExplode_OnClientActivate(owner, hand, fxColor, lifetime, sprite, flag, specialFlags, glowRadius); } // client_activate
	void OnRemoveMe(string caller = "") { SfxExplode_OnRemoveMe(caller); } // remove_me
	void OnCreateSprites() { SfxExplode_OnCreateSprites(); } // create_sprites
	void OnUpdateSprite() { SfxExplode_OnUpdateSprite(); } // update_sprite
	void OnSetupSprite() { SfxExplode_OnSetupSprite(); } // setup_sprite

	// This file's events and timers by their .script names
	bool SfxExplode_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_sprites") { OnCreateSprites(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_sprite") { OnSetupSprite(); return true; }
		if (name == "update_sprite") { OnUpdateSprite(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/sfx_explode"]
shared class SfxExplodeScript : ScriptEntity, SfxExplode
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SfxExplode_DispatchEvent(name, params);
	}
}
