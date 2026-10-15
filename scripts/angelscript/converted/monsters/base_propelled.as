#pragma context server

// Converted from monsters/base_propelled.script by msc_transpiler.
// Monsters with no movement in their anim
// This script is neccesary, but using this script is bad - its a hack
// It's much better to add movement to the movement anims
// Uses NPC_HACKED_MOVE_SPEED

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BasePropelled
{
	// Constants
	bool NPC_PROPELLED = true;

	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 0.0f;

	// npc_post_spawn
	void BasePropelled_OnNpcPostSpawn()
	{
		if (Text(NPC_HACKED_MOVE_SPEED) == "NPC_HACKED_MOVE_SPEED")
			NPC_HACKED_MOVE_SPEED = 250.0f;
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void BasePropelled_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (Truthy(GetVar("NPC_PROPELL_SUSPEND")))
			return;
		if (Truthy(GetVar("I_R_FROZEN")))
			return;
		SetAnimMoveSpeed(NPC_HACKED_MOVE_SPEED); // Force move, since the animation doesn't have the required movement
	}

	// game_stopmoving
	void BasePropelled_OnGameStopmoving()
	{
		if (Truthy(GetVar("NPC_PROPELL_SUSPEND")))
			return;
		SetAnimMoveSpeed(0); // Force Stop
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcPostSpawn() { BasePropelled_OnNpcPostSpawn(); } // npc_post_spawn
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { BasePropelled_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnGameStopmoving() { BasePropelled_OnGameStopmoving(); } // game_stopmoving

	// This file's events and timers by their .script names
	bool BasePropelled_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_propelled"]
shared class BasePropelledScript : ScriptEntity, BasePropelled
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BasePropelled_DispatchEvent(name, params);
	}
}
