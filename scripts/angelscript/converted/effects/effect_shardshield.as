#pragma context server

// Converted from effects/effect_shardshield.script by msc_transpiler.
// Burn
// Any npc
// PARAM1 == Duration
// PARAM2 == Damage accept ratio (1.0: accept all 0.0: Accept none)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_shardshield"]
class EffectShardshield : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectShardshield()
	{
		EFFECT_ID = "effect_shardshield";
		EFFECT_FLAGS = "nostack";
	}

	// game_damaged
	string EffectShardshield_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		PlaySound(2, 5, "magic/converted_magic13.wav");

		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", ENT_ME, 0.5f, 0, Vector3(255, 192, 128), 40, "fadein");
		return "local.effect.damage";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		SetVar("local.effect.damage", amount);
		SetVar(Eval("game.effect.movespeed"), 90);
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.anim.framerate"), 0.9f);
		SetVar(Eval("game.effect.canattack"), 0);

		Effect("glow", ENT_ME, Vector3(255, 192, 128), 72, EFFECT_DURATION, EFFECT_DURATION);

		PlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), "magic/cast.wav");

		PlayerMessageGreen(self, "You are protected by divine shield.");
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		PlaySound(2, 5, "magic/frost_reverse.wav");
		PlayerMessage(ENT_ME, "The divine shield fades.");
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return EffectShardshield_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
