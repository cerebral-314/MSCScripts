#pragma context server

// Converted from help/first_npc.script by msc_transpiler.
// Thothie - Added default key
// - Not all NPC's respond to 'hello' - some only take 'hail'
// Player first sees an NPC

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FirstNpc
{

	// game_targeted_by_player
	// 1: Player
	void FirstNpc_OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		string text = "You are looking at " + Eval("game.monster.name");
		text += ".|To speak to him, change your text speech mode to|local [U] and say 'hello' or 'hail'";
		HelpTip(player, "help_speak", "Help Tip", text);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameTargetedByPlayer(CBasePlayer@ player = null) { FirstNpc_OnGameTargetedByPlayer(player); } // game_targeted_by_player

	// This file's events and timers by their .script names
	bool FirstNpc_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "help/first_npc"]
shared class FirstNpcScript : ScriptEntity, FirstNpc
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return FirstNpc_DispatchEvent(name, params);
	}
}
