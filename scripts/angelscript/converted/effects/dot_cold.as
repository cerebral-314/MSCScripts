#pragma context server

// Converted from effects/dot_cold.script by msc_transpiler.
// Frost
// Any npc
// PARAM1 == Duration
// PARAM2 == Damge Source (entity)
// PARAM3 == Damage per second
// PARAM4 == skillz
// . effecttargstack effects/dot_cold 10 GAME_MASTER 0.5 none
// . effectmestack effects/dot_cold 10 GAME_MASTER 0.5 none

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DotCold
{
	// Constants
	string EFFECT_ID = "DOT_cold";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string DOT_TYPE = "cold_effect";
	string DOT_IM_AFFECTED = "You have been frozen!";
	string DOT_IM_RESIST = "You resist the debilitating cold.";
	string DOT_HE_IMMUNE = "is immune to cold attacks!";

	// Variables (an unset .script variable reads as its own name)
	string CL_FX = "CL_FX";

	// dot_start
	void DotCold_OnDotStart()
	{
		// Blue flames
		if (Truthy(CL_FX))
			ClientEvent("update", "all", CL_FX, "effect_die");
		ClientEvent("new", "all", "effects/sfx_blue_flames", EFFECT_DURATION, IndexOf(ENT_ME));
		CL_FX = LastClientScriptId();

		Effect("glow", ENT_ME, Vector3(128, 128, 255), 72, EFFECT_DURATION, EFFECT_DURATION);

		ApplyEffect(ENT_ME, "effects/debuff_cold", EFFECT_DURATION);

		AddStatusIcon(ENT_ME, "hud/status/alpha_dot_cold", EFFECT_ID, EFFECT_DURATION);
	}

	// dot_effect
	void DotCold_OnDotEffect()
	{
		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", ENT_ME, 0.8f, 0, Vector3(4, 50, 128), 70, "fadein");
	}

	// effect_die
	void DotCold_OnEffectDie()
	{
		if (Truthy(CL_FX))
			ClientEvent("update", "all", CL_FX, "effect_die");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		DotCold_OnEffectDie();
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotCold_OnDotStart();
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot
		DotCold_OnDotEffect();
	}

	// This file's events and timers by their .script names
	bool DotCold_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/dot_cold"]
shared class DotColdScript : BaseDotScript, DotCold
{
	// Variables every script that includes this file declares
	string MAX_HP = "MAX_HP";

	// Variables declared by included files, with the value they start with in this script
	DotColdScript()
	{
		EFFECT_ID = "DOT_cold";
		DOT_TYPE = "cold_effect";
		DOT_IM_AFFECTED = "You have been frozen!";
		DOT_IM_RESIST = "You resist the debilitating cold.";
		DOT_HE_IMMUNE = "is immune to cold attacks!";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DotCold_DispatchEvent(name, params)
			|| BaseDotScript::DispatchEvent(name, params);
	}
}
