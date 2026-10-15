#pragma context server

// Converted from monsters/elemental_earth_cl.script by msc_transpiler.
// cl effects for earth elemental, instanced
// burst is weapons/projectiles.mdl #54
// rock is weapons/projectiles.mdl #4 (smaller one on #5)

#include "runtime/ScriptEntity.as"

[script "monsters/elemental_earth_cl"]
class ElementalEarthCl : ScriptEntity
{
	// Constants
	string SOUND_SPAWN = "magic/energy1_loud.wav";
	string FX_SHIELD_SPRITE = "rain_ripple.spr";
	int FX_SHIELD_SPRITE_FRAMES = 15;
	Vector3 FX_SHIELD_COLOR = Vector3();
	float FX_SHIELD_SCALE = 2.5f;
	float FX_SHIELD_DURATION = 1.0f;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	Vector3 FX_POS = Vector3();
	bool FX_ACTIVE = false;
	float ROCK_START = 0.0f;
	bool ROCK_FALLING = false;
	float FX_SHIELD_YAW = 0.0f;

	// client_activate
	// <owner> <type> [params...]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;

		if (hand == "spawn_rock")
		{
			FX_POS = Vec(fxColor);
			// dbg *** $currentscript client_activate FX_POS
			FX_ACTIVE = true;
			ROCK_START = GameTime();
			ClientEffect("tempent", "model", "weapons/projectiles.mdl", FX_POS, "setup_rock", "update_rock", "collide_rock");
			ClientEffect("tempent", "model", "weapons/projectiles.mdl", FX_POS, "setup_burst", "update_burst");
			PlaySound3D(SOUND_SPAWN, 10, FX_POS);
			CallEventDelayed(10.0f, "end_fx");
		}

		if (hand == "do_shield")
		{
			FX_ACTIVE = true;
			OnShieldHit();
			CallEventOrDelay(fxColor, "end_fx");
		}
	}

	// setup_burst
	void OnSetupBurst()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 0.01f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "velocity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", 54);
		ClientEffect("tempent", "set_current_prop", "sequence", 6);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add"); // additive
		ClientEffect("tempent", "set_current_prop", "color", Vector3(0, 64, 255));
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(180, 0, 0));
		float rockStart = ROCK_START + 1.0f;
		ClientEffect("tempent", "set_current_prop", "fuser1", rockStart);
	}

	// update_burst
	void OnUpdateBurst()
	{
		if (!FX_ACTIVE)
			return;
		float curStep = GameTime() - Float(Eval("game.tempent.fuser1"));

		// local CUR_SCALE game.tempent.fuser2
		if (curStep < 0.5f)
		{
			float curScale = Ratio(curStep, 0.01f, 1);
			// cleffect tempent set_current_prop fuser2 CUR_SCALE
			ClientEffect("tempent", "set_current_prop", "scale", curScale);
		}
		else if (curStep < 1.0f)
		{
			// fade out
			float rend = Ratio(curStep, 512, 0);
			ClientEffect("tempent", "set_current_prop", "renderamt", rend);
		}
	}

	// setup_rock
	void OnSetupRock()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 1.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "velocity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", 5);
		ClientEffect("tempent", "set_current_prop", "sequence", 6);
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", 0);
		ClientEffect("tempent", "set_current_prop", "bounce", 0);
		float rockStart = ROCK_START + 1.0f;
		ClientEffect("tempent", "set_current_prop", "fuser1", rockStart);
	}

	// update_rock
	void OnUpdateRock()
	{
		if (!FX_ACTIVE)
			return;
		if (ROCK_FALLING)
			return;
		float curStep = GameTime() - Float(Eval("game.tempent.fuser1")); // should result in 0 to 1
		// dbg *** $currentscript update_rock CUR_STEP vs game.time [ ROCK_FALLING ]
		if (curStep < 1.0f)
		{
			float curRend = Ratio(curStep, 0, 255);
			curRend = int(curRend);
			ClientEffect("tempent", "set_current_prop", "renderamt", curRend);
		}
		else
		{
			// dbg *** $currentscript update_rock GRAVITY
			ClientEffect("tempent", "set_current_prop", "renderamt", 255);
			ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, -600)); // After 2 seconds, it drops at a velocity of 600. no gravity.
			ROCK_FALLING = true;
		}
	}

	// collide_rock
	void OnCollideRock()
	{
		PlaySound3D("fire.wav", 10, Vec(Eval("game.tempent.origin")));
		CallEventDelayed(1.0f, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// shield_hit
	void OnShieldHit(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null)
	{
		Vector3 pos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		string ownerAngs = LegacyFunction("getcl", FX_OWNER, "angles");
		FX_SHIELD_YAW = Vec(ownerAngs).y;

		pos += RelativePosition(Vector3(0, FX_SHIELD_YAW, 0), Vector3(0, 32, 64));
		// needs two sprite instances, as somehow this sprite is one sided
		ClientEffect("tempent", "sprite", FX_SHIELD_SPRITE, pos, "setup_shield");
		ClientEffect("tempent", "sprite", FX_SHIELD_SPRITE, pos, "setup_shield_negyaw");
	}

	// setup_shield
	void OnSetupShield()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_SHIELD_DURATION);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", FX_SHIELD_COLOR);
		ClientEffect("tempent", "set_current_prop", "scale", FX_SHIELD_SCALE);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, FX_SHIELD_YAW, 0));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", FX_SHIELD_SPRITE_FRAMES);
	}

	// setup_shield_negyaw
	void OnSetupShieldNegyaw()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_SHIELD_DURATION);
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", FX_SHIELD_COLOR);
		ClientEffect("tempent", "set_current_prop", "scale", FX_SHIELD_SCALE);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		float negYaw = FX_SHIELD_YAW + 180.0f;
		if (negYaw > 359.99f)
			negYaw -= 359.99f;
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, negYaw, 0));
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", FX_SHIELD_SPRITE_FRAMES);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "collide_rock") { OnCollideRock(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_burst") { OnSetupBurst(); return true; }
		if (name == "setup_rock") { OnSetupRock(); return true; }
		if (name == "setup_shield") { OnSetupShield(); return true; }
		if (name == "setup_shield_negyaw") { OnSetupShieldNegyaw(); return true; }
		if (name == "shield_hit") { OnShieldHit(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "update_burst") { OnUpdateBurst(); return true; }
		if (name == "update_rock") { OnUpdateRock(); return true; }
		return false;
	}
}
