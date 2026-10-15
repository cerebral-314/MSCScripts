#pragma context server

// Converted from nashalrath/lightning_strike_cl.script by msc_transpiler.
// strikes below [min_z] are not scanned for

#include "runtime/ScriptEntity.as"

[script "nashalrath/lightning_strike_cl"]
class LightningStrikeCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	string FX_STRIKE_TIME = "FX_STRIKE_TIME";
	Vector3 FX_GROUND = Vector3();
	float GLOW_SIZE = 0.0f;
	string LIGHT_ID = "LIGHT_ID";
	bool FX_ACTIVE = false;

	// client_activate
	// <pos> <time>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_STRIKE_TIME = hand; // Time it takes before lightning strikes

		FX_GROUND = FX_ORIGIN;
		FX_GROUND.z = GroundHeight(FX_GROUND);

		CallEventOrDelay(FX_STRIKE_TIME, "do_strike");
		if (!(Float(FX_STRIKE_TIME) > 0.0f)) // Avoid doing extra fx if the strike time is instant
			return;

		GLOW_SIZE = 1.0f;
		ClientEffect("light", "new", FX_GROUND, 1, Vector3(255, 255, 0), 5.0f);
		LIGHT_ID = Eval("game.script.last_light_id");

		SetCallback("render", "enable");

		PlaySound3D("magic/bolt_start.wav", 10, FX_GROUND);

		FX_ACTIVE = true;
		ClientEffect("tempent", "sprite", "3dmflaora.spr", FX_GROUND, "setup_glow_sprite", "update_glow_sprite");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!FX_ACTIVE)
			return;
		if (GLOW_SIZE < 255.0f)
			GLOW_SIZE += 1.0f;
		ClientEffect("light", LIGHT_ID, FX_GROUND, GLOW_SIZE, Vector3(255, 255, 0), 1.0f);
	}

	// do_strike
	void OnDoStrike()
	{
		ClientEffect("beam_points", FX_ORIGIN, FX_GROUND, "lgtning.spr", 2.0f, 30, 1, 0.8f, 0.5f, 30, Vector3(255, 255, 0));

		LegacyCommand("sound.setvolume", 5, "weather/Storm_exclamation.wav", 10);
		PlaySound(5, 10, "weather/Storm_exclamation.wav");

		CallEventDelayed(3.0f, "remove_fx");

		if (!(Float(FX_STRIKE_TIME) > 0.0f))
			return;
		PlaySound3D("weather/lightning.wav", 10, FX_GROUND);

		ClientEffect("tempent", "sprite", "3dmflaora.spr", FX_GROUND, "setup_spit_sprite");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", FX_GROUND, "setup_spit_sprite");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", FX_GROUND, "setup_spit_sprite");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", FX_GROUND, "setup_spit_sprite");
		ClientEffect("tempent", "sprite", "3dmflaora.spr", FX_GROUND, "setup_spit_sprite");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// update_glow_sprite
	void OnUpdateGlowSprite()
	{
		if (!FX_ACTIVE)
			return;
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (!(curScale < 6.0f))
			return;
		curScale += 0.01f;
		ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
	}

	// setup_glow_sprite
	void OnSetupGlowSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 3.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 128);
	}

	// setup_spit_sprite
	void OnSetupSpitSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 5);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		float rndAng = Random(0, 359.99f);
		float rndVel = Random(100, 200);
		ClientEffect("tempent", "set_current_prop", "velocity", RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndVel, rndVel)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxStrikeTime() {} // FX_STRIKE_TIME

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_strike") { OnDoStrike(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_glow_sprite") { OnSetupGlowSprite(); return true; }
		if (name == "setup_spit_sprite") { OnSetupSpitSprite(); return true; }
		if (name == "update_glow_sprite") { OnUpdateGlowSprite(); return true; }
		return false;
	}
}
