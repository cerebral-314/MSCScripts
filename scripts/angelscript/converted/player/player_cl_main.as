#pragma context server

// Converted from player/player_cl_main.script by msc_transpiler.
// Client-side Player
// Player Initialization

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerClMain
{
	// Variables (an unset .script variable reads as its own name)
	float NEXT_BREATH = 0.0f;
	string PLR_GENDER = "PLR_GENDER";
	string PLR_RACE = "PLR_RACE";

	// game_think
	// Spawn
	// {
	// eventname game_spawn
	// }
	// Main think... called every frame
	void PlayerClMain_OnGameThink()
	{
		if (!(GameTime() > NEXT_BREATH))
			return;
		NEXT_BREATH = GameTime() + 0.1f;
		OnPlayerBreathe();
	}

	// game_jump
	// Player jump
	void PlayerClMain_OnGameJump()
	{
	}

	// game_jump_land
	void PlayerClMain_OnGameJumpLand()
	{
	}

	// game_hitground
	// Player fall
	// (PARAM1 == vertical speed)
	void PlayerClMain_OnGameHitground(float fallVelocity = 0.0f)
	{
		OnPlayerHitgroundhard(fallVelocity);
	}

	// game_death
	// Player death
	void PlayerClMain_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
	}

	// set_cl_gender_race
	void PlayerClMain_OnSetClGenderRace(string gender = "", string race = "")
	{
		PLR_GENDER = gender;
		PLR_RACE = race;

		DebugPrint("set_cl_gender_race " + PLR_GENDER + " " + PLR_RACE);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameThink() { PlayerClMain_OnGameThink(); } // game_think
	void OnGameJump() { PlayerClMain_OnGameJump(); } // game_jump
	void OnGameJumpLand() { PlayerClMain_OnGameJumpLand(); } // game_jump_land
	void OnGameHitground(float fallVelocity = 0.0f) { PlayerClMain_OnGameHitground(fallVelocity); } // game_hitground
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { PlayerClMain_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnSetClGenderRace(string gender = "", string race = "") { PlayerClMain_OnSetClGenderRace(gender, race); } // set_cl_gender_race
	void OnPlayerBreathe() {} // player_breathe
	void OnPlayerHitgroundhard(float downVelocity = 0.0f) {} // player_hitgroundhard

	// This file's events and timers by their .script names
	bool PlayerClMain_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_hitground") { OnGameHitground(Float(Param(params, 0))); return true; }
		if (name == "game_jump") { OnGameJump(); return true; }
		if (name == "game_jump_land") { OnGameJumpLand(); return true; }
		if (name == "game_think") { OnGameThink(); return true; }
		if (name == "set_cl_gender_race") { OnSetClGenderRace(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_cl_main"]
shared class PlayerClMainScript : ScriptEntity, PlayerClMain
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerClMain_DispatchEvent(name, params);
	}
}
