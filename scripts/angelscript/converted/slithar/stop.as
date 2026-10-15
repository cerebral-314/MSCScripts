#pragma context server

// Converted from slithar/stop.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "slithar/stop"]
class Stop : BaseTemporaryScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary

		// dbg sending resume command to Slithar
		CBaseEntity@ slitharId = FindByName("snake_lord");
		float myYaw = MyOrigin().y;
		CallExternal(slitharId, "slithar_stop", myYaw);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTemporaryScript::DispatchEvent(name, params);
	}
}
