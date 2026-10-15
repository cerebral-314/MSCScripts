#pragma context server

// Converted from effects/dot_acid.script by msc_transpiler.
// Thothie
// ACID
// Any npc
// PARAM1 == Duration
// PARAM2 == Damge Source (entity)
// PARAM3 == Damage per second
// PARAM5 == XP Skill
// . effectmestack effects/dot_acid 10 GAME_MASTER 0.5 none

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

[script "effects/dot_acid"]
class DotAcid : BaseDotScript
{
	// Variables declared by included files, with the value they start with in this script
	DotAcid()
	{
		EFFECT_ID = "DOT_acid";
		DOT_TYPE = "acid_effect";
		DOT_IM_AFFECTED = "You have been acid burned!";
		DOT_IM_RESIST = "You resist the acid attack.";
		DOT_HE_IMMUNE = "is immune to acid!";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (!DOT_RESISTED)
			PlayerMessage(ENT_ME, "The acid burns out.");
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot

		string durRatioText = ScriptVarOf(DOT_ATTACKER, "PLR_CORRODE_DURATION");
		int durRatio = Int(durRatioText);
		if (durRatio != 0)
		{
			EFFECT_DURATION = Text(Float(EFFECT_DURATION) * durRatio); // Increases duration
		}

		if (IsPlayer(ENT_ME))
			ServerPlaySound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), ScriptVarOf(ENT_ME, "PLR_SOUND_STOMACHHIT1"));

		Effect("glow", ENT_ME, Vector3(75, 215, 0), 72, EFFECT_DURATION, EFFECT_DURATION);

		ApplyEffect(ENT_ME, "effects/debuff_acid", EFFECT_DURATION);

		AddStatusIcon(ENT_ME, "hud/status/alpha_dot_poison", EFFECT_ID, EFFECT_DURATION);
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot

		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", ENT_ME, 0.2f, 0, Vector3(75, 215, 0), 30, "fadein");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return BaseDotScript::DispatchEvent(name, params);
	}
}
