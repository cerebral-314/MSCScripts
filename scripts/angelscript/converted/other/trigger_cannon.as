#pragma context server

// Converted from other/trigger_cannon.script by msc_transpiler.
// Fires whatever the targetname of the brush is when a cannon ball crosses it
// - Granted, this would also apply to players with 'Cannon' in their name, or whatnot

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherTriggerCannon
{
	// Variables (an unset .script variable reads as its own name)
	bool USED_TRIGGER = false;

	// unnamed block (first think)
	void OtherTriggerCannon_FirstThink()
	{
		SetCallback("touch", "enable");
		SetProp(ENT_ME, "solid", 1);
	}

	// game_touch
	string OtherTriggerCannon_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (!Contains(NameOf(other), "Cannon"))
			return result;
		if (USED_TRIGGER)
			return result;
		USED_TRIGGER = true;
		UseTrigger(effectDamage);
		SetCallback("touch", "disable");
		RemoveScript();
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherTriggerCannon_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// This file's events and timers by their .script names
	bool OtherTriggerCannon_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/trigger_cannon"]
shared class OtherTriggerCannonScript : ScriptEntity, OtherTriggerCannon
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherTriggerCannon_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherTriggerCannon_DispatchEvent(name, params);
	}
}
