#pragma context server

// Converted from other/trigger_burn.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/trigger_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherTriggerBurn
{

	// apply_damage
	void OtherTriggerBurn_OnApplyDamage(CBaseEntity@ target = null)
	{
		DebugPrint("apply_damage tim " + EFFECT_TIME + " dmg " + EFFECT_DAMAGE);

		ApplyEffect(target, "effects/dot_fire", EFFECT_TIME, GetVar("GAME_MASTER"), EFFECT_DAMAGE);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnApplyDamage(CBaseEntity@ target = null) { OtherTriggerBurn_OnApplyDamage(target); } // apply_damage

	// This file's events and timers by their .script names
	bool OtherTriggerBurn_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "apply_damage") { OnApplyDamage(EntityParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/trigger_burn"]
shared class OtherTriggerBurnScript : OtherTriggerBaseScript, OtherTriggerBurn
{
	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherTriggerBurn_DispatchEvent(name, params)
			|| OtherTriggerBaseScript::DispatchEvent(name, params);
	}
}
