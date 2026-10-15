#pragma context server

// Converted from effects/sfx_dark_burst.script by msc_transpiler.
// dark staff shield (currently fixed size)

#include "runtime/ScriptEntity.as"

[script "effects/sfx_dark_burst"]
class SfxDarkBurst : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	float FX_RAD = 0.0f;
	string LIGHT_ID = "LIGHT_ID";

	// client_activate
	// <origin> <max_duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_DURATION = Float(hand);
		FX_ACTIVE = true;

		PlaySound3D("magic/temple.wav", 10, FX_ORIGIN);
		PlaySound3D("magic/boom.wav", 10, FX_ORIGIN);
		SetCallback("render", "enable");
		FX_RAD = 128.0f;
		ClientEffect("light", "new", FX_ORIGIN, FX_RAD, Vector3(255, 0, 255), 0.1f);
		LIGHT_ID = Eval("game.script.last_light_id");
		CallEventDelayed(FX_DURATION, "end_fx");

		ClientEffect("tempent", "sprite", "weapons/projectiles.mdl", FX_ORIGIN, "setup_dark_burst", "update_dark_burst");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (FX_ACTIVE)
		{
			ClientEffect("light", LIGHT_ID, FX_ORIGIN, 128, Vector3(255, 0, 255), 0.1f);
		}
		else if (FX_RAD > 2.0f)
		{
			FX_RAD -= 1.0f;
			ClientEffect("light", LIGHT_ID, FX_ORIGIN, FX_RAD, Vector3(255, 0, 255), 0.1f);
		}
	}

	// update_dark_burst
	void OnUpdateDarkBurst()
	{
		if (FX_ACTIVE)
		{
			float curScale = Float(Eval("game.tempent.fuser1"));
			if (curScale < 1.0f)
			{
				curScale += 0.04f;
				ClientEffect("tempent", "set_current_prop", "scale", curScale);
				ClientEffect("tempent", "set_current_prop", "fuser1", curScale);
			}
		}

		if (!FX_ACTIVE)
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
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

	// setup_dark_burst
	void OnSetupDarkBurst()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "body", 54);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "sequence", 8);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 0, 255));
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		ClientEffect("tempent", "set_current_prop", "frames", 11);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
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
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_dark_burst") { OnSetupDarkBurst(); return true; }
		if (name == "update_dark_burst") { OnUpdateDarkBurst(); return true; }
		return false;
	}
}
