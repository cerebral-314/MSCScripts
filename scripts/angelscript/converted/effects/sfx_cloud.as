#pragma context server

// Converted from effects/sfx_cloud.script by msc_transpiler.
// Thothie MAR2010_15 - stationary cloud cl effect (ala poison cloud)

#include "runtime/ScriptEntity.as"

[script "effects/sfx_cloud"]
class SfxCloud : ScriptEntity
{
	// Constants
	string SOUND_SPAWN = "ambience/steamburst1.wav";

	// Variables (an unset .script variable reads as its own name)
	string FX_CENTER = "FX_CENTER";
	float FX_DURATION = 0.0f;
	string FX_RADIUS = "FX_RADIUS";
	string FX_COLOR = "FX_COLOR";
	string FX_SPRITE = "FX_SPRITE";
	bool FX_ACTIVE = false;

	// client_activate
	// <origin> <duration> <radius> [color] [sprite]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_CENTER = owner;
		FX_DURATION = Float(hand);
		FX_RADIUS = fxColor;
		FX_COLOR = lifetime;
		FX_SPRITE = sprite;

		if (FX_SPRITE.isEmpty())
			FX_SPRITE = "poison_cloud.spr";
		if (FX_COLOR.isEmpty())
			FX_COLOR = Text(Vector3(0, 255, 0));

		string fxRadius = FX_RADIUS;
		ClientEffect("light", "new", FX_CENTER, fxRadius, FX_COLOR, FX_DURATION);

		FX_ACTIVE = true;
		CallEventDelayed(FX_DURATION, "end_fx");
		OnSmokesLoop();

		PlaySound3D(SOUND_SPAWN, 10, Vec(FX_CENTER));
	}

	// smokes_loop
	void OnSmokesLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.25f, "smokes_loop");
		Vector3 spritePos = Vec(FX_CENTER);
		float rndAng = Random(0, 359.99f);
		float negRad = -Float(FX_RADIUS);
		float rndOfs = Random(negRad, Float(FX_RADIUS));
		spritePos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndOfs, 0));
		ClientEffect("tempent", "sprite", FX_SPRITE, spritePos, "setup_smoke");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(3.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// setup_smoke
	void OnSetupSmoke()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 2.5f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.5f, 1));
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", FX_COLOR);
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_smoke") { OnSetupSmoke(); return true; }
		if (name == "smokes_loop") { OnSmokesLoop(); return true; }
		return false;
	}
}
