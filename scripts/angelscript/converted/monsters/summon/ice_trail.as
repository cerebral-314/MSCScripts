#pragma context server

// Converted from monsters/summon/ice_trail.script by msc_transpiler.
// Ice Trail by Thothie from Scratch
// ball of ice, fires in straight line, leaves nifty trail, freezes folks
// - *sigh* far too many ice effects, but the frost bolt wasn't cutting it for the mages

#include "runtime/ScriptEntity.as"

[script "monsters/summon/ice_trail"]
class IceTrail : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string DUR_FREEZE = "DUR_FREEZE";
	string DMG_FREEZE = "DMG_FREEZE";

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		DUR_FREEZE = creatorValue2;
		DMG_FREEZE = damage;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		return false;
	}
}
