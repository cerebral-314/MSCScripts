#pragma context server

// Converted from other/web.script by msc_transpiler.
// Attach this to a func_wall_toggle with a targetname for breaking web effect that slows players

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Web
{

	// unnamed block (first think)
	void Web_FirstThink()
	{
		SetCallback("touch", "enable");
		SetProp(ENT_ME, "solid", 1);
	}

	// game_touch
	string Web_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg touched by $get(PARAM1,name) ret targetname [ PARAM2 ] target [ PARAM3 ]
		if (RaceOf(other) == "spider")
			return result;
		UseTrigger("web_touched", hpRange);
		PlayerMessage(other, "You have been webbed!");
		PlaySound(0, 10, "barnacle/bcl_chew2.wav");
		ApplyEffect(other, "effects/webbed", 10.0f, GetVar("GAME_MASTER"));
		SetCallback("touch", "disable");
		RemoveScript();
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return Web_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// This file's events and timers by their .script names
	bool Web_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/web"]
shared class WebScript : ScriptEntity, Web
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Web_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Web_DispatchEvent(name, params);
	}
}
