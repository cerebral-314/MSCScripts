#pragma context server

// Converted from effects/dot_cold_freeze.script by msc_transpiler.
// Freeze solid by Thothie
// Alternative to dot_cold, in which this freezes the target still for the duration.
// Any npc
// Param1 - Freeze Duration
// Param2 - Who to blame
// Param3 - Dot DMG
// Param4 - Skill
// Param5 - most hp it can affect (def: 1500)
// . effecttarg effects/dot_cold_freeze 10 GAME_MASTER 0.5 spellcasting.cold 1500

#include "runtime/ScriptEntity.as"
#include "converted/effects/dot_cold.as"

[script "effects/dot_cold_freeze"]
class DotColdFreeze : DotColdScript
{
	// Variables declared by included files, with the value they start with in this script
	DotColdFreeze()
	{
		EFFECT_ID = "dot_cold_freeze";
		EFFECT_FLAGS = "nostack";
		DOT_IM_AFFECTED = "You have been encased in ice!";
		DOT_IM_RESIST = "You resist being frozen.";
		DOT_HE_IMMUNE = "is immune to cold magic!";
	}

	// game_activate
	// This is above the include intentionally
	void DotColdFreeze_OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		MAX_HP = extraValue5; // Sets the max_hp var before dot_check_canapply is called from the include below
		if (!Truthy(extraValue5))
			MAX_HP = "1500";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		DotColdFreeze_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff);
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		BaseDot_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_dot
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotCold_OnDotStart(); // effects/dot_cold

		ApplyEffect(ENT_ME, "effects/debuff_freeze", EFFECT_DURATION);
	}

	// dot_check_canapply
	void OnDotCheckCanapply()
	{
		BaseDot_OnDotCheckCanapply(); // effects/base_dot
		bool tooBig = false;

		if (WidthOf(ENT_ME) > 256.0f)
			tooBig = true;
		if (HeightOf(ENT_ME) > 256.0f)
			tooBig = true;
		if (tooBig)
		{
			PlayerMessage(DOT_ATTACKER, NameOf(ENT_ME) + " is too large to be encased in ice.");

			DOT_RESISTED = true;
			RemoveScript();
			return;
		}

		if (HealthOf(ENT_ME) > Float(MAX_HP))
		{
			PlayerMessage(DOT_ATTACKER, NameOf(ENT_ME) + " is too strong to be encased in ice. ( > " + int(Float(MAX_HP)) + " )");

			DOT_RESISTED = true;
			RemoveScript();
			return;
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_check_canapply") { OnDotCheckCanapply(); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return DotColdScript::DispatchEvent(name, params);
	}
}
