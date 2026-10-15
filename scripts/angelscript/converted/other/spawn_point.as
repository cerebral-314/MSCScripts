#pragma context server

// Converted from other/spawn_point.script by msc_transpiler.
// Random spawn points for PVP map

#include "runtime/ScriptEntity.as"

[script "other/spawn_point"]
class SpawnPoint : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// if ( !$get(GAME_MASTER,exists) ) createnpc game_master $vec(20000,-10000,-20000)
		CallEventDelayed(1.0f, "set_spawn_point");

		SetFly(true);
		SetGravity(0);
	}

	// set_spawn_point
	void OnSetSpawnPoint(string spawnPosition = "")
	{
		SetGlobal("G_RANDOM_SPAWN", 1);
		Vector3 myLoc = OriginOf(ENT_ME);
		myLoc.z += 38.0f;

		CallExternal(GetVar("GAME_MASTER"), "set_spawn_point", myLoc);
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
		if (name == "set_spawn_point") { OnSetSpawnPoint(Param(params, 0)); return true; }
		return false;
	}
}
