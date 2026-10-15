#pragma context server

// Converted from effects/sfx_zap_aura.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_zap_aura"]
class SfxZapAura : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_RADIUS = "FX_RADIUS";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;

	// client_activate
	// <modelidx> <radius> <duration>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_RADIUS = hand;
		FX_DURATION = Float(fxColor);
		FX_ACTIVE = true;
		CallEventDelayed(FX_DURATION, "end_fx");
		OnFxLoop();
	}

	// fx_loop
	void OnFxLoop()
	{
		if (!FX_ACTIVE)
			return;
		CallEventDelayed(0.25f, "fx_loop");
		Vector3 beamStart = Vec(LegacyFunction("getcl", FX_OWNER, "origin"));
		if (!Truthy(LegacyFunction("getcl", FX_OWNER, "isplayer")))
			beamStart.z += 32.0f;

		string beamEnd = Text(beamStart);
		float rndAng = Random(0, 359.99f);
		float vAdj = Random(-24, 24);
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(0, rndAng, 0), Vector3(0, Float(FX_RADIUS), vAdj)));
		string beamStartValue = Text(beamStart);
		beamStartValue = Text(Vec(beamStartValue) + RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 16, 0)));
		ClientEffect("beam_points", beamStartValue, beamEnd, "lgtning.spr", 1.0f, 1, 1, 255, 255, 30, Vector3(255, 64, 0));

		beamEnd = Text(beamStart);
		rndAng = Random(0, 359.99f);
		vAdj = Random(-24, 24);
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(0, rndAng, 0), Vector3(0, Float(FX_RADIUS), vAdj)));
		beamStartValue = Text(beamStart);
		beamStartValue = Text(Vec(beamStartValue) + RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 16, 0)));
		ClientEffect("beam_points", beamStartValue, beamEnd, "lgtning.spr", 1.0f, 1, 1, 255, 255, 30, Vector3(255, 64, 0));
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		if (!FX_ACTIVE)
			return;
		FX_ACTIVE = false;
		CallEventDelayed(1.1f, "remove_fx");
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
		if (name == "fx_loop") { OnFxLoop(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		return false;
	}
}
