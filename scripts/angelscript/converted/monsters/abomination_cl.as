#pragma context server

// Converted from monsters/abomination_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/abomination_cl"]
class AbominationCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string BREATH_TYPE = "BREATH_TYPE";
	bool FX_ACTIVE = false;
	string ATTACHMENT_POS = "ATTACHMENT_POS";
	string CLOUD_ANG = "CLOUD_ANG";

	// unnamed block (timer)
	void AbominationCl_Timer()
	{
		CallEventDelayed(0.01f, "AbominationCl_Timer");
		if (!FX_ACTIVE)
			return;
		ATTACHMENT_POS = LegacyFunction("getcl", FX_OWNER, "attachment0");
	}

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		BREATH_TYPE = hand;
		if (BREATH_TYPE.isEmpty())
			BREATH_TYPE = "0";
		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), 256, Vector3(0, 255, 0), 1.0f);
		SetCallback("render", "enable");
		FX_ACTIVE = true;
		OnBreathLoop();
		CallEventDelayed(15.0f, "end_fx"); // in case dies mid-breath
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!FX_ACTIVE)
			return;
		OnMakeCloud(LegacyFunction("getcl", FX_OWNER, "attachment0"), LegacyFunction("getcl", FX_OWNER, "angles.yaw"));
		CallEventDelayed(0.2f, "breath_loop");
	}

	// make_cloud
	// <origin> <angles>
	void OnMakeCloud(string origin = "", string angles = "")
	{
		// dbg make_cloud PARAM1 PARAM2
		CLOUD_ANG = angles;
		if (Float(BREATH_TYPE) == 0.0f)
		{
			ClientEffect("tempent", "sprite", "poison_cloud.spr", origin, "setup_cloud", "update_cloud");
			ClientEffect("tempent", "sprite", "poison_cloud.spr", origin, "setup_cloud", "update_cloud");
			ClientEffect("tempent", "sprite", "poison_cloud.spr", origin, "setup_cloud", "update_cloud");
		}
		else
		{
			ClientEffect("tempent", "sprite", "explode1.spr", origin, "setup_fire_cloud", "update_cloud");
			ClientEffect("tempent", "sprite", "explode1.spr", origin, "setup_fire_cloud", "update_cloud");
			ClientEffect("tempent", "sprite", "explode1.spr", origin, "setup_fire_cloud", "update_cloud");
		}
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		if (!FX_ACTIVE)
			return;
		FX_ACTIVE = false;
		CallEventDelayed(1.25f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// update_cloud
	void OnUpdateCloud()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (curScale < 2.0f)
		{
			curScale += 0.1f;
			ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			ClientEffect("tempent", "set_current_prop", "scale", curScale);
		}
	}

	// setup_cloud
	void OnSetupCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);

		float rndRl = Random(-10, 10);
		float rndUd = Random(-30, 30);
		float rndFd = Random(300, 400);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, rndFd, rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// setup_fire_cloud
	void OnSetupFireCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 9);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.5f, 1));
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		if (RandomInt(1, 3) == 1)
			ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 255, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);

		float rndRl = Random(-20, 20);
		float rndUd = Random(-20, 20);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, Random(300, 400), rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.01f, "AbominationCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "make_cloud") { OnMakeCloud(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "setup_fire_cloud") { OnSetupFireCloud(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		if (name == "AbominationCl_Timer") { AbominationCl_Timer(); return true; }
		return false;
	}
}
