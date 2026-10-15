#pragma context server

// Converted from effects/sfx_seal_follow.script by msc_transpiler.
// Magic seal that follows player

#include "runtime/ScriptEntity.as"

[script "effects/sfx_seal_follow"]
class SfxSealFollow : ScriptEntity
{
	// Constants
	string MODEL_NAME = "weapons/magic/seals.mdl";
	int V_OFS = 0;
	int V_OFS_DUCK = 0;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	string FX_MODEL_OFS = "FX_MODEL_OFS";
	string DO_GLOW = "DO_GLOW";
	Vector3 GLOW_COLOR = Vector3();
	float GLOW_RAD = 0.0f;
	bool FX_ACTIVE = false;
	string LIGHT_ID = "LIGHT_ID";

	// client_activate
	// <owner> <duration> <seal_ofs> <light:0|1> <light_color> <light_rad>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetCallback("render", "enable");

		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		FX_MODEL_OFS = fxColor; // 25 for holy circle x128
		DO_GLOW = lifetime;
		GLOW_COLOR = Vec(sprite);
		GLOW_RAD = Float(flag);

		DebugPrint("*** seal_follow " + FX_OWNER + " " + Text(FX_DURATION));

		float duration = FX_DURATION + 1.0f;
		CallEventDelayed(duration, "remove_fx");

		FX_ACTIVE = true;

		ClientEffect("tempent", "model", MODEL_NAME, LegacyFunction("getcl", FX_OWNER, "origin"), "make_aura", "update_aura");

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), GLOW_RAD, GLOW_COLOR, 1.0f);
		LIGHT_ID = Eval("game.script.last_light_id");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!Truthy(LegacyFunction("getcl", FX_OWNER, "exists")))
			return;
		ClientEffect("light", LIGHT_ID, LegacyFunction("getcl", FX_OWNER, "origin"), GLOW_RAD, GLOW_COLOR, 1.0f);
	}

	// remove_fx
	void OnRemoveFx()
	{
		DebugPrint("**** seal_follow remove");
		FX_ACTIVE = false;
		CallEventDelayed(0.5f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// update_aura
	void OnUpdateAura()
	{
		if (!FX_ACTIVE)
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(10000, 10000, 10000));
		}
		else
		{
			Vector3 pos = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
			int vofs = V_OFS;
			pos.z += V_OFS;
			if (LegacyFunction("get_contents", pos) != "empty")
				pos.z += V_OFS_DUCK;
			ClientEffect("tempent", "set_current_prop", "origin", pos);
		}
	}

	// make_aura
	void OnMakeAura()
	{
		DebugPrint("*** make_aura");
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "body", FX_MODEL_OFS);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.5f);
		ClientEffect("tempent", "set_current_prop", "sequence", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "frames", 40);
		ClientEffect("tempent", "set_current_prop", "angles", Vector3(0, 90, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, 0));
		ClientEffect("tempent", "set_current_prop", "movetype", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnLDuration() {} // L_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "make_aura") { OnMakeAura(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "update_aura") { OnUpdateAura(); return true; }
		return false;
	}
}
