#pragma context server

// Converted from nashalrath/dragon_green_mini_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "nashalrath/dragon_green_mini_cl"]
class DragonGreenMiniCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	bool FX_ACTIVE = false;
	string CLOUD_ANG = "CLOUD_ANG";
	string CLOUD_ORG = "CLOUD_ORG";

	// client_activate
	// <owner_model_index> <type>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		if (hand == "breath")
		{
			FX_ACTIVE = true;
			OnBreathLoop();
		}
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.1f, "breath_loop");
		CLOUD_ANG = LegacyFunction("getcl", FX_OWNER, "angles.yaw");
		DebugPrint("breath_loop " + CLOUD_ANG); // testing to see if angles.yaw works cl side
		CLOUD_ORG = LegacyFunction("getcl", FX_OWNER, "attachment0");
		ClientEffect("tempent", "sprite", "poison_cloud.spr", CLOUD_ORG, "setup_cloud");
		ClientEffect("tempent", "sprite", "poison_cloud.spr", CLOUD_ORG, "setup_cloud");
		int count = RandomInt(1, 3);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSpitRocks();
		}
	}

	// spit_rocks
	void OnSpitRocks()
	{
		ClientEffect("tempent", "sprite", "rockgibs.mdl", CLOUD_ORG, "setup_rock");
		ClientEffect("tempent", "sprite", "rockgibs.mdl", CLOUD_ORG, "setup_rock");
		ClientEffect("tempent", "sprite", "rockgibs.mdl", CLOUD_ORG, "setup_rock");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
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
		ClientEffect("tempent", "set_current_prop", "gravity", 1.0f);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");

		float rndRl = Random(-10, 10);
		float rndUd = Random(-420, -280);
		Vector3 cloudVel = RelativeVelocity(Vector3(20, Float(CLOUD_ANG), 0), Vector3(rndRl, 400, rndUd));
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
	}

	// setup_rock
	void OnSetupRock()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.75f);
		ClientEffect("tempent", "set_current_prop", "scale", Random(0.5f, 3));
		float rndRl = Random(-30, 30);
		float rndUd = Random(-420, -280);
		float rndPitch = Random(20, 45);
		Vector3 cloudVel = RelativeVelocity(Vector3(rndPitch, Float(CLOUD_ANG), 0), Vector3(rndRl, 1000, rndUd));
		ClientEffect("tempent", "set_current_prop", "gravity", 1.0f);
		ClientEffect("tempent", "set_current_prop", "velocity", cloudVel);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 5);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 50);
		ClientEffect("tempent", "set_current_prop", "body", RandomInt(0, 2));
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture"); // no glow shell - think sprite rendermode
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 255, 0));
		rndPitch = Random(0, 359.99f);
		float rndYaw = Random(0, 359.99f);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(rndPitch, rndYaw, 0));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "setup_rock") { OnSetupRock(); return true; }
		if (name == "spit_rocks") { OnSpitRocks(); return true; }
		return false;
	}
}
