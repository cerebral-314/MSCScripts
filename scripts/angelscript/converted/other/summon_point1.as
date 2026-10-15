#pragma context server

// Converted from other/summon_point1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "other/summon_point1"]
class SummonPoint1 : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool IN_USE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("summon_point1");
		SetFly(true);
		SetGravity(0);
		SetInvincible(true);
		SetRace("beloved");
		IN_USE = false;
		SetSolid("none");
		SetNoPush(true);
		PLAYING_DEAD = "1";
	}

	// summon_used
	void OnSummonUsed()
	{
		IN_USE = true;
		CallEventDelayed(2.0f, "summon_reset");
	}

	// summon_reset
	void OnSummonReset()
	{
		IN_USE = false;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "summon_reset") { OnSummonReset(); return true; }
		if (name == "summon_used") { OnSummonUsed(); return true; }
		return false;
	}
}
