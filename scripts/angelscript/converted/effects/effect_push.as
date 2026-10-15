#pragma context server

// Converted from effects/effect_push.script by msc_transpiler.
// Push
// Any npc
// Param1 - Duration //means nothing
// Param2 - Push velocity
// Param3 - 1 == Do screenshake

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_push"]
class EffectPush : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectPush()
	{
		EFFECT_ID = "effect_push";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		if (IsNoPush(ENT_ME))
			return;
		if (int(DamageTakenOf(ENT_ME, "stun")) == 0)
			return;

		SetVar("local.effect.duration", duration);
		SetVar("local.effect.force", amount);
		SetVar("local.effect.scrnshake", damage);

		AddVelocity(ENT_ME, Vec("local.effect.force"));

		RemoveScript();
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
