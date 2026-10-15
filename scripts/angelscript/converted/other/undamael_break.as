#pragma context server

// Converted from other/undamael_break.script by msc_transpiler.
// This tells Undamael that he's touching something he should just break through

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherUndamaelBreak
{
	// Variables (an unset .script variable reads as its own name)
	bool DID_TRIGGER = false;
	string UNDAMAEL_ID = "UNDAMAEL_ID";
	string RAND_ID = "RAND_ID";

	// unnamed block (first think)
	void OtherUndamaelBreak_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string OtherUndamaelBreak_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (DID_TRIGGER)
			return result;
		if (EntityId(other) != UNDAMAEL_ID)
			return result;

		// if ( !$get(PARAM1,isplayer) ) dbg und_breakable $get(PARAM1,name) vs. $get(UNDAMAEL_ID,name)
		if (IsPlayer(other))
			return result;

		// if PARAM1 equals UNDAMAEL_ID
		UseTrigger(effectDamage);
		DID_TRIGGER = true;
		CallEventDelayed(0.1f, "remove_me");
		return result;
	}

	// remove_me
	void OtherUndamaelBreak_OnRemoveMe(string caller = "")
	{
		RemoveScript();
		DeleteMe();
	}

	// undamael_spawn
	void OtherUndamaelBreak_OnUndamaelSpawn()
	{
		UNDAMAEL_ID = EntityId(FindByName("undamael"));
	}

	// bd_debug
	// <print_var> <property_printvar> <extra> <extra> <caller_id>
	void OtherUndamaelBreak_OnBdDebug(string caller = "", string varType = "", string varName = "", string key = "")
	{
		if (RAND_ID == "RAND_ID")
		{
			SetName("pitbreak1");
			RAND_ID = RandomInt(1000, 9999);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherUndamaelBreak_OnGameTouch(other, hpRange, effectDamage); } // game_touch
	void OnRemoveMe(string caller = "") { OtherUndamaelBreak_OnRemoveMe(caller); } // remove_me
	void OnUndamaelSpawn() { OtherUndamaelBreak_OnUndamaelSpawn(); } // undamael_spawn

	// bd_debug
	void OnBdDebug(string caller = "", string varType = "", string varName = "", string key = "")
	{
		OtherUndamaelBreak_OnBdDebug(caller, varType, varName, key);
		Debug_OnBdDebug(caller, varType, varName, key); // monsters/debug
	}

	// This file's events and timers by their .script names
	bool OtherUndamaelBreak_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bd_debug") { OnBdDebug(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "undamael_spawn") { OnUndamaelSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/undamael_break"]
shared class OtherUndamaelBreakScript : DebugScript, OtherUndamaelBreak
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherUndamaelBreak_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherUndamaelBreak_DispatchEvent(name, params)
			|| DebugScript::DispatchEvent(name, params);
	}
}
