#pragma context server

// Converted from monsters/gabe_newell_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/gabe_newell_cl"]
class GabeNewellCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	string SKEL_LIGHT_ID = "SKEL_LIGHT_ID";

	// client_activate
	// <idx> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_DURATION = Float(hand);

		CallEventDelayed(FX_DURATION, "end_fx");

		SetCallback("render", "enable");

		int rndR = RandomInt(32, 255);
		int rndG = RandomInt(32, 255);
		int rndB = RandomInt(32, 255);
		Vector3 rndColor = Vector3(rndR, rndG, rndB);
		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), 256, rndColor, 5.0f);
		SKEL_LIGHT_ID = Eval("game.script.last_light_id");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		RemoveScript();
	}

	// game_prerender
	void OnGamePrerender()
	{
		int rndR = RandomInt(32, 255);
		int rndG = RandomInt(32, 255);
		int rndB = RandomInt(32, 255);
		Vector3 rndColor = Vector3(rndR, rndG, rndB);
		ClientEffect("light", SKEL_LIGHT_ID, LegacyFunction("getcl", FX_OWNER, "origin"), 256, rndColor, 1.0f);
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
		return false;
	}
}
