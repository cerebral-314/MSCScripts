#pragma context server

// Converted from effects/sfx_burst_sphere.script by msc_transpiler.
// sphere spins, grows, and bursts ~256 units (fades in, spins up 3 secs)

#include "runtime/ScriptEntity.as"

[script "effects/sfx_burst_sphere"]
class SfxBurstSphere : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	float FX_GROW_START = 0.0f;
	float FX_END_TIME = 0.0f;
	float FX_SCALE = 0.0f;
	bool FX_ACTIVE = false;
	bool GROW_MODE = false;

	// client_activate
	// <origin>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);

		FX_GROW_START = GameTime() + 2.5f;
		FX_END_TIME = FX_GROW_START;
		FX_SCALE = 2.0f;
		FX_ACTIVE = true;
		CallEventDelayed(6.0f, "end_fx");

		ClientEffect("tempent", "model", "weapons/projectiles", FX_ORIGIN, "setup_bubble", "update_bubble");
	}

	// update_bubble
	void OnUpdateBubble()
	{
		if (FX_ACTIVE)
		{
			if (!GROW_MODE && GameTime() > FX_GROW_START)
				GROW_MODE = true;

			if (GROW_MODE)
			{
				FX_SCALE += 0.01f;
				ClientEffect("tempent", "set_current_prop", "scale", FX_SCALE);
			}
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
		}
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

	// setup_bubble
	void OnSetupBubble()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "scale", FX_SCALE);
		ClientEffect("tempent", "set_current_prop", "body", 1);
		ClientEffect("tempent", "set_current_prop", "sequence", 6); // 7-8 for faster
		ClientEffect("tempent", "set_current_prop", "frames", 255);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		// cleffect tempent set_current_prop rendermode add
		// cleffect tempent set_current_prop renderamt 100
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_bubble") { OnSetupBubble(); return true; }
		if (name == "update_bubble") { OnUpdateBubble(); return true; }
		return false;
	}
}
