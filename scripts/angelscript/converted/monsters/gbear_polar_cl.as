#pragma context server

// Converted from monsters/gbear_polar_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/gbear_polar_cl"]
class GbearPolarCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	string BREATH_ON = "BREATH_ON";
	Vector3 BREATH_VEL = Vector3();
	float BREATH_ANG = 0.0f;
	string CLOUD_ANG = "CLOUD_ANG";

	// client_activate
	// <owner> <duration> <breath_active>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		BREATH_ON = fxColor;

		if (Truthy(BREATH_ON))
			OnBreathOn();

		CallEventOrDelay(hand, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// quick_breath
	void OnQuickBreath()
	{
		BREATH_VEL = Vec(LegacyFunction("getcl", FX_OWNER, "velocity"));
		BREATH_ANG = Float(LegacyFunction("getcl", FX_OWNER, "angles"));
		BREATH_VEL += RelativePosition(Vec(Text(BREATH_ANG)), Vector3(0, Random(5, 100), 0));
		ClientEffect("tempent", "sprite", "char_breath.spr", LegacyFunction("getcl", FX_OWNER, "attachment0"), "weather_snow_breath");
	}

	// quick_breath_last
	void OnQuickBreathLast()
	{
		BREATH_ON = "0";
		OnQuickBreath();
		OnEndFx();
	}

	// breath_on
	void OnBreathOn(string breathType = "")
	{
		BREATH_ON = "1";
		OnBreathLoop();
	}

	// breath_off
	void OnBreathOff()
	{
		BREATH_ON = "0";
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		CallEventDelayed(0.2f, "breath_loop");
		string cloudOrg = LegacyFunction("getcl", FX_OWNER, "attachment0");
		CLOUD_ANG = LegacyFunction("getcl", FX_OWNER, "angles.yaw");
		ClientEffect("tempent", "sprite", "rain_mist.spr", cloudOrg, "setup_cloud", "update_cloud");
		ClientEffect("tempent", "sprite", "rain_mist.spr", cloudOrg, "setup_cloud", "update_cloud");
		ClientEffect("tempent", "sprite", "rain_mist.spr", cloudOrg, "setup_cloud", "update_cloud");
	}

	// weather_snow_breath
	void OnWeatherSnowBreath()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", "last_frame");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 30);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.3f, 0.75f));
		ClientEffect("tempent", "set_current_prop", "gravity", -0.01f);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", RandomInt(30, 100));
		ClientEffect("tempent", "set_current_prop", "angles", BREATH_ANG);
		ClientEffect("tempent", "set_current_prop", "velocity", BREATH_VEL);
	}

	// setup_cloud
	void OnSetupCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
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
		if (curScale < 2.0f)
		{
			curScale += 0.05f;
			ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			ClientEffect("tempent", "set_current_prop", "scale", curScale);
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "breath_off") { OnBreathOff(); return true; }
		if (name == "breath_on") { OnBreathOn(Param(params, 0)); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "quick_breath") { OnQuickBreath(); return true; }
		if (name == "quick_breath_last") { OnQuickBreathLast(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		if (name == "weather_snow_breath") { OnWeatherSnowBreath(); return true; }
		return false;
	}
}
