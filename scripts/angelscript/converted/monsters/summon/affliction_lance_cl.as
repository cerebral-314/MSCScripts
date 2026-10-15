#pragma context server

// Converted from monsters/summon/affliction_lance_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/affliction_lance_cl"]
class AfflictionLanceCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	string FX_ANGS = "FX_ANGS";
	float END_TIME = 0.0f;
	Vector3 CLOUD_VEL = Vector3();

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);

		FX_ACTIVE = true;
		FX_ANGS = "0";

		END_TIME = GameTime() + FX_DURATION;
		OnFxLoop();
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		CallEventDelayed(1.0f, "end_fx");
		if (!(GameTime() >= END_TIME))
			return;
		FX_ACTIVE = false;
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.1f, "fx_loop");
		Vector3 sprPos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		float velPitch = Float(LegacyFunction("getcl", FX_OWNER, "angles.pitch"));
		int velRoll = Int(LegacyFunction("getcl", FX_OWNER, "angles.roll"));
		velPitch -= 90.0f;
		sprPos.z += 32.0f;
		CLOUD_VEL = RelativeVelocity(Vector3(velPitch, Float(FX_ANGS), velRoll), Vector3(0, 150, 0));
		ClientEffect("tempent", "sprite", "poison_cloud.spr", sprPos, "setup_cloud", "update_cloud");
		sprPos.z += 32.0f;
		CLOUD_VEL = RelativeVelocity(Vector3(velPitch, Float(FX_ANGS), 0), Vector3(0, -150, 0));
		ClientEffect("tempent", "sprite", "poison_cloud.spr", sprPos, "setup_cloud", "update_cloud");
		FX_ANGS = Text(Float(FX_ANGS) + 10.0f);
		if (!(Float(FX_ANGS) > 359.0f))
			return;
		FX_ANGS = "0";
	}

	// update_cloud
	void OnUpdateCloud()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		curScale += 0.01f;
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
		ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
	}

	// setup_cloud
	void OnSetupCloud()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(0, 255, 0));
		ClientEffect("tempent", "set_current_prop", "renderamt", 150);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 17);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "velocity", CLOUD_VEL);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
	}

	// keep_on
	void OnKeepOn()
	{
		END_TIME = GameTime() + FX_DURATION;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "end_fx");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "keep_on") { OnKeepOn(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		return false;
	}
}
