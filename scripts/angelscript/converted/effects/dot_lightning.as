#pragma context server

// Converted from effects/dot_lightning.script by msc_transpiler.
// Lightning dot reduces damage output by 75% and those afflicted have a chance to miss.
// Any npc
// Param1 - Duration
// Param2 - My Attacker
// Param3 - Damage
// Param4 - XP Skill
// . effecttargstack effects/dot_lightning 10 GAME_MASTER 0.5 spellcasting.fire
// . effectmestack effects/dot_lightning 10 GAME_MASTER 0.5 spellcasting.fire

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DotLightning
{
	// Constants
	string EFFECT_ID = "DOT_lightning";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string DOT_TYPE = "lightning_effect";
	string DOT_IM_AFFECTED = "You are being electrocuted!";
	string DOT_IM_RESIST = "You resist the lightning magic's deleterious effects.";
	string DOT_HE_IMMUNE = "is immune to electrical attacks!";

	// Variables (an unset .script variable reads as its own name)
	string CL_FX = "CL_FX";

	// dot_start
	void DotLightning_OnDotStart()
	{
		Effect("glow", self, Vector3(255, 255, 0), 72, EFFECT_DURATION, EFFECT_DURATION);

		AddStatusIcon(ENT_ME, "hud/status/alpha_dot_lightning", EFFECT_ID, EFFECT_DURATION);

		if (IsPlayer(ENT_ME) && !IsNoPush(ENT_ME))
		{
			if (Truthy(CL_FX))
				ClientEvent("update", "all", CL_FX, "effect_die");
			ClientEvent("new", ENT_ME, "effects/effect_lightning_drunk", EFFECT_DURATION);
			CL_FX = LastClientScriptId();
		}
	}

	// dot_effect
	void DotLightning_OnDotEffect()
	{
		Effect("screenfade", self, 0.8f, 0, Vector3(255, 255, 0), 200, "fadein");
	}

	// effect_die
	void DotLightning_OnEffectDie()
	{
		if (Truthy(CL_FX))
			ClientEvent("update", ENT_ME, CL_FX, "effect_die");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		DotLightning_OnEffectDie();
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotLightning_OnDotStart();
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot
		DotLightning_OnDotEffect();
	}

	// This file's events and timers by their .script names
	bool DotLightning_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/dot_lightning"]
shared class DotLightningScript : BaseDotScript, DotLightning
{
	// Variables every script that includes this file declares
	string CL_CAGE = "CL_CAGE";
	string MAX_HP = "MAX_HP";

	// Variables declared by included files, with the value they start with in this script
	DotLightningScript()
	{
		EFFECT_ID = "DOT_lightning";
		DOT_TYPE = "lightning_effect";
		DOT_IM_AFFECTED = "You are being electrocuted!";
		DOT_IM_RESIST = "You resist the lightning magic's deleterious effects.";
		DOT_HE_IMMUNE = "is immune to electrical attacks!";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DotLightning_DispatchEvent(name, params)
			|| BaseDotScript::DispatchEvent(name, params);
	}
}
