#pragma context server

// Converted from other/hp_trigger_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HpTriggerBase
{
	// Constants
	int TRIGGER_RANGE = 256;
	int TRIGGER_REQ = 300;
	string EVENT_NAME = "found_300";

	// Variables (an unset .script variable reads as its own name)
	Vector3 HOME_LOC = Vector3();
	bool FOUND_ONE = false;

	// game_spawn
	void HpTriggerBase_OnGameSpawn(string playerRace = "", string playerGender = "")
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

		SetIdleAnim("");
		SetMoveAnim("");

		// dbg temp hp trigger spawned ( req TRIGGER_REQ )
		CallEventDelayed(0.5f, "post_spawn");
		CallEventDelayed(0.1f, "scan_for_players");
	}

	// post_spawn
	void HpTriggerBase_OnPostSpawn()
	{
		HOME_LOC = MyOrigin();
		CallEventDelayed(20.7f, "reset_pos");
	}

	// scan_for_players
	void HpTriggerBase_OnScanForPlayers()
	{
		if (FOUND_ONE)
			return;
		CallEventDelayed(1.0f, "scan_for_players");

		string playerId = FindOneInSphere("player", TRIGGER_RANGE);

		// === testing
		// getents npc TRIGGER_RANGE
		// setvard LOOP_COUNT 0
		// setvard ENT_LIST "Names:"
		// calleventloop GET_COUNT debug_loop
		// //dbg $get(PLAYER_ID,name) ent_count GET_COUNT list( ENT_LIST ) @ $get(GET_ENT1,range)
		// //dbg temp cansee $cansee(player) insphere $get(PLAYER_ID,name) getents_count GET_COUNT ge_1 $get(GET_ENT1,name) ge_2 $get(GET_ENT2,name) ge_3 $get(GET_ENT3,name)
		// getents npc TRIGGER_RANGE
		// === end testing
		if (IsPlayer(playerId))
		{
			// dbg Player in sphere with $get(PLAYER_ID,maxhp) maxhp
			if (MaxHealthOf(playerId) >= TRIGGER_REQ)
				OnFoundWorthy();
		}

		if (!Truthy(LegacyFunction("cansee", "player", TRIGGER_RANGE)))
			return;
		if (!(MaxHealthOf(ENT_LASTSEEN) >= TRIGGER_REQ))
			return;
		OnFoundWorthy();
	}

	// game_heardsound
	void HpTriggerBase_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (FOUND_ONE)
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;

		if (!(RangeTo(ENT_LASTHEARD) < TRIGGER_RANGE))
			return;
		// //dbg temp Heard $get(ent_lastheard,name) at $get(ent_lastheard,range) vs TRIGGER_RANGE maxhp $get(ent_lastheard,maxhp) vs TRIGGER_REQ
		if (!(MaxHealthOf(ENT_LASTHEARD) >= TRIGGER_REQ))
			return;
		OnFoundWorthy();
	}

	// found_worthy
	void HpTriggerBase_OnFoundWorthy()
	{
		if (FOUND_ONE)
			return;
		FOUND_ONE = true;
		UseTrigger(EVENT_NAME);
		CallEventDelayed(1.0f, "clear_out");
	}

	// clear_out
	void HpTriggerBase_OnClearOut()
	{
		// dbg temp suiciding
		CallEventDelayed(0.1f, "suicide_debug");

		SetInvincible(false);
		SetRace("hated");
		CallEventDelayed(0.2f, "clear_out2");
	}

	// clear_out2
	void HpTriggerBase_OnClearOut2()
	{
		DoDamage(self, "direct", 1000, "100%", self, "magic");
	}

	// suicide_debug
	void HpTriggerBase_OnSuicideDebug()
	{
		// dbg still here
		CallEventDelayed(2.0f, "suicide_debug");
	}

	// reset_pos
	void HpTriggerBase_OnResetPos()
	{
		if (!Truthy(Eval("game.monster.isalive")))
			return;
		SetOrigin(ENT_ME, HOME_LOC);
		CallEventDelayed(20.7f, "reset_pos");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { HpTriggerBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnPostSpawn() { HpTriggerBase_OnPostSpawn(); } // post_spawn
	void OnScanForPlayers() { HpTriggerBase_OnScanForPlayers(); } // scan_for_players
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { HpTriggerBase_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnFoundWorthy() { HpTriggerBase_OnFoundWorthy(); } // found_worthy
	void OnClearOut() { HpTriggerBase_OnClearOut(); } // clear_out
	void OnClearOut2() { HpTriggerBase_OnClearOut2(); } // clear_out2
	void OnSuicideDebug() { HpTriggerBase_OnSuicideDebug(); } // suicide_debug
	void OnResetPos() { HpTriggerBase_OnResetPos(); } // reset_pos

	// This file's events and timers by their .script names
	bool HpTriggerBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "clear_out") { OnClearOut(); return true; }
		if (name == "clear_out2") { OnClearOut2(); return true; }
		if (name == "found_worthy") { OnFoundWorthy(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "post_spawn") { OnPostSpawn(); return true; }
		if (name == "reset_pos") { OnResetPos(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "suicide_debug") { OnSuicideDebug(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/hp_trigger_base"]
shared class HpTriggerBaseScript : ScriptEntity, HpTriggerBase
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return HpTriggerBase_DispatchEvent(name, params);
	}
}
