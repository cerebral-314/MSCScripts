#pragma context server

// Converted from nashalrath/wind_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "nashalrath/wind_cl"]
class WindCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	float FX_SCALE = 0.0f;
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;

	// unnamed block (timer)
	void WindCl_Timer()
	{
		CallEventDelayed(9.0f, "WindCl_Timer");
		if (!FX_ACTIVE)
			return;
		PlaySound3D("magic/vent1.wav", 10, FX_ORIGIN);
	}

	// client_activate
	// <origin> <scale> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		DebugPrint("****** wind client_activate");

		FX_ORIGIN = Vec(owner);
		FX_SCALE = Float(hand);
		FX_DURATION = Float(fxColor);

		FX_ACTIVE = true;
		PlaySound3D("magic/vent1.wav", 10, FX_ORIGIN);
		ClientEffect("tempent", "model", "monsters/monster_extras.mdl", FX_ORIGIN, "setup_wind", "update_wind");
		CallEventDelayed(FX_DURATION, "end_fx");
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

	// update_wind
	void OnUpdateWind()
	{
		if (FX_ACTIVE)
			return;
		ClientEffect("tempent", "set_current_prop", "origin", Vector3(9999, 9999, 9999));
	}

	// setup_wind
	void OnSetupWind()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "scale", FX_SCALE);
		ClientEffect("tempent", "set_current_prop", "body", 0);
		ClientEffect("tempent", "set_current_prop", "sequence", 2);
		ClientEffect("tempent", "set_current_prop", "frames", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 100);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(9.0f, "WindCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_wind") { OnSetupWind(); return true; }
		if (name == "update_wind") { OnUpdateWind(); return true; }
		if (name == "WindCl_Timer") { WindCl_Timer(); return true; }
		return false;
	}
}
