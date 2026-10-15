#pragma context server

// Converted from dq/externals/dq_apply_callback_on_death.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// ext_effected_monster_killed will be called on PARAM1

#include "runtime/ScriptEntity.as"

[script "dq/externals/dq_apply_callback_on_death"]
class DqApplyCallbackOnDeath : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string DQ_WHERE_IS_THE_CREATOR = "DQ_WHERE_IS_THE_CREATOR";

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		DQ_WHERE_IS_THE_CREATOR = duration; // What's he saying?
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(DQ_WHERE_IS_THE_CREATOR, "ext_effected_monster_killed");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		return false;
	}
}
