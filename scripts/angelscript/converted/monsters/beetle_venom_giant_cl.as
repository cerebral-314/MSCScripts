#pragma context server

// Converted from monsters/beetle_venom_giant_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/beetle_venom_giant_cl"]
class BeetleVenomGiantCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool FX_ACTIVE = false;
	string CLOUD_ANG = "CLOUD_ANG";

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.1f, "fx_loop");

		string cloudOrg = LegacyFunction("getcl", "FX_OWNER", "attachment1");
		CLOUD_ANG = LegacyFunction("getcl", "FX_OWNER", "angles.yaw");
		ClientEffect("tempent", "sprite", "poison_cloud.spr", cloudOrg, "setup_cloud");
	}

	// setup_cloud
	void OnSetupCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");

		float rndRl = Random(-10, 10);
		float rndUd = Random(-220, -180);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, 400, rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		return false;
	}
}
