#pragma context server

// Converted from monsters/companion/body_maker.script by msc_transpiler.
// welcome to the land of insane attempts to fix the armor display bug

#include "runtime/ScriptEntity.as"

[script "monsters/companion/body_maker"]
class BodyMaker : ScriptEntity
{
	// game_dynamically_created
	// PARAM1 Owner
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		RemoveScript();
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
