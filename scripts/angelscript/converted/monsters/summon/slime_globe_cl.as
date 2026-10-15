#pragma context server

// Converted from monsters/summon/slime_globe_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/slime_globe_cl"]
class SlimeGlobeCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float FX_DURATION = 0.0f;
	bool GROW_MODE = false;
	bool SHRINK_MODE = false;

	// client_activate
	// <origin> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_DURATION = Float(hand);
		GROW_MODE = true;
		SHRINK_MODE = false;

		DebugPrint("*** slime_globe_cl " + owner + " " + Text(FX_DURATION) + " " + Text(GROW_MODE) + " " + Text(SHRINK_MODE));
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", owner, "setup_slime_ball", "update_slime_ball");
		CallEventDelayed(FX_DURATION, "start_shrink");
	}

	// start_shrink
	void OnStartShrink()
	{
		DebugPrint("*** slime_globe_cl start_shrink");
		if (SHRINK_MODE)
			return;
		GROW_MODE = false;
		SHRINK_MODE = true;
		CallEventDelayed(2.1f, "remove_me");
	}

	// early_remove
	void OnEarlyRemove()
	{
		OnStartShrink();
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// setup_slime_ball
	void OnSetupSlimeBall()
	{
		float fxDuration = FX_DURATION + 2.0f;
		ClientEffect("tempent", "set_current_prop", "death_delay", fxDuration);
		ClientEffect("tempent", "set_current_prop", "body", 68);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.5f);
		ClientEffect("tempent", "set_current_prop", "sequence", 9);
		// cleffect tempent set_current_prop rendermode add
		// cleffect tempent set_current_prop renderamt 100
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "frames", 16);
		// cleffect tempent set_current_prop angles $vec(0,90,0)
		// cleffect tempent set_current_prop velocity $vec(0,0,0)
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "fuser1", 0.1f);
	}

	// update_slime_ball
	void OnUpdateSlimeBall()
	{
		float curSize = 0.0f;
		if (GROW_MODE)
		{
			curSize = Float(Eval("game.tempent.fuser1"));
			curSize += 0.01f;
			if (curSize < 2.5f)
			{
				ClientEffect("tempent", "set_current_prop", "fuser1", curSize);
				ClientEffect("tempent", "set_current_prop", "scale", curSize);
			}
		}
		if (SHRINK_MODE)
		{
			curSize = Float(Eval("game.tempent.fuser1"));
			curSize -= 0.1f;
			if (curSize > 0.0f)
			{
				ClientEffect("tempent", "set_current_prop", "fuser1", curSize);
				ClientEffect("tempent", "set_current_prop", "scale", curSize);
			}
		}
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
		if (name == "early_remove") { OnEarlyRemove(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_slime_ball") { OnSetupSlimeBall(); return true; }
		if (name == "start_shrink") { OnStartShrink(); return true; }
		if (name == "update_slime_ball") { OnUpdateSlimeBall(); return true; }
		return false;
	}
}
