#pragma context server

// Converted from effects/dot_holy.script by msc_transpiler.
// Holy DOT causes vulnerable enemies to never revive after falling, and
// can cause them to run away at low health
// . effecttargstack effects/dot_holy 10 GAME_MASTER 0.5 none
// . effectmestack effects/dot_holy 10 GAME_MASTER 0.5 none

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

[script "effects/dot_holy"]
class DotHoly : BaseDotScript
{
	// Variables declared by included files, with the value they start with in this script
	DotHoly()
	{
		EFFECT_ID = "DOT_holy";
		DOT_TYPE = "holy_effect";
		DOT_IM_AFFECTED = "You are being burned by divine magics!";
		DOT_IM_RESIST = "The holy magic leaves you unharmed.";
		DOT_HE_IMMUNE = "is not harmed by holy magic.";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (!DOT_RESISTED)
			PlayerMessage(ENT_ME, "The holy wrath subsides.");
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot

		CallExternal(ENT_ME, "turn_undead", 0, DOT_ATTACKER);
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 72, 1, 1);
		PlaySound(2, 10, "fvox/hiss.wav");

		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", ENT_ME, 1.0f, 0, Vector3(255, 255, 255), 80, "fadein");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return BaseDotScript::DispatchEvent(name, params);
	}
}
