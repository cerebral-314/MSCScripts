#pragma context server

// Converted from effects/gauntlet_invalid.script by msc_transpiler.
// Gauntlet freeze - designed to suspend players who reach a map illegally (blinds and paralyzes), by Thothie
// PARAM1 = duration (-1 = forevah)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/gauntlet_invalid"]
class GauntletInvalid : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	GauntletInvalid()
	{
		EFFECT_ID = "effect_stun";
		EFFECT_FLAGS = "nostack";
	}

	// unnamed block (timer)
	void GauntletInvalid_Timer()
	{
		CallEventDelayed(5.0f, "GauntletInvalid_Timer");
		Effect("screenfade", ENT_ME, 0.1f, "local.effect.duration", Vector3(10, 10, 10), 255, "noblend");
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		SetVar(Eval("game.effect.movespeed"), "1%");
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.anim.framerate"), 0.01f);
		SetVar(Eval("game.effect.canattack"), 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(5.0f, "GauntletInvalid_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "GauntletInvalid_Timer") { GauntletInvalid_Timer(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
