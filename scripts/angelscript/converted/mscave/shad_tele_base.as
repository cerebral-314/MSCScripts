#pragma context server

// Converted from mscave/shad_tele_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ShadTeleBase
{

	// game_spawn
	void ShadTeleBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// if ( !$get(GAME_MASTER,exists) ) createnpc game_master $vec(20000,-10000,-20000)
		SetFly(true);
		SetRoam(false);
		SetGravity(0);
	}

	// game_postspawn
	// <unused> <unused> <unused> <index;trigger>
	void ShadTeleBase_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		Vector3 myLoc = OriginOf(ENT_ME);
		CallExternal(GetVar("GAME_MASTER"), "set_shad_tele_point", myLoc, GetToken(params, 0), GetToken(params, 1));
		CallEventDelayed(1.0f, "remove_me");
	}

	// remove_me
	void ShadTeleBase_OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { ShadTeleBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { ShadTeleBase_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnRemoveMe(string caller = "") { ShadTeleBase_OnRemoveMe(caller); } // remove_me

	// This file's events and timers by their .script names
	bool ShadTeleBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "mscave/shad_tele_base"]
shared class ShadTeleBaseScript : ScriptEntity, ShadTeleBase
{
	// Variables every script that includes this file declares
	int MY_INDEX = 0;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ShadTeleBase_DispatchEvent(name, params);
	}
}
