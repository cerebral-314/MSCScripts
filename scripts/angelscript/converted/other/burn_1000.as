#pragma context server

// Converted from other/burn_1000.script by msc_transpiler.
// Attach this to a func_wall_toggle with a targetname for breaking web effect that slows players
// Targetname = name to use
// target = amt to burn

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherBurn1000
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";

	// unnamed block (first think)
	void OtherBurn1000_FirstThink()
	{
		SetCallback("touch", "enable");
		SetProp(ENT_ME, "solid", 1);
	}

	// game_touch
	string OtherBurn1000_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		SetName("Hot lava");
		SetRace("hated");
		PLAYING_DEAD = "1";
		SetInvincible(true);
		SetRoam(false);

		string burnDamage = effectDamage;
		if (burnDamage.isEmpty())
			burnDamage = "1000";
		CallExternal(GetVar("GAME_MASTER"), "gm_setname", hpRange);

		// dbg touched by $get(PARAM1,name) ret targetname [ PARAM2 ] target [ PARAM3 ]
		ApplyEffect(other, "effects/dot_fire", 2, GetVar("GAME_MASTER"), burnDamage);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherBurn1000_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// This file's events and timers by their .script names
	bool OtherBurn1000_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/burn_1000"]
shared class OtherBurn1000Script : ScriptEntity, OtherBurn1000
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherBurn1000_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherBurn1000_DispatchEvent(name, params);
	}
}
