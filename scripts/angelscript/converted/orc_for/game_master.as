#pragma context server

// Converted from orc_for/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "orc_for/game_master"]
class OrcForGameMaster : ScriptEntity
{
	// gm_orcfor_sham_start
	void OnGmOrcforShamStart(string player = "")
	{
		DebugPrint("gm_orcfor_sham_start by " + NameOf(player));

		CBaseEntity@ summonerId = FindByName("orc_summoner");
		CallExternal(summonerId, "ext_players_r_here");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_orcfor_sham_start") { OnGmOrcforShamStart(Param(params, 0)); return true; }
		return false;
	}
}
