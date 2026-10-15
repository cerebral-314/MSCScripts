#pragma context server

// Converted from items/base_vampire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseVampire
{
	// Variables (an unset .script variable reads as its own name)
	bool CAN_VAMPIRE_TARGET = false;

	// try_vampire_target
	// <owner> <target> <healAmt>
	void BaseVampire_OnTryVampireTarget(CBaseEntity@ owner = null, CBaseEntity@ target = null, string healAmt = "")
	{
		CAN_VAMPIRE_TARGET = false;
		OnCheckCanVampire(FindEntity(EntityId(owner)), FindEntity(EntityId(target)));

		if (!CAN_VAMPIRE_TARGET)
			return;
		GiveHealth(@owner, healAmt);
		PlaySound(0, 5, "player/heartbeat_noloop.wav"); // Dunno if i want this
	}

	// check_can_vampire
	// <owner> <target>
	void BaseVampire_OnCheckCanVampire(CBaseEntity@ owner = null, CBaseEntity@ target = null)
	{
		string relationship = RelationshipOf(owner, @target);

		if (RaceOf(target) == "undead")
			return;
		if (Truthy(ScriptVarOf(target, "IMMUNE_VAMPIRE"))) // Cant vampire undead, or otherwise immune to vampire enemies.
			return;

		if (relationship == "ally")
			return;
		if (relationship == "neutral")
			return;
		if (relationship == "none")
			return;

		CAN_VAMPIRE_TARGET = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnTryVampireTarget(CBaseEntity@ owner = null, CBaseEntity@ target = null, string healAmt = "") { BaseVampire_OnTryVampireTarget(owner, target, healAmt); } // try_vampire_target
	void OnCheckCanVampire(CBaseEntity@ owner = null, CBaseEntity@ target = null) { BaseVampire_OnCheckCanVampire(owner, target); } // check_can_vampire

	// This file's events and timers by their .script names
	bool BaseVampire_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_can_vampire") { OnCheckCanVampire(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "try_vampire_target") { OnTryVampireTarget(EntityParam(params, 0), EntityParam(params, 1), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_vampire"]
shared class BaseVampireScript : ScriptEntity, BaseVampire
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseVampire_DispatchEvent(name, params);
	}
}
