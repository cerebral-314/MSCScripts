#pragma context server

// Converted from monsters/doom_plant_cl.script by msc_transpiler.
// CL effects for Doom Tree (just shoots spurs)

#include "runtime/ScriptEntity.as"

[script "monsters/doom_plant_cl"]
class DoomPlantCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	string SPUR_YAW = "SPUR_YAW";
	string TRAIL_ANG = "TRAIL_ANG";

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_DURATION = Float(owner);
		FX_ACTIVE = true;
		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(1.1f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// shoot_spur
	// <start> <yaw>
	void OnShootSpur(string startPosition = "", string yaw = "")
	{
		if (!FX_ACTIVE)
			return;
		SPUR_YAW = yaw;
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", startPosition, "setup_spur", "update_spur");
	}

	// update_spur
	void OnUpdateSpur()
	{
		if (!(GameTime() > 0.0f))
			return;
		// setvard NEXT_SHADOW game.time
		// add NEXT_SHADOW 0.05
		string myOrg = Eval("game.tempent.origin");
		TRAIL_ANG = Eval("game.tempent.angles");
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", myOrg, "spur_trail");
	}

	// spur_trail
	void OnSpurTrail()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.15f);
		ClientEffect("tempent", "set_current_prop", "fade", 0.15f);
		ClientEffect("tempent", "set_current_prop", "body", 24);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.5f);
		ClientEffect("tempent", "set_current_prop", "sequence", 7);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", 50);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "angles", TRAIL_ANG);
	}

	// setup_spur
	void OnSetupSpur()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "body", 24);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.5f);
		ClientEffect("tempent", "set_current_prop", "sequence", 7);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, Float(SPUR_YAW), 0));
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vector3(0, Float(SPUR_YAW), 0), Vector3(0, 1000, 0)));
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
		if (name == "setup_spur") { OnSetupSpur(); return true; }
		if (name == "shoot_spur") { OnShootSpur(Param(params, 0), Param(params, 1)); return true; }
		if (name == "spur_trail") { OnSpurTrail(); return true; }
		if (name == "update_spur") { OnUpdateSpur(); return true; }
		return false;
	}
}
