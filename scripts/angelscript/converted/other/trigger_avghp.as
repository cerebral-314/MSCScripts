#pragma context server

// Converted from other/trigger_avghp.script by msc_transpiler.
// targetname stores the hp range via tokens
// target is what will fire
// this trigger removes itself when touched either way

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherTriggerAvghp
{

	// unnamed block (first think)
	void OtherTriggerAvghp_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string OtherTriggerAvghp_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		bool doTrigger = false;
		string result = "";
		// dbg touched by $get(PARAM1,name) ret targetname [ PARAM2 ] target [ PARAM3 ]
		if (!IsPlayer(other))
			return result;
		string hpMinText = GetToken(hpRange, 0);
		int hpMin = Int(hpMinText);
		string hpMaxText = GetToken(hpRange, 1);
		int hpMax = Int(hpMaxText);

		float hpPresent = Float(Eval("game.players.totalhp"));
		hpPresent = Divide(hpPresent, PlayerCount());

		DebugPrint(Text(hpPresent) + " vs " + hpMinText + " to " + hpMaxText);

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", Text(hpPresent) + " vs " + hpMinText + " - " + hpMaxText);

		if (hpPresent >= hpMin && hpPresent <= hpMax)
			doTrigger = true;

		if (doTrigger)
			UseTrigger(effectDamage);
		SetCallback("touch", "disable");
		RemoveScript();
		DeleteEntity(ENT_ME);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return OtherTriggerAvghp_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// This file's events and timers by their .script names
	bool OtherTriggerAvghp_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/trigger_avghp"]
shared class OtherTriggerAvghpScript : ScriptEntity, OtherTriggerAvghp
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OtherTriggerAvghp_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherTriggerAvghp_DispatchEvent(name, params);
	}
}
