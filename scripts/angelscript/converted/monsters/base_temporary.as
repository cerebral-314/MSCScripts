#pragma context server

// Converted from monsters/base_temporary.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseTemporary
{
	// Constants
	float DEATH_DELAY = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// game_spawn
	void BaseTemporary_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// seeing if assigning an actual model eliminates studio advance error
		SetModel("null.mdl");
		SetHealth(1);
		SetWidth(0);
		SetHeight(0);
		SetSolid("none");
		SetName("tempent");
		SetRoam(false);
		SetFly(true);
		SetInvincible(true);
		SetHearingSensitivity(0);
		SetSkillLevel(0);
		SetRace("beloved");
		SetBlood("none");

		CallEventDelayed(DEATH_DELAY, "end_me");

		PLAYING_DEAD = "1"; // not a valid target
	}

	// end_me
	void BaseTemporary_OnEndMe()
	{
		DeleteMe();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseTemporary_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnEndMe() { BaseTemporary_OnEndMe(); } // end_me
	void OnDeathDelay() {} // DEATH_DELAY

	// This file's events and timers by their .script names
	bool BaseTemporary_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "end_me") { OnEndMe(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_temporary"]
shared class BaseTemporaryScript : ScriptEntity, BaseTemporary
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseTemporary_DispatchEvent(name, params);
	}
}
