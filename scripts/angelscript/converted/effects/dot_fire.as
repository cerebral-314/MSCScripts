#pragma context server

// Converted from effects/dot_fire.script by msc_transpiler.
// Thothie
// Burn
// PARAM1 == Duration
// PARAM2 == Attacker
// PARAM3 == Damage per second
// PARAM4 == Skill
// . effecttarg effects/dot_fire 10 GAME_MASTER 0.5 spellcasting.fire
// . effectme effects/dot_fire 10 GAME_MASTER 0.5 spellcasting.fire

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

[script "effects/dot_fire"]
class DotFire : BaseDotScript
{
	// Variables (an unset .script variable reads as its own name)
	string CL_FX = "CL_FX";

	// Variables declared by included files, with the value they start with in this script
	DotFire()
	{
		EFFECT_ID = "DOT_fire";
		DOT_IM_AFFECTED = "You are on fire!";
		DOT_IM_RESIST = "You resist the fire magic.";
		DOT_HE_IMMUNE = "is immune to fire!";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (Truthy(CL_FX))
			ClientEvent("update", "all", CL_FX, "effect_die");
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot

		if (Truthy(CL_FX))
			ClientEvent("update", "all", CL_FX, "effect_die");
		ClientEvent("new", "all", "effects/sfx_flames", IndexOf(ENT_ME), EFFECT_DURATION, HeightOf(ENT_ME), 1);
		CL_FX = LastClientScriptId();

		Effect("glow", ENT_ME, Vector3(255, 75, 0), 72, EFFECT_DURATION, EFFECT_DURATION);

		AddStatusIcon(ENT_ME, "hud/status/alpha_dot_fire", EFFECT_ID, EFFECT_DURATION);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return BaseDotScript::DispatchEvent(name, params);
	}
}
