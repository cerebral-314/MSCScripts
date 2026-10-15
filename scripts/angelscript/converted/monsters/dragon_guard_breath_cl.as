#pragma context server

// Converted from monsters/dragon_guard_breath_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/dragon_guard_breath_cl"]
class DragonGuardBreathCl : ScriptEntity
{
	// Constants
	float FX_DURATION = 5.0f;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string BREATH_TYPE = "BREATH_TYPE";
	string SPR_NAME = "SPR_NAME";
	string SPR_EVENT = "SPR_EVENT";
	string BREATH_ON = "BREATH_ON";
	string CLOUD_ANG = "CLOUD_ANG";

	// client_activate
	// <owner> <type:cold|fire|poison>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		BREATH_TYPE = hand;

		DebugPrint("*** breath_activate " + FX_OWNER + " " + BREATH_TYPE);

		CallEventDelayed(FX_DURATION, "end_fx");

		if (BREATH_TYPE == "cold")
		{
			SPR_NAME = "rain_mist.spr";
			SPR_EVENT = "setup_cloud_cold";
		}

		if (BREATH_TYPE == "fire")
		{
			SPR_NAME = "explode1.spr";
			SPR_EVENT = "setup_cloud_fire";
		}

		if (BREATH_TYPE == "poison")
		{
			SPR_NAME = "poison_cloud.spr";
			SPR_EVENT = "setup_cloud_poison";
		}

		BREATH_ON = "1";
		OnBreathLoop();
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		BREATH_ON = "0";
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		CallEventDelayed(0.2f, "breath_loop");
		string cloudOrg = LegacyFunction("getcl", FX_OWNER, "attachment0");
		CLOUD_ANG = LegacyFunction("getcl", FX_OWNER, "angles.yaw");
		ClientEffect("tempent", "sprite", SPR_NAME, cloudOrg, SPR_EVENT, "update_cloud");
		ClientEffect("tempent", "sprite", SPR_NAME, cloudOrg, SPR_EVENT, "update_cloud");
		ClientEffect("tempent", "sprite", SPR_NAME, cloudOrg, SPR_EVENT, "update_cloud");
	}

	// setup_cloud_cold
	void OnSetupCloudCold()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.5f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 9);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.01f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(128, 128, 255));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.01f);

		float rndRl = Random(-20, 20);
		float rndUd = Random(-20, 20);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, Random(300, 400), rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// update_cloud
	void OnUpdateCloud()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (curScale < 1.5f)
		{
			curScale += 0.05f;
			ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			ClientEffect("tempent", "set_current_prop", "scale", curScale);
		}
	}

	// setup_cloud_fire
	void OnSetupCloudFire()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.5f);
		ClientEffect("tempent", "set_current_prop", "framerate", 10);
		ClientEffect("tempent", "set_current_prop", "frames", 9);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.2f);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 200);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 0, 0));
		if (RandomInt(1, 3) == 1)
			ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 255, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0.005f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.2f);

		float rndRl = Random(-20, 20);
		float rndUd = Random(-20, 20);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, Random(300, 400), rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// setup_cloud_poison
	void OnSetupCloudPoison()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.5f);
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

		float rndRl = Random(-20, 20);
		float rndUd = Random(-20, 20);
		Vector3 cloudVel = RelativeVelocity(Vector3(0, Float(CLOUD_ANG), 0), Vector3(rndRl, Random(300, 400), rndUd));
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
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud_cold") { OnSetupCloudCold(); return true; }
		if (name == "setup_cloud_fire") { OnSetupCloudFire(); return true; }
		if (name == "setup_cloud_poison") { OnSetupCloudPoison(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		return false;
	}
}
