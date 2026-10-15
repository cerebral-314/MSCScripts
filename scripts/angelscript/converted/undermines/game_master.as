#pragma context server

// Converted from undermines/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "undermines/game_master"]
class UnderminesGameMaster : ScriptEntity
{
	// gm_map_rmines_dinnerbell
	// <triggerboi>
	void OnGmMapRminesDinnerbell()
	{
		CallExternal(FindByName("aby_worm"), "dinner_bell");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_map_rmines_dinnerbell") { OnGmMapRminesDinnerbell(); return true; }
		return false;
	}
}
