#pragma context server

// Converted from effects/swords_gb/gb_gib_explode.script by msc_transpiler.
// <sword_id> <velocity> <damage> <skill> <"green"|"red">

#include "runtime/ScriptEntity.as"
#include "converted/effects/gib_explode.as"

[script "effects/swords_gb/gb_gib_explode"]
class GbGibExplode : GibExplodeScript
{
	// game_dynamically_created
	// PARAM3 = radius, PARAM6 = sword_id
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		GibExplode_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // effects/gib_explode

		SWORD_ID = extraValue6;
		FX_DAMAGE = ScriptVarOf(SWORD_ID, "POTENTIALLY_INACCURATE_GIB_DAMAGE");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		return GibExplodeScript::DispatchEvent(name, params);
	}
}
