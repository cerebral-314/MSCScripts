#pragma context server

// Converted from other/sorc_telepoint.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "other/sorc_telepoint"]
class SorcTelepoint : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnSetPoint();
		SetGravity(0);
		SetModel("none");
		SetInvincible(true);
		SetRace("beloved");
	}

	// set_point
	void OnSetPoint()
	{
		if (!IsAlive(GetVar("GAME_MASTER"))) // wait for GM to spawn
			CallEventDelayed(Random(1, 2), "set_point");

		if (!IsAlive(GetVar("GAME_MASTER")))
			return;

		CallExternal(GetVar("GAME_MASTER"), "gm_set_sorc_point", OriginOf(ENT_ME));
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
		if (name == "set_point") { OnSetPoint(); return true; }
		return false;
	}
}
