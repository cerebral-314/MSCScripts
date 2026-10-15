#pragma context server

// Converted from phlames/phlame_bird_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "phlames/phlame_bird_cl"]
class PhlameBirdCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	float CLOUD_YAW = 0.0f;

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		FX_ACTIVE = true;
		OnFireBreathLoop();
		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// fire_breath_loop
	void OnFireBreathLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.2f, "fire_breath_loop");
		CLOUD_YAW = Float(LegacyFunction("getcl", FX_OWNER, "angles.yaw"));
		ClientEffect("tempent", "sprite", "explode1.spr", LegacyFunction("getcl", FX_OWNER, "attachment0"), "setup_fire_cloud", "update_fire_cloud");
		ClientEffect("tempent", "sprite", "explode1.spr", LegacyFunction("getcl", FX_OWNER, "attachment0"), "setup_fire_cloud", "update_fire_cloud");
		ClientEffect("tempent", "sprite", "explode1.spr", LegacyFunction("getcl", FX_OWNER, "attachment0"), "setup_fire_cloud", "update_fire_cloud");
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

	// update_fire_cloud
	void OnUpdateFireCloud()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (!(curScale < 2.0f))
			return;
		curScale += 0.05f;
		ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
	}

	// setup_fire_cloud
	void OnSetupFireCloud()
	{
		float startScale = Random(0.25f, 0.5f);
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 9);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", startScale);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		if (RandomInt(1, 3) == 1)
			ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 255, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", startScale);

		float rndRl = Random(-20, 20);
		float rndUd = Random(-50, -100);
		Vector3 cloudVel = RelativeVelocity(Vector3(20, CLOUD_YAW, 0), Vector3(rndRl, Random(300, 400), rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
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
		if (name == "fire_breath_loop") { OnFireBreathLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_fire_cloud") { OnSetupFireCloud(); return true; }
		if (name == "update_fire_cloud") { OnUpdateFireCloud(); return true; }
		return false;
	}
}
