#pragma context server

// Converted from effects/effect_rejuv2.script by msc_transpiler.
// Rejuvenate2 by Thothie
// Any npc
// PARAM1 == duration (useless)
// PARAM2 == hp to heal
// PARAM3 == Caster
// - The original rejuvinate method lagged the systme to hell and back
// - in addition, it became completely unbalanced once the ability to raise Divination skill was restored
// - finally the formula was too hard to predict
// - Thus we have this simple, one-shot method
// . effectmestack effects/effect_rejuv2 0 100 GAME_MASTER

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_rejuv2"]
class EffectRejuv2 : BaseEffectScript
{
	// Variables declared by included files, with the value they start with in this script
	EffectRejuv2()
	{
		EFFECT_ID = "effect_rejuvenate";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		bool healingOther = false;

		CBaseEntity@ myId = self;

		float myMaxHealth = MaxHealthOf(myId);
		float myCurHealth = HealthOf(myId);

		if (EntityId(myId) != damage)
			healingOther = true;

		if (myCurHealth < myMaxHealth)
		{
			GiveHealth(amount);
			Effect("glow", ENT_ME, Vector3(0, 255, 0), 256, 1, 1);

			if (healingOther)
			{
				PlayerMessageGreen(damage, "You heal " + NameOf(myId) + " for " + amount + " hp");
				PlayerMessageGreen(myId, NameOf(damage) + " heals you for " + amount + " hp");
			}
			else
			{
				PlayerMessageGreen(damage, "You heal yourself for " + amount + " hp");
			}
		}
		else if (healingOther)
			PlayerMessageGreen(damage, NameOf(myId) + " is at maximum health");
		else
			PlayerMessageGreen(myId, "You are at maximum health");

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
