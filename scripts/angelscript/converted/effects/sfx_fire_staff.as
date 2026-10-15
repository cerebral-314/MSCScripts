#pragma context server

// Converted from effects/sfx_fire_staff.script by msc_transpiler.
// phlames staff burst

#include "runtime/ScriptEntity.as"

[script "effects/sfx_fire_staff"]
class SfxFireStaff : ScriptEntity
{
	// client_activate
	// <origin>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		Vector3 fxOrigin = Vec(owner);

		PlaySound3D("magic/dragon_fire.wav", 10, fxOrigin);
		ClientEffect("light", "new", fxOrigin, 128, Vector3(255, 128, 64), 1.5f);
		ClientEffect("tempent", "model", "weapons/magic/seals.mdl", fxOrigin, "setup_seal");
		fxOrigin.z += 16.0f;
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", fxOrigin, "setup_fire_ring");
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_seal
	void OnSetupSeal()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.5f);
		ClientEffect("tempent", "set_current_prop", "fade", "none");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0.0f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "normal");
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "body", 1);
		ClientEffect("tempent", "set_current_prop", "frames", 39);
	}

	// setup_fire_ring
	void OnSetupFireRing()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.5f);
		ClientEffect("tempent", "set_current_prop", "body", 51);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.5f);
		ClientEffect("tempent", "set_current_prop", "sequence", 8);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 4.5f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_fire_ring") { OnSetupFireRing(); return true; }
		if (name == "setup_seal") { OnSetupSeal(); return true; }
		return false;
	}
}
