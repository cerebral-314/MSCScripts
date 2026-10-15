#pragma context server

// Converted from developer/effects/test_duration.script by msc_transpiler.
// Tests base_effect duration, and reports back info
// . effectme developer/effects/test_duration 10
// . effectmestack developer/effects/test_duration 10
// . eventme effect_increase_duration 10

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "developer/effects/test_duration"]
class TestDuration : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	TestDuration()
	{
		EFFECT_ID = "test_duration";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		InfoMessage("all", "Duration: ", EFFECT_DURATION);

		SetVar(Eval("game.effect.movespeed"), 0.01f);
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		InfoMessage("all", "Effect has been killed.", "DX");
	}

	// duration_ended
	void OnDurationEnded()
	{
		InfoMessage("all", Text(GameTime()), Text(EFFECT_STARTED + Float(EFFECT_DURATION)));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "duration_ended") { OnDurationEnded(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
