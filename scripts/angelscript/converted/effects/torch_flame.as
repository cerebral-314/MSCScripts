#pragma context server

// Converted from effects/torch_flame.script by msc_transpiler.
// Flame Effect
// Any npc
// PARAM1 == Duration in seconds
// TODO: Get NPC's height/width and use this to define the area in which the flames spurt forth

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/torch_flame"]
class TorchFlame : BaseEffectScript
{
	// Constants
	float OFS_POS = 16.0f;
	float OFS_NEG = -16.0f;
	int OFSZ_NEG = 0;
	string LIGHT_COLOR = "LIGHT_COLOR";
	float LIGHT_RADIUS = 128.0f;
	string SPRITE_1 = "fire1_fixed.spr";

	// Variables declared by included files, with the value they start with in this script
	TorchFlame()
	{
		EFFECT_ID = "effect_flames";
		EFFECT_FLAGS = "nostack";
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		ClientEvent("new", "all", "effects/torch_flame", EFFECT_DURATION, IndexOf(ENT_ME), HeightOf(ENT_ME));
		SetVar("effect.clientscript", LastClientScriptId());
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("fire1_fixed.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
