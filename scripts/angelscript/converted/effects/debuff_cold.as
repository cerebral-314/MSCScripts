#pragma context server

// Converted from effects/debuff_cold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff.as"

[script "effects/debuff_cold"]
class DebuffCold : BaseDebuffScript
{
	// Variables declared by included files, with the value they start with in this script
	DebuffCold()
	{
		EFFECT_ID = "debuff_cold";
	}

	// debuff_start
	void OnDebuffStart()
	{
		BaseDebuff_OnDebuffStart(); // effects/base_debuff

		SetVar(Eval("game.effect.movespeed"), 60);
		SetVar(Eval("game.effect.anim.framerate"), 0.5f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "debuff_start") { OnDebuffStart(); return true; }
		return BaseDebuffScript::DispatchEvent(name, params);
	}
}
