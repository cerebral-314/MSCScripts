#pragma context server

// Converted from other/base_item_detect.script by msc_transpiler.
// This base can take actions when it detects a player with a certain item in range
// - default action is to open menu - but this can be changed
// - uses event item_detected [PARAM1=owner]

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseItemDetect
{
	// Constants
	string SEARCH_ITEM = "health_apple";
	int SCAN_RANGE = 64;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	Vector3 HOME_LOC = Vector3();

	// game_spawn
	void BaseItemDetect_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetRace("beloved");
		SetBlood("none");
		SetModel("none");
		SetInvincible(true);
		SetHealth(1);
		SetFly(true);
		SetWidth(32);
		SetHeight(32);
		SetSolid("none");
		SetHearingSensitivity(8);
		SetRoam(false);
		SetMoveSpeed(0);
		SetNoPush(true);

		SetIdleAnim("");
		SetMoveAnim("");

		// dbg temp hp trigger spawned ( req TRIGGER_REQ )
		PLAYING_DEAD = "1";

		CallEventDelayed(0.5f, "post_spawn");
	}

	// post_spawn
	void BaseItemDetect_OnPostSpawn()
	{
		HOME_LOC = MyOrigin();
		CallEventDelayed(20.7f, "reset_pos");
	}

	// reset_pos
	// maintain placement position regardless
	void BaseItemDetect_OnResetPos()
	{
		if (!Truthy(Eval("game.monster.isalive")))
			return;
		SetOrigin(ENT_ME, HOME_LOC);
		CallEventDelayed(20.7f, "reset_pos");
	}

	// unnamed block (timer)
	void BaseItemDetect_Timer()
	{
		CallEventDelayed(3.0f, "BaseItemDetect_Timer");

		SetVar("L_PLAYERS", GetActivePlayers());
		int count = GetTokenCount("L_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckNear();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// check_near
	void BaseItemDetect_OnCheckNear()
	{
		string curPlayer = GetToken("L_PLAYERS", loopIteration);
		if (!(RangeTo(curPlayer) < SCAN_RANGE))
			return;
		if (!Truthy(ItemExists(curPlayer, SEARCH_ITEM)))
			return;
		OnItemDetected(curPlayer);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseItemDetect_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnPostSpawn() { BaseItemDetect_OnPostSpawn(); } // post_spawn
	void OnResetPos() { BaseItemDetect_OnResetPos(); } // reset_pos
	void OnCheckNear() { BaseItemDetect_OnCheckNear(); } // check_near
	void OnItemDetected(string player = "") {} // item_detected

	// This file's events and timers by their .script names
	bool BaseItemDetect_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_near") { OnCheckNear(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "post_spawn") { OnPostSpawn(); return true; }
		if (name == "reset_pos") { OnResetPos(); return true; }
		if (name == "BaseItemDetect_Timer") { BaseItemDetect_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/base_item_detect"]
shared class BaseItemDetectScript : ScriptEntity, BaseItemDetect
{
	// Variables every script that includes this file declares
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	bool ITEM_FOUND = false;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(3.0f, "BaseItemDetect_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseItemDetect_DispatchEvent(name, params);
	}
}
