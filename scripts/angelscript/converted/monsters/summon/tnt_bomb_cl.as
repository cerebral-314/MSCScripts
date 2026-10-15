#pragma context server

// Converted from monsters/summon/tnt_bomb_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/tnt_bomb_cl"]
class TntBombCl : ScriptEntity
{
	// Constants
	float GLOW_RAD = 64.0f;
	Vector3 GLOW_COLOR = Vector3();

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	string LIGHT_IDX = "LIGHT_IDX";

	// client_activate
	// <owner> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		DebugPrint("*** monsters/summon/tnt_bomb_cl " + owner + " " + hand);
		FX_OWNER = owner;
		FX_DURATION = Float(hand);
		FX_ACTIVE = true;

		OnSparksLoop();

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "attachment0"), GLOW_RAD, GLOW_COLOR, FX_DURATION);
		LIGHT_IDX = Eval("game.script.last_light_id");

		SetCallback("render", "enable");

		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// sparks_loop
	void OnSparksLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(Random(0.1f, 0.5f), "sparks_loop");
		ClientEffect("spark", FX_OWNER, 0);
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (FX_ACTIVE)
			ClientEffect("light", LIGHT_IDX, LegacyFunction("getcl", FX_OWNER, "attachment0"), GLOW_RAD, GLOW_COLOR, 1.0f);
		else
			ClientEffect("light", LIGHT_IDX, LegacyFunction("getcl", FX_OWNER, "attachment0"), 0, Vector3(0, 0, 0), 1.0f);
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
		if (name == "sparks_loop") { OnSparksLoop(); return true; }
		return false;
	}
}
