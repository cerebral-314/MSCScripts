#pragma context server

// Converted from effects/debuff_freeze.script by msc_transpiler.
// Freeze solid by Thothie
// Any npc
// Param1 - Freeze Duration
// . effectme effects/dot_cold_freeze 10

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_debuff_diminishing.as"

[script "effects/debuff_freeze"]
class DebuffFreeze : BaseDebuffDiminishingScript
{
	// Constants
	string SOUND_FREEZE = "magic/freeze.wav";

	// Variables (an unset .script variable reads as its own name)
	string CAGE_SCRIPT_IDX = "CAGE_SCRIPT_IDX";

	// Variables declared by included files, with the value they start with in this script
	DebuffFreeze()
	{
		EFFECT_ID = "debuff_frozen";
		EFFECT_FLAGS = "nostack";
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (!DEBUFF_STARTED)
			return;
		ClientEvent("update", "all", CAGE_SCRIPT_IDX, "end_cage_fx");
		CallExternal(ENT_ME, "freeze_solid_end");
	}

	// debuff_start
	// <duration> <attacker> <dmg> <skill> [MAX_HP]
	void OnDebuffStart()
	{
		BaseDebuff_OnDebuffStart(); // effects/base_debuff

		PlaySound(0, 10, SOUND_FREEZE);

		SetVar(Eval("game.effect.movespeed"), 0);
		SetVar(Eval("game.effect.canduck"), 0);
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.canattack"), 0);
		SetVar(Eval("game.effect.anim.framerate"), 0.01f);

		ClientEvent("new", "all", "effects/sfx_icecage", IndexOf(ENT_ME), EFFECT_DURATION);
		CAGE_SCRIPT_IDX = LastClientScriptId();

		CallExternal(ENT_ME, "freeze_solid_start", EFFECT_DURATION);

		AddStatusIcon(ENT_ME, "hud/status/alpha_debuff_frozen", EFFECT_ID, EFFECT_DURATION);
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
