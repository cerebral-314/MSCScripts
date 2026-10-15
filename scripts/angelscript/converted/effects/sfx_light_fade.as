#pragma context server

// Converted from effects/sfx_light_fade.script by msc_transpiler.
// Fixed point light fades out

#include "runtime/ScriptEntity.as"

[script "effects/sfx_light_fade"]
class SfxLightFade : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	Vector3 GLOW_COLOR = Vector3();
	float GLOW_RAD = 0.0f;
	float FADE_COUNT = 0.0f;
	bool FX_ACTIVE = false;
	string LIGHT_ID = "LIGHT_ID";

	// client_activate
	// <origin> <color> <rad> [usesound:0|1] [sound] [vol]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetCallback("render", "enable");

		FX_ORIGIN = Vec(owner);
		GLOW_COLOR = Vec(hand);
		GLOW_RAD = Float(fxColor);
		FADE_COUNT = 1.0f;
		FX_ACTIVE = true;
		ClientEffect("light", "new", FX_ORIGIN, GLOW_RAD, GLOW_COLOR, 5.0f);
		LIGHT_ID = Eval("game.script.last_light_id");

		if (!Truthy(lifetime))
			return;
		PlaySound3D(sprite, Float(flag), FX_ORIGIN);
	}

	// game_prerender
	void OnGamePrerender()
	{
		FADE_COUNT -= 0.01f;
		if (FADE_COUNT > 0.0f)
		{
			float curRad = Ratio(FADE_COUNT, 0, GLOW_RAD);
			ClientEffect("light", LIGHT_ID, FX_ORIGIN, curRad, GLOW_COLOR, 1.0f);
		}
		else if (FX_ACTIVE)
		{
			FX_ACTIVE = false;
			OnRemoveFx();
		}
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		return false;
	}
}
