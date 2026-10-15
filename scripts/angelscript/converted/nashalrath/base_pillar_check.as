#pragma context server

// Converted from nashalrath/base_pillar_check.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BasePillarCheck
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string TARGET_CHECK = "TARGET_CHECK";

	// game_spawn
	void BasePillarCheck_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetInvincible(true);
		SetNoPush(true);
		PLAYING_DEAD = "1";
		SetSolid("none");
		SetModel("null.mdl"); // need a model to find origin center
	}

	// ext_check_targets
	void BasePillarCheck_OnExtCheckTargets()
	{
		TARGET_CHECK = LegacyFunction("get_tsphere", "player", 256, MyOrigin());
	}

	// ext_do_shake
	void BasePillarCheck_OnExtDoShake()
	{
		TARGET_CHECK = "none"; // reset for next check
		Effect("screenshake", OriginOf(ENT_ME), 300, 30, 10.0f, 384);
		PlaySound(0, 10, "magic/volcano_start.wav");
	}

	// ext_do_boom
	void BasePillarCheck_OnExtDoBoom()
	{
		CallEventDelayed(1.5f, "ext_do_boom2");
	}

	// ext_do_boom2
	void BasePillarCheck_OnExtDoBoom2()
	{
		PlaySound(0, 10, "magic/boom.wav", 0.5f, 50);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BasePillarCheck_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnExtCheckTargets() { BasePillarCheck_OnExtCheckTargets(); } // ext_check_targets
	void OnExtDoShake() { BasePillarCheck_OnExtDoShake(); } // ext_do_shake
	void OnExtDoBoom() { BasePillarCheck_OnExtDoBoom(); } // ext_do_boom
	void OnExtDoBoom2() { BasePillarCheck_OnExtDoBoom2(); } // ext_do_boom2

	// This file's events and timers by their .script names
	bool BasePillarCheck_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_check_targets") { OnExtCheckTargets(); return true; }
		if (name == "ext_do_boom") { OnExtDoBoom(); return true; }
		if (name == "ext_do_boom2") { OnExtDoBoom2(); return true; }
		if (name == "ext_do_shake") { OnExtDoShake(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "nashalrath/base_pillar_check"]
shared class BasePillarCheckScript : ScriptEntity, BasePillarCheck
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
		return BasePillarCheck_DispatchEvent(name, params);
	}
}
