#pragma context server

// Converted from effects/dot_dark.script by msc_transpiler.
// Defiles target, and reduces its damage output
// . effecttargstack effects/dot_dark 100 GAME_MASTER 1 spellcasting.affliction
// . effectmestack effects/dot_dark 100 GAME_MASTER 1 spellcasting.affliction

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

[script "effects/dot_dark"]
class DotDark : BaseDotScript
{
	// Variables (an unset .script variable reads as its own name)
	string CL_FX = "CL_FX";

	// Variables declared by included files, with the value they start with in this script
	DotDark()
	{
		EFFECT_ID = "DOT_defile";
		DOT_TYPE = "dark_effect";
		DOT_IM_AFFECTED = "You are being defiled by dark magics!";
		DOT_IM_RESIST = "You resist the dark magic.";
		DOT_HE_IMMUNE = "is immune to dark magic!";
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

		Effect("glow", ENT_ME, Vector3(255, 0, 255), 72, EFFECT_DURATION, EFFECT_DURATION);

		if (Truthy(CL_FX))
			ClientEvent("update", "all", CL_FX, "effect_die");
		ClientEvent("new", "all", "effects/sfx_flames", IndexOf(ENT_ME), EFFECT_DURATION, HeightOf(ENT_ME), 1, 1, WidthOf(ENT_ME));
		CL_FX = LastClientScriptId();

		ApplyEffect(ENT_ME, "effects/debuff_defile", EFFECT_DURATION);
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
