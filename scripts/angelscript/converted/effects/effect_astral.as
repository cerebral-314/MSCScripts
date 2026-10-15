#pragma context server

// Converted from effects/effect_astral.script by msc_transpiler.
// astral projection, players only
// lets viewpoint leave body until damaged or canceled by pressing jump

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/effect_astral"]
class EffectAstral : BaseEffectScript
{
	// Variables (an unset .script variable reads as its own name)
	bool EFFECT_ACTIVE = false;
	string CL_IDX = "CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	EffectAstral()
	{
		EFFECT_ID = "astral_project";
	}

	// game_damaged
	string EffectAstral_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		OnEffectDie();
		return result;
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		SetVar(Eval("game.effect.movespeed"), "0%");
		SetVar(Eval("game.effect.canjump"), 0);
		SetVar(Eval("game.effect.canduck"), 0);
		SetVar(Eval("game.effect.canattack"), 0);

		HelpTip(ENT_ME, "generic", "Astral Projection", "Right click to stop drifting.|Left click to return to your body.");

		ClientCommand(ENT_ME, "thirdperson");
		EFFECT_ACTIVE = true;
		ClientEvent("new", ENT_ME, "effects/effect_astral", IndexOf(ENT_ME), ViewAnglesOf(ENT_ME));
		CL_IDX = LastClientScriptId();
		OnKeyLoop();
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect
		ClientCommand(ENT_ME, "thirdperson");
		EFFECT_ACTIVE = false;
		ClientEvent("update", ENT_ME, CL_IDX, "remove_fx");
		RemoveScript();
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return EffectAstral_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// key_loop
	void OnKeyLoop()
	{
		if (!EFFECT_ACTIVE)
			return;
		CallEventDelayed(0.1f, "key_loop");

		if (IsKeyDown(ENT_ME, "attack1"))
			OnEffectDie();
		else
			ClientEvent("update", ENT_ME, CL_IDX, "key_status", IsKeyDown(ENT_ME, "forward"), IsKeyDown(ENT_ME, "back"), IsKeyDown(ENT_ME, "moveleft"), IsKeyDown(ENT_ME, "moveright"), ViewAnglesOf(ENT_ME), IsKeyDown(ENT_ME, "attack2"));
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "key_loop") { OnKeyLoop(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
