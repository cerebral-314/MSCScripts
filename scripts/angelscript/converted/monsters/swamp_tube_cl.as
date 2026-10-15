#pragma context server

// Converted from monsters/swamp_tube_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/swamp_tube_cl"]
class SwampTubeCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string NEEDLE_ANGS = "NEEDLE_ANGS";

	// client_activate
	// <owner> <angles>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		string needleStartPos = LegacyFunction("getcl", owner, "attachment0");
		NEEDLE_ANGS = hand;
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", needleStartPos, "setup_needle", "do_nadda", "needle_collide");
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// do_nadda
	void OnDoNadda()
	{
	}

	// needle_collide
	void OnNeedleCollide()
	{
		PlaySound3D("weapons/bow/arrowhit1.wav", 10, Vec(Eval("game.tempent.origin")));
	}

	// setup_needle
	void OnSetupNeedle()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.5f);
		ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		string needleAngs = NEEDLE_ANGS;
		// vectorset x $neg($vec.x(L_NEEDLE_ANGS))
		ClientEffect("tempent", "set_current_prop", "angles", needleAngs);
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vec(NEEDLE_ANGS), Vector3(0, 1000, 0)));
		ClientEffect("tempent", "set_current_prop", "body", 26);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_nadda") { OnDoNadda(); return true; }
		if (name == "needle_collide") { OnNeedleCollide(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_needle") { OnSetupNeedle(); return true; }
		return false;
	}
}
