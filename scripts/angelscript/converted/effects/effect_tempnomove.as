#pragma context server

// Converted from effects/effect_tempnomove.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_tempnomove"]
class EffectTempnomove : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectTempnomove()
	{
		EFFECT_ID = "effect_tempnomove";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		SetVar(Eval("game.effect.movespeed"), 0);
		SetVar(Eval("game.effect.canmove"), 0);
		SetVar(Eval("game.effect.canjump"), 0);
	}

	// ext_end_tempnomove
	void OnExtEndTempnomove()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_end_tempnomove") { OnExtEndTempnomove(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
