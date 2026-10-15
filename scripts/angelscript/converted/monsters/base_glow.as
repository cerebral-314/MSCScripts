#pragma context server

// Converted from monsters/base_glow.script by msc_transpiler.
// Thothie - use player script to make glow to prevent crash
// - no workie so far

#include "runtime/ScriptEntity.as"

[script "monsters/base_glow"]
class BaseGlow : ScriptEntity
{
	// Constants
	Vector3 GLOW_COLOR = Vector3();
	float GLOW_RAD = 200.0f;

	// Variables (an unset .script variable reads as its own name)
	string MY_LIGHT = "MY_LIGHT";
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		ClientEffect("persists", "player/player_conartist", "glow", IndexOf(ENT_ME), GLOW_COLOR, GLOW_RAD);
		MY_LIGHT = Eval("game.script.last_light_id");
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEffect("remove", "all", MY_LIGHT);
		ClientEffect("remove", "all", MY_LIGHT_SCRIPT);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}
