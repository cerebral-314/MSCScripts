#pragma context server

// Converted from ms_soccer/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "ms_soccer/game_master"]
class MsSoccerGameMaster : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool GMSOC_BLUE_TEAM_ACTIVE = false;
	bool GMSOC_RED_TEAM_ACTIVE = false;

	// gm_soccer_blue_toggle
	void OnGmSoccerBlueToggle(string player = "")
	{
		string outMsg;
		DebugPrint("Blue Team Toggle");
		if (!GMSOC_BLUE_TEAM_ACTIVE)
		{
			CallExternal("all", "extsoc_del_blue_pushgoal");
			GMSOC_BLUE_TEAM_ACTIVE = true;
			outMsg = NameOf(player) + " added blue team orcs";
			InfoMessage("all", "BLUE TEAM ACTIVE", outMsg);
			UseTrigger("spawn_blue_team");
		}
		else
		{
			// callexternal $get_by_name(soc_sayer) team_change blue on
			GMSOC_BLUE_TEAM_ACTIVE = false;
			outMsg = NameOf(player) + " removed blue team orcs";
			InfoMessage("all", "BLUE TEAM REMOVED", outMsg);
			CallExternal("all", "ext_soc_blue_remove");
		}
	}

	// gm_soccer_red_toggle
	void OnGmSoccerRedToggle(string player = "")
	{
		string outMsg;
		DebugPrint("Red Team Toggle");
		if (!GMSOC_RED_TEAM_ACTIVE)
		{
			CallExternal("all", "extsoc_del_red_pushgoal");
			GMSOC_RED_TEAM_ACTIVE = true;
			outMsg = NameOf(player) + " added red team orcs";
			InfoMessage("all", "RED TEAM ACTIVE", outMsg);
			UseTrigger("spawn_red_team");
		}
		else
		{
			// callexternal $get_by_name(soc_sayer) team_change red on
			GMSOC_RED_TEAM_ACTIVE = false;
			outMsg = NameOf(player) + " removed red team orcs";
			InfoMessage("all", "BLUE TEAM REMOVED", outMsg);
			CallExternal("all", "ext_soc_red_remove");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "gm_soccer_blue_toggle") { OnGmSoccerBlueToggle(Param(params, 0)); return true; }
		if (name == "gm_soccer_red_toggle") { OnGmSoccerRedToggle(Param(params, 0)); return true; }
		return false;
	}
}
