#pragma context server

// Converted from effects/effect_stamina_regen.script by msc_transpiler.
// Stamina Regen
// (any PC)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_stamina_regen"]
class EffectStaminaRegen : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectStaminaRegen()
	{
		EFFECT_ID = "effect_stamina";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		OnStaminaLoop();
	}

	// stamina_loop
	void OnStaminaLoop()
	{
		LegacyCommand("drainstamina", ENT_ME, -100);
		CallEventDelayed(1.0f, "stamina_loop");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "stamina_loop") { OnStaminaLoop(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
