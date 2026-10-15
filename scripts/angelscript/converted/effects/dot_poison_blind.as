#pragma context server

// Converted from effects/dot_poison_blind.script by msc_transpiler.
// Blinding Poison
// - Like poison but blinds
// "Like a regular boar, but dire."
// Blind has no effect on monsters.
// Any npc
// PARAM1 == Duration
// PARAM2 == Damge Source (entity)
// PARAM3 == Damage per second
// PARAM4 == XP Skill
// . effectmestack effects/dot_poison_blind 10 GAME_MASTER 0.5 none

#include "runtime/ScriptEntity.as"
#include "converted/effects/dot_poison.as"

[script "effects/dot_poison_blind"]
class DotPoisonBlind : DotPoisonScript
{
	// Variables declared by included files, with the value they start with in this script
	DotPoisonBlind()
	{
		DOT_IM_AFFECTED = "The poison blinds you!";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		DotPoison_OnEffectDie(); // effects/dot_poison

		if (!DOT_RESISTED)
			PlayerMessage(ENT_ME, "The poison clears from your eyes.");
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot
		DotPoison_OnDotEffect(); // effects/dot_poison

		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", ENT_ME, 1.5f, 0.6f, Vector3(0, 50, 0), 238, "fadein");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return DotPoisonScript::DispatchEvent(name, params);
	}
}
