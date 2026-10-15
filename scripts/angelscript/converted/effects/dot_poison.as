#pragma context server

// Converted from effects/dot_poison.script by msc_transpiler.
// Thothie - minor syntax problems generating errors, fixed
// POISON
// Any npc
// PARAM1 == Duration
// PARAM2 == Damage Source (entity)
// PARAM3 == Damage per second
// PARAM4 == XP Skill
// . effectmestack effects/dot_poison 10 GAME_MASTER 0.5 none

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DotPoison
{
	// Constants
	string EFFECT_ID = "DOT_poison";
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string DOT_TYPE = "poison_effect";
	string DOT_IM_AFFECTED = "You have been poisoned!";
	string DOT_IM_RESIST = "You resist the poison.";
	string DOT_HE_IMMUNE = "is immune to poison!";

	// Variables (an unset .script variable reads as its own name)
	string EFFECT_DURATION = "EFFECT_DURATION";

	// dot_start
	void DotPoison_OnDotStart()
	{
		string durRatioText = ScriptVarOf(DOT_ATTACKER, "PLR_CORRODE_DURATION");
		int durRatio = Int(durRatioText);
		if (durRatio != 0)
		{
			EFFECT_DURATION = Text(Float(EFFECT_DURATION) * durRatio); // Increases duration
		}

		if (IsPlayer(ENT_ME))
			ServerPlaySound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), ScriptVarOf(ENT_ME, "PLR_SOUND_STOMACHHIT1"));

		Effect("glow", ENT_ME, Vector3(75, 215, 0), 72, EFFECT_DURATION, EFFECT_DURATION);

		AddStatusIcon(ENT_ME, "hud/status/alpha_dot_poison", EFFECT_ID, EFFECT_DURATION);
	}

	// dot_effect
	void DotPoison_OnDotEffect()
	{
		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", ENT_ME, 0.2f, 0, Vector3(75, 215, 0), 30, "fadein");
	}

	// effect_die
	void DotPoison_OnEffectDie()
	{
		if (!DOT_RESISTED)
			PlayerMessage(ENT_ME, "The poison subsides.");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		DotPoison_OnEffectDie();
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotPoison_OnDotStart();
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot
		DotPoison_OnDotEffect();
	}

	// This file's events and timers by their .script names
	bool DotPoison_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/dot_poison"]
shared class DotPoisonScript : BaseDotScript, DotPoison
{
	// Variables declared by included files, with the value they start with in this script
	DotPoisonScript()
	{
		EFFECT_ID = "DOT_poison";
		DOT_TYPE = "poison_effect";
		DOT_IM_AFFECTED = "You have been poisoned!";
		DOT_IM_RESIST = "You resist the poison.";
		DOT_HE_IMMUNE = "is immune to poison!";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DotPoison_DispatchEvent(name, params)
			|| BaseDotScript::DispatchEvent(name, params);
	}
}
