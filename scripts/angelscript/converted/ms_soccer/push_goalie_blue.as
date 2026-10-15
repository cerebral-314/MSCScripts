#pragma context server

// Converted from ms_soccer/push_goalie_blue.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "ms_soccer/push_goalie_blue"]
class PushGoalieBlue : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string NPC_HOME_LOC = "NPC_HOME_LOC";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("blue_goalie");
		NPC_HOME_LOC = Text(OriginOf(ENT_ME));
		DebugPrint("blue_goalie spawn");
		SetAlive(true);
		SetCallback("think", "enable");
	}

	// extsoc_del_blue_pushgoal
	// { ext_remove_red_goalie
	// setprop ent_me movetype 5
	// setprop ent_me origin $vec(4000,4000,4000)
	// setprop ent_me velocity $vec(0,0,30000)
	// setprop ent_me rendermode 5
	// setprop ent_me renderamt 255
	// dbg REDGOAL: ext_remove_blue_goalie $get(ent_me,origin) game.monster.origin
	// addvelocity ent_me $vec(0,0,30000)
	// }
	// { ext_restore_red_goalie
	// setprop ent_me origin NPC_HOME_LOC
	// dbg REDGOAL: ext_remove_blue_goalie $get(ent_me,origin) game.monster.origin
	// }
	// Only bit that works :\
	void OnExtsocDelBluePushgoal()
	{
		DeleteEntity(ENT_ME);
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "extsoc_del_blue_pushgoal") { OnExtsocDelBluePushgoal(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
