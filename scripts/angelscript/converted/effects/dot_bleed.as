#pragma context server

// Converted from effects/dot_bleed.script by msc_transpiler.
// By greatguys1

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DotBleed
{
	// Constants
	string EFFECT_ID = "DOT_pierce";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string DOT_TYPE = "pierce_effect";
	string DOT_IM_AFFECTED = "You are bleeding!";
	string DOT_IM_RESIST = "Your armor prevents the attack from piercing through your skin.";
	string DOT_HE_IMMUNE = "cannot bleed.";

	// Variables (an unset .script variable reads as its own name)
	string SFX_BLEED = "SFX_BLEED";

	// dot_start
	void DotBleed_OnDotStart()
	{
		if (IsAlive(ENT_ME))
		{
			ClientEvent("new", "all", "effects/sfx_bleed", IndexOf(ENT_ME), GetProp(ENT_ME, "blood")); // SFX_BLEED and SFX_GIB_THROW are consolidated in this, and provided with hard coded values for optimization.
			SFX_BLEED = LastClientScriptId();
		}
	}

	// effect_die
	void DotBleed_OnEffectDie()
	{
		// If the bleed client fx are active
		if (SFX_BLEED != "SFX_BLEED")
		{
			// kill them
			ClientEvent("update", "all", SFX_BLEED, "remove_me");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		DotBleed_OnEffectDie();
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotBleed_OnDotStart();
	}

	// This file's events and timers by their .script names
	bool DotBleed_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/dot_bleed"]
shared class DotBleedScript : BaseDotScript, DotBleed
{
	// Variables every script that includes this file declares
	bool DID_PROC = false;
	float L_HP_GIBS = 0.0f;
	string MY_BLOOD = "MY_BLOOD";
	float NUM_GIBS = 0.0f;
	string SWORD_ID = "SWORD_ID";

	// Variables declared by included files, with the value they start with in this script
	DotBleedScript()
	{
		EFFECT_ID = "DOT_pierce";
		DOT_TYPE = "pierce_effect";
		DOT_IM_AFFECTED = "You are bleeding!";
		DOT_IM_RESIST = "Your armor prevents the attack from piercing through your skin.";
		DOT_HE_IMMUNE = "cannot bleed.";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DotBleed_DispatchEvent(name, params)
			|| BaseDotScript::DispatchEvent(name, params);
	}
}
