#pragma context server

// Converted from sfor/wizard_center.script by msc_transpiler.
// marks the center point for wizard fx

#include "runtime/ScriptEntity.as"

[script "sfor/wizard_center"]
class WizardCenter : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// if ( !$get(GAME_MASTER,exists) ) createnpc game_master $vec(20000,-10000,-20000)
		CallEventDelayed(1.0f, "set_spawn_point");

		SetFly(true);
		SetGravity(0);
	}

	// set_center_point
	void OnSetCenterPoint()
	{
		Vector3 myLoc = OriginOf(ENT_ME);
		myLoc.z = GroundHeight(myLoc);

		CallExternal(GetVar("GAME_MASTER"), "set_wizard_center", myLoc);
		CallEventDelayed(1.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "set_center_point") { OnSetCenterPoint(); return true; }
		return false;
	}
}
