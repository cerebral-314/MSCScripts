#pragma context server

// Converted from effects/protection.script by msc_transpiler.
// Protection - From Ice Shield (for potions of protection)
// PARAM1 == Duration
// PARAM2 == Damage accept ratio (1.0: accept all 0.0: Accept none)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/protection"]
class Protection : BaseEffectScript
{
	// Constants
	string SOUND_CHARGE = "turret/tu_die2.wav";

	// Variables declared by included files, with the value they start with in this script
	Protection()
	{
		EFFECT_ID = "effect_protect";
		EFFECT_FLAGS = "nostack";
	}

	// game_damaged
	string Protection_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!(damage > 0.0f))
			return result;

		Effect("screenfade", ENT_ME, 0.5f, 0, Vector3(255, 255, 255), 40, "fadein");
		result = AppendResult(result, "local.effect.damage");

		PlaySound(2, 5, "player/pl_metal2.wav");
		return result;
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		SetVar("local.effect.damage", amount);

		Effect("glow", ENT_ME, Vector3(255, 255, 255), 96, EFFECT_DURATION, EFFECT_DURATION);
		PlaySound(Int(Eval("game.sound.item")), Eval("game.sound.maxvol"), "magic/heal_strike.wav");

		PlayerMessage(self, "You are protected by a magical barrier.");
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		PlaySound(0, 8, SOUND_CHARGE);
		Effect("tempent", "trail", "lgtning.spr", RelativePosition(Vector3(0, 0, 0)), RelativePosition(Vector3(0, 0, 80)), 10, 2, 5, 10, 20);
		PlayerMessage(self, "Your protection spell has expired!");
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return Protection_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

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
