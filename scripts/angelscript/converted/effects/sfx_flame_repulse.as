#pragma context server

// Converted from effects/sfx_flame_repulse.script by msc_transpiler.
// big flaming burst in rapidly expanding circle

#include "runtime/ScriptEntity.as"

[script "effects/sfx_flame_repulse"]
class SfxFlameRepulse : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_CENTER = "FX_CENTER";

	// client_activate
	// <origin>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_CENTER = owner;
		ClientEffect("light", "new", FX_CENTER, 512, Vector3(255, 128, 64), 1.0f);
		ClientEffect("tempent", "sprite", "weapons/projectiles.mdl", FX_CENTER, "setup_repulse_burst", "update_repulse_burst");
		PlaySound3D("magic/boom.wav", 10, Vec(FX_CENTER));
		CallEventDelayed(2.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// update_repulse_burst
	void OnUpdateRepulseBurst()
	{
		float curScale = Float(Eval("game.tempent.fuser1"));
		if (!(curScale < 15.0f))
			return;
		curScale += 0.5f;
		ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
		ClientEffect("tempent", "set_current_prop", "scale", curScale);
	}

	// setup_repulse_burst
	void OnSetupRepulseBurst()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.5f);
		ClientEffect("tempent", "set_current_prop", "body", 51);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "sequence", 8);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_repulse_burst") { OnSetupRepulseBurst(); return true; }
		if (name == "update_repulse_burst") { OnUpdateRepulseBurst(); return true; }
		return false;
	}
}
