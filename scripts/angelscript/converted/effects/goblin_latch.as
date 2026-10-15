#pragma context server

// Converted from effects/goblin_latch.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/goblin_latch"]
class GoblinLatch : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	string GOBLIN_ID = "GOBLIN_ID";
	string CL_FX = "CL_FX";

	// Variables declared by included files, with the value they start with in this script
	GoblinLatch()
	{
		EFFECT_ID = "goblin_latch";
		EFFECT_FLAGS = "nostack";
	}

	// game_damaged
	// pass damage intended for goblin
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type PARAM4=accuracy_roll PARAM5=skill
	string GoblinLatch_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (RelationshipOf(attacker, GOBLIN_ID) != "enemy")
			return result;

		string activeSkill = "none";
		if (IsPlayer(attacker))
			activeSkill = EntityId(inflictor);

		DoDamageEx(GOBLIN_ID, "direct", damage, accuracyRoll, @attacker, @attacker, activeSkill, damageType);
		return result;
	}

	// game_applyeffect
	// redirect damaging applyeffects to goblin
	// <"applyeffect"|"applyeffect"> <target> <effectscript> [params...]
	string GoblinLatch_OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "")
	{
		string result = "";

		if (!Contains(effect, "dot_"))
			return result;
		string return_ = TokenAdd("redirect", GOBLIN_ID);
		result = AppendResult(result, return_);
		return result;
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		GOBLIN_ID = amount;

		SetVar(Eval("game.effect.movespeed"), 90); // Prevents running

		if (IsPlayer(ENT_ME))
		{
			ClientEvent("new", ENT_ME, "effects/sfx_drunk", EFFECT_DURATION);
			CL_FX = LastClientScriptId();
		}
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		if (Truthy(CL_FX))
			ClientEvent("update", ENT_ME, CL_FX, "effect_die");
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return GoblinLatch_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	string OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "") { return GoblinLatch_OnGameApplyeffect(command, caller, effect, value, attacker, value2, value3, value4, value5); } // game_applyeffect

	// ext_goblin_died
	void OnExtGoblinDied()
	{
		RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "ext_goblin_died") { OnExtGoblinDied(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_applyeffect") { Return(OnGameApplyeffect(Param(params, 0), EntityParam(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8))); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
