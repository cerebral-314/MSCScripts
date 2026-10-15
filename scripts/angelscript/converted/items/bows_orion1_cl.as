#pragma context server

// Converted from items/bows_orion1_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/bows_orion1_cl"]
class BowsOrion1Cl : ScriptEntity
{
	// Constants
	Vector3 BALL_OFS = Vector3();

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;
	float ACT_SCALE = 0.0f;

	// client_activate
	// <owner>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		Vector3 fxOrigin = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		fxOrigin.z += 28.0f;
		string viewAng = LegacyFunction("getcl", FX_OWNER, "viewangles");
		fxOrigin += RelativePosition(Vec(viewAng), BALL_OFS);

		FX_ACTIVE = true;
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", fxOrigin, "setup_ball", "update_ball");
	}

	// update_ball
	void OnUpdateBall()
	{
		if (FX_ACTIVE)
		{
			Vector3 fxOrigin = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
			fxOrigin.z += 28.0f;
			string viewAng = LegacyFunction("getcl", FX_OWNER, "viewangles");
			fxOrigin += RelativePosition(Vec(viewAng), BALL_OFS);
			ClientEffect("tempent", "set_current_prop", "origin", fxOrigin);
			float curScale = Float(Eval("game.tempent.fuser1"));
			if (curScale < ACT_SCALE)
			{
				curScale += 0.05f;
				ClientEffect("tempent", "set_current_prop", "scale", curScale);
				ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			}
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
		}
	}

	// add_charge
	void OnAddCharge()
	{
		ACT_SCALE += 0.75f;
	}

	// charge_release
	void OnChargeRelease()
	{
		FX_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_ball
	void OnSetupBall()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 100);
		ClientEffect("tempent", "set_current_prop", "body", 13);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 500);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 20);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_charge") { OnAddCharge(); return true; }
		if (name == "charge_release") { OnChargeRelease(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_ball") { OnSetupBall(); return true; }
		if (name == "update_ball") { OnUpdateBall(); return true; }
		return false;
	}
}
