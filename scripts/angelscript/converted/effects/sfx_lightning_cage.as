#pragma context server

// Converted from effects/sfx_lightning_cage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_lightning_cage"]
class SfxLightningCage : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float FX_DURATION = 0.0f;
	Vector3 FX_ORIGIN = Vector3();
	bool FX_ACTIVE = false;
	bool FX_SPHERE_SIZE = false;

	// client_activate
	// <duration> <start_origin>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		DebugPrint("**** client_activate force_cage_cl " + owner + " " + hand + " " + fxColor);
		FX_DURATION = Float(owner);
		FX_ORIGIN = Vec(hand);
		FX_ACTIVE = true;
		FX_SPHERE_SIZE = true;
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", FX_ORIGIN, "setup_efield", "update_efield");
		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// update_efield
	void OnUpdateEfield()
	{
		if (FX_ACTIVE)
			return;
		ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.1f);
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		DebugPrint("**** force_cage_cl end_fx");
		FX_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_efield
	void OnSetupEfield()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "body", 63);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "sequence", 8);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
		ClientEffect("tempent", "set_current_prop", "scale", FX_SPHERE_SIZE);
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
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_efield") { OnSetupEfield(); return true; }
		if (name == "update_efield") { OnUpdateEfield(); return true; }
		return false;
	}
}
