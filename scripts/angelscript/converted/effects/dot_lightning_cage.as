#pragma context server

// Converted from effects/dot_lightning_cage.script by msc_transpiler.
// Lightning cage by Thothie
// Any npc
// Param1 - Hold Duration
// Param2 - Who to blame
// Param3 - Dmg, if any
// Param4 - Skill to give dmg to
// Param5 - most hp it can affect (def: 1500)
// . effectme effects/dot_lightning_cage 10 GAME_MASTER 0.5 spellcasting.cold 1500

#include "runtime/ScriptEntity.as"
#include "converted/effects/dot_lightning.as"

[script "effects/dot_lightning_cage"]
class DotLightningCage : DotLightningScript
{
	// Variables declared by included files, with the value they start with in this script
	DotLightningCage()
	{
		EFFECT_ID = "dot_lightning_cage";
		EFFECT_FLAGS = "nostack";
		DOT_IM_AFFECTED = "You are held in a lightning field!";
		DOT_IM_RESIST = "You resist being held in a lightning field.";
		DOT_HE_IMMUNE = "is immune to lightning magic!";
	}

	// game_activate
	// This is above the include intentionally
	void DotLightningCage_OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		MAX_HP = extraValue5; // Sets the max_hp var before dot_check_canapply is called from the include below
		if (!Truthy(extraValue5))
			MAX_HP = "1500";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		DotLightningCage_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff);
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		BaseDot_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_dot
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		DotLightning_OnEffectDie(); // effects/dot_lightning

		if (DOT_RESISTED)
			return;
		PlayerMessage(ENT_ME, "The lightning field dissipates.");

		ScriptFlags(ENT_ME, "remove", "light_cage");
		ScriptFlags(ENT_ME, "remove", DOT_FLAG_NAME);

		if (Truthy(CL_CAGE))
			ClientEvent("update", "all", CL_CAGE, "end_fx");

		PlaySound(0, 10, "magic/energy1_loud.wav");
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotLightning_OnDotStart(); // effects/dot_lightning

		SetVar(Eval("game.effect.movespeed"), 0);
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.canduck"), 0);
		SetVar(Eval("game.effect.anim.framerate"), 0);

		ScriptFlags(ENT_ME, "add", "light_cage", "nopush", 1, -1, "none");

		PlaySound(0, 10, "magic/bolt_start.wav");

		Vector3 pos = OriginOf(ENT_ME);
		if (!IsPlayer(ENT_ME))
			pos.z += Divide(HeightOf(ENT_ME), 2.0f);

		if (Truthy(CL_CAGE))
			ClientEvent("update", "all", CL_CAGE, "effect_die");
		ClientEvent("new", "all", "effects/sfx_lightning_cage", 60, pos); // It would be *shocking* if a player lasted 60 seconds in this
		CL_CAGE = LastClientScriptId();
	}

	// dot_check_canapply
	// <duration> <afflicter> <dot> <skill> <hpmax>
	void OnDotCheckCanapply()
	{
		BaseDot_OnDotCheckCanapply(); // effects/base_dot

		if (HealthOf(ENT_ME) > Float(MAX_HP))
		{
			PlayerMessage(DOT_ATTACKER, NameOf(ENT_ME) + " is too strong for a lightning field.");

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
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return DotLightningScript::DispatchEvent(name, params);
	}
}
