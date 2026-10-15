#pragma context server

// Converted from effects/debuff_hold.script by msc_transpiler.
// Holds player/npc in place.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff_diminishing.as"

[script "effects/debuff_hold"]
class DebuffHold : BaseDebuffDiminishingScript
{
	// Variables declared by included files, with the value they start with in this script
	DebuffHold()
	{
		EFFECT_ID = "debuff_hold";
		EFFECT_FLAGS = "nostack";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (DEBUFF_SCRIPTFLAG)
			return;
		CallExternal(self, "ext_set_unfrozen");

		PlaySound(0, 10, "magic/energy1_loud.wav");
	}

	// debuff_start
	void OnDebuffStart()
	{
		BaseDebuff_OnDebuffStart(); // effects/base_debuff

		SetVar(Eval("game.effect.movespeed"), 0.001f); // 0 reads as "no limit" in the engine - Dravus
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.canduck"), 0);
		SetVar(Eval("game.effect.anim.framerate"), 0);

		SetVelocity(ENT_ME, Vector3(0, 0, 0));

		ScriptFlags(ENT_ME, "add", "hold_person", "nopush", 1, EFFECT_DURATION, "none");

		AddStatusIcon(ENT_ME, "hud/status/alpha_debuff_hold", EFFECT_ID, EFFECT_DURATION);

		CallExternal(self, "ext_set_frozen", EFFECT_DURATION);

		ClientEvent("new", "all", "effects/sfx_beam_cage", IndexOf(ENT_ME), EFFECT_DURATION);

		PlaySound(0, 10, "magic/freeze.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "debuff_start") { OnDebuffStart(); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		return BaseDebuffDiminishingScript::DispatchEvent(name, params);
	}
}
