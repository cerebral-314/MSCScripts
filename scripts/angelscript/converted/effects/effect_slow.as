#pragma context server

// Converted from effects/effect_slow.script by msc_transpiler.
// Thothie - Can't believe we don't have this already
// Param1 - Duration
// Param2 - New movespeed%
// Param3 - Attacker Who Afflicted (optional)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_slow"]
class EffectSlow : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectSlow()
	{
		EFFECT_ID = "slow";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		SetVar(Eval("game.effect.movespeed"), amount);
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.anim.framerate"), Divide(Float(amount), 100.0f));

		PlayerMessage(ENT_ME, "You are being slowed.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
