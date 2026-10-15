#pragma context server

// Converted from monsters/bat_large_corpse_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/bat_large_corpse_cl"]
class BatLargeCorpseCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string USE_SKIN = "USE_SKIN";

	// client_activate
	// <origin> <skin>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		USE_SKIN = hand;
		ClientEffect("tempent", "model", "monsters/bat_large.mdl", owner, "setup_corpse");
		CallEventDelayed(7.0f, "remove_script");
	}

	// remove_script
	void OnRemoveScript()
	{
		RemoveScript();
	}

	// setup_corpse
	void OnSetupCorpse()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 5.0f);
		ClientEffect("tempent", "set_current_prop", "framerate", 0.1f);
		ClientEffect("tempent", "set_current_prop", "sequence", 6);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "skin", USE_SKIN);
		ClientEffect("tempent", "set_current_prop", "collide", "world");
		ClientEffect("tempent", "set_current_prop", "frames", 40);
		ClientEffect("tempent", "set_current_prop", "rendermode", "texture");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
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
