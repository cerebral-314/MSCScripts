#pragma context server

// Converted from monsters/cl_corpse.script by msc_transpiler.
// SOMETHING is messed up in the entity.cpp
// this will only play its anim through if called early on the map
// it's as if the frame time is determined by client time, but I can't figure where

#include "runtime/ScriptEntity.as"

[script "monsters/cl_corpse"]
class ClCorpse : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_SEQ = "FX_SEQ";
	string FX_SKIN = "FX_SKIN";
	string FX_BODY = "FX_BODY";
	string FX_NOBOUNCE = "FX_NOBOUNCE";
	float FX_FADE_START = 0.0f;
	string FX_ANGLES = "FX_ANGLES";

	// client_activate
	// <index> <seq#> [skin] [body] [nobounce:0|1]
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		string fxModel = LegacyFunction("getcl", FX_OWNER, "model");
		FX_SEQ = hand;
		FX_SKIN = fxColor;
		FX_BODY = lifetime;
		FX_NOBOUNCE = sprite;

		FX_FADE_START = GameTime() + 10.0f;

		FX_ANGLES = LegacyFunction("getcl", FX_OWNER, "angles");
		ClientEffect("tempent", "model", fxModel, LegacyFunction("getcl", FX_OWNER, "origin"), "setup_corpse");
		CallEventDelayed(18.0f, "remove_script");
	}

	// remove_script
	void OnRemoveScript()
	{
		RemoveScript();
	}

	// setup_corpse
	void OnSetupCorpse()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 15.0f);
		// cleffect tempent set_current_prop fadeout 10.0 5.0
		// cleffect tempent set_current_prop hold 1
		ClientEffect("tempent", "set_current_prop", "body", FX_BODY);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "sequence", FX_SEQ);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "skin", FX_SKIN);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "frames", 200);
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "angles", FX_ANGLES);
		// cleffect tempent set_current_prop cb_lastframe corpse_lastframe
		if (Float(FX_NOBOUNCE) == 1.0f)
			ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "remove_script") { OnRemoveScript(); return true; }
		if (name == "setup_corpse") { OnSetupCorpse(); return true; }
		return false;
	}
}
