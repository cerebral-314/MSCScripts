#pragma context server

// Converted from effects/effect_templock.script by msc_transpiler.
// This is used in the Thunderaxe (and in the future maybe some other weapons) to prevent the player from attacking while his weapon is flying after being thrown
// callexternal ent_owner ext_removed_effects lock
// PARAM1 - Target to lock
// PARAM2 - Time until release (optional)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_templock"]
class EffectTemplock : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectTemplock()
	{
		EFFECT_ID = "effect_lock";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		SetVar(Eval("game.effect.canattack"), 0);
	}

	// ext_end_templock
	void OnExtEndTemplock()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_end_templock") { OnExtEndTemplock(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
