#pragma context server

// Converted from monsters/ant_fire_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/ant_fire_cl"]
class AntFireCl : ScriptEntity
{
	// Constants
	string FLAME_SPRITE = "explode1.spr";
	int N_FRAMES = 9;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	string FX_DEATH_DELAY = "FX_DEATH_DELAY";
	bool FX_ACTIVE = false;
	string CLOUD_ANG = "CLOUD_ANG";

	// client_activate
	// <owner> <duration> <reach>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		FX_DEATH_DELAY = fxColor;
		FX_ACTIVE = true;
		OnBreathLoop();
		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		// make sure sprites have time to expire before removal
		float delayRemove = Float(FX_DEATH_DELAY);
		delayRemove *= 2.0f;
		CallEventDelayed(delayRemove, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.1f, "breath_loop");

		string cloudOrg = LegacyFunction("getcl", FX_OWNER, "attachment0"); // add an attach to model
		CLOUD_ANG = LegacyFunction("getcl", FX_OWNER, "angles.yaw");
		ClientEffect("tempent", "sprite", FLAME_SPRITE, cloudOrg, "setup_cloud");
		ClientEffect("tempent", "sprite", FLAME_SPRITE, cloudOrg, "setup_cloud");
	}

	// setup_cloud
	void OnSetupCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DEATH_DELAY);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", "N_FRAME");
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.5f, 1));
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		float rndRl = Random(-20, 20);
		float rndUd = Random(-20, 20);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, Random(300, 400), rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION
	void OnLDelayRemove() {} // L_DELAY_REMOVE

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		return false;
	}
}
