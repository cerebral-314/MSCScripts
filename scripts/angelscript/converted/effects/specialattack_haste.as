#pragma context server

// Converted from effects/specialattack_haste.script by msc_transpiler.
// Smallarms charge up attack (200%) - Haste - speed boost

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/specialattack_haste"]
class SpecialattackHaste : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	string CALLING_WEAPON = "CALLING_WEAPON";

	// Variables declared by included files, with the value they start with in this script
	SpecialattackHaste()
	{
		EFFECT_ID = "player_haste";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	// <duration> <calling weapon>
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		CALLING_WEAPON = amount;

		SetVar(Eval("game.effect.movespeed"), 500);
		SetVar(Eval("game.effect.anim.framerate"), 3.0f);
		SetVar(Eval("game.effect.canjump"), 0);

		ClientEvent("new", ENT_ME, "effects/specialattack_haste", EFFECT_DURATION);
		SetVar("local.effect.clientscript", LastClientScriptId());
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		CallExternal(CALLING_WEAPON, "turbo_off");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
