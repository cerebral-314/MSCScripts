#pragma context server

// Converted from effects/sfx_whipflash.script by msc_transpiler.
// experimenting

#include "runtime/ScriptEntity.as"

[script "effects/sfx_whipflash"]
class SfxWhipflash : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool FX_ACTIVE = false;

	// client_activate
	// <owner> <pitch> <yaw> <roll> <speed> <0=ofs|1=set>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		DebugPrint("** effects/sfx_whipflash " + owner);
		SetVar(Eval("game.cleffect.view_ofs.z"), owner);
	}

	// change_height
	void OnChangeHeight(float viewHeight = 0.0f)
	{
		SetVar(Eval("game.cleffect.view_ofs.z"), viewHeight);
	}

	// do_whip
	void OnDoWhip()
	{
	}

	// remove_fx
	void OnRemoveFx()
	{
		FX_ACTIVE = false;
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "change_height") { OnChangeHeight(Float(Param(params, 0))); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "do_whip") { OnDoWhip(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		return false;
	}
}
