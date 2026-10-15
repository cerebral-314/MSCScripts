#pragma context server

// Converted from monsters/giantbrwonbear.script by msc_transpiler.
// Security measure to verify skycastle - since chests don't seem to be spawning, by Thothie

#include "runtime/ScriptEntity.as"

[script "monsters/giantbrwonbear"]
class Giantbrwonbear : ScriptEntity
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetInvincible(true);
		SetHealth(1);
		SetOrigin(ENT_ME, Vector3(10000, 10000, 10000));
		SetUniqueName("sky_verify");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
