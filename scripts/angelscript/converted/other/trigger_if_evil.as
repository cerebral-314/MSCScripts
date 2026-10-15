#pragma context server

// Converted from other/trigger_if_evil.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherTriggerIfEvil
{

	// unnamed block (first think)
	void OtherTriggerIfEvil_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string OtherTriggerIfEvil_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg touched by $get(PARAM1,name) ret targetname [ PARAM2 ] target [ PARAM3 ]
		if (RaceOf(other) == "human")
			return result;
		if (RaceOf(other) == "hguard")
			return result;
		UseTrigger(effectDamage);
		SetCallback("touch", "disable");
		RemoveScript();
		return result;
	}

	// game_used
	void OtherTriggerIfEvil_OnGameUsed(CBaseEntity@ activator = null, CBaseEntity@ caller = null, int useType = 0, float value = 0.0f)
	{
		DebugPrint("used by " + NameOf(activator));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherTriggerIfEvil_OnGameTouch(other, hpRange, effectDamage); } // game_touch
	void OnGameUsed(CBaseEntity@ activator = null, CBaseEntity@ caller = null, int useType = 0, float value = 0.0f) { OtherTriggerIfEvil_OnGameUsed(activator, caller, useType, value); } // game_used

	// This file's events and timers by their .script names
	bool OtherTriggerIfEvil_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "game_used") { OnGameUsed(EntityParam(params, 0), EntityParam(params, 1), Int(Param(params, 2)), Float(Param(params, 3))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/trigger_if_evil"]
shared class OtherTriggerIfEvilScript : ScriptEntity, OtherTriggerIfEvil
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherTriggerIfEvil_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherTriggerIfEvil_DispatchEvent(name, params);
	}
}
