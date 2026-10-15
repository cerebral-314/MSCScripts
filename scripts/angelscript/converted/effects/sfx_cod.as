#pragma context server

// Converted from effects/sfx_cod.script by msc_transpiler.
// Circle o death (for players)
// - same as skele COD, sans the skull, to save on sprite precache. Also sound is client side
// - (scratch that, cl loop sound buggy)
// - called via player/externals->ext_lcod/ext_gcod

#include "runtime/ScriptEntity.as"

[script "effects/sfx_cod"]
class SfxCod : ScriptEntity
{
	// Constants
	string SEAL_MODEL = "weapons/magic/seals.mdl";
	Vector3 GLOW_COLOR = Vector3();
	string SEAL_SOUND = "ambience/pulsemachine.wav";

	// Variables (an unset .script variable reads as its own name)
	Vector3 FX_ORIGIN = Vector3();
	float FX_DURATION = 0.0f;
	string MODEL_OFS = "MODEL_OFS";
	bool FX_ACTIVE = false;
	float GLOW_RAD = 0.0f;
	string SND_CHAN = "SND_CHAN";

	// client_activate
	// <position> <duration> <body> <glow_rad> <soundchan>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_ORIGIN = Vec(owner);
		FX_DURATION = Float(hand);
		MODEL_OFS = fxColor;
		FX_ACTIVE = true;
		GLOW_RAD = Float(lifetime);

		SND_CHAN = sprite;
		DebugPrint("cod_soundchan " + SND_CHAN);

		// sound.play3d SEAL_SOUND 10 FX_ORIGIN 0.8 SND_CHAN
		CallEventDelayed(FX_DURATION, "end_fx");
		ClientEffect("light", "new", FX_ORIGIN, GLOW_RAD, GLOW_COLOR, FX_DURATION);
		ClientEffect("tempent", "model", SEAL_MODEL, FX_ORIGIN, "setup_seal");
	}

	// end_fx
	// { fx_loop
	// if FX_ACTIVE
	// callevent 1.0 fx_loop
	// local SKULL_ORIGIN FX_ORIGIN
	// vectoradd SKULL_ORIGIN z 64
	// cleffect tempent sprite FX_SPRITE SKULL_ORIGIN setup_skull
	// }
	void OnEndFx(string reason = "")
	{
		// sound.play3d SEAL_SOUND 0 FX_ORIGIN 0.8 SND_CHAN
		FX_ACTIVE = false;
		CallEventDelayed(0.5f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
	}

	// setup_seal
	void OnSetupSeal()
	{
		float fxDuration = FX_DURATION * 2.0f;

		ClientEffect("tempent", "set_current_prop", "death_delay", fxDuration);
		ClientEffect("tempent", "set_current_prop", "body", MODEL_OFS);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 0, 0));
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
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
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "setup_seal") { OnSetupSeal(); return true; }
		return false;
	}
}
