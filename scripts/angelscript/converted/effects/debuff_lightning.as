#pragma context server

// Converted from effects/debuff_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff.as"

[script "effects/debuff_lightning"]
class DebuffLightning : BaseDebuffScript
{
	// Variables declared by included files, with the value they start with in this script
	DebuffLightning()
	{
		EFFECT_ID = "debuff_lightning";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (!DEBUFF_STARTED)
			return;
		SetHitMultiplier(ENT_ME, 0);
	}

	// debuff_start
	void OnDebuffStart()
	{
		BaseDebuff_OnDebuffStart(); // effects/base_debuff

		SetHitMultiplier(ENT_ME, 0.6f);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "debuff_start") { OnDebuffStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return BaseDebuffScript::DispatchEvent(name, params);
	}
}
